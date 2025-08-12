package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"markmywords-backend/internal/models"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all origins for development
	},
}

type WebSocketHandler struct {
	manager *wsmanager.Manager
}

func NewWebSocketHandler() *WebSocketHandler {
	return &WebSocketHandler{
		manager: wsmanager.NewManager(),
	}
}

func (h *WebSocketHandler) HandleWebSocket(c *gin.Context) {
	// Get user ID from query parameter (in production, use proper auth)
	userIDStr := c.Query("user_id")
	if userIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "user_id required"})
		return
	}

	// Upgrade HTTP connection to WebSocket
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("Error upgrading connection: %v", err)
		return
	}

	// Create WebSocket connection
	wsConn := &models.WebSocketConnection{
		ID:     generateID(),
		UserID: 0, // Will be set from token in production
		Send:   make(chan []byte, 256),
	}

	// Register connection with manager
	h.manager.Register <- wsConn

	// Start goroutines for reading and writing
	go h.readPump(conn, wsConn)
	go h.writePump(conn, wsConn)
}

func (h *WebSocketHandler) readPump(conn *websocket.Conn, wsConn *models.WebSocketConnection) {
	defer func() {
		h.manager.Unregister <- wsConn
		conn.Close()
	}()

	conn.SetReadLimit(512)
	conn.SetReadDeadline(time.Now().Add(60 * time.Second))
	conn.SetPongHandler(func(string) error {
		conn.SetReadDeadline(time.Now().Add(60 * time.Second))
		return nil
	})

	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("Error reading message: %v", err)
			}
			break
		}

		// Parse message
		var wsMessage models.WebSocketMessage
		if err := json.Unmarshal(message, &wsMessage); err != nil {
			log.Printf("Error unmarshaling message: %v", err)
			continue
		}

		// Set user ID from connection
		wsMessage.UserID = wsConn.UserID

		// Send to manager
		h.manager.Broadcast <- wsMessage
	}
}

func (h *WebSocketHandler) writePump(conn *websocket.Conn, wsConn *models.WebSocketConnection) {
	ticker := time.NewTicker(54 * time.Second)
	defer func() {
		ticker.Stop()
		conn.Close()
	}()

	for {
		select {
		case message, ok := <-wsConn.Send:
			conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			if !ok {
				conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			if err := w.Close(); err != nil {
				return
			}
		case <-ticker.C:
			conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			if err := conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}

func generateID() string {
	return time.Now().Format("20060102150405") + "-" + time.Now().Format("000000000")
}

func (h *WebSocketHandler) GetManager() *wsmanager.Manager {
	return h.manager
}
