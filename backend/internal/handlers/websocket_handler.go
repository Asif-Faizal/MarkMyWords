package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"markmywords-backend/internal/types"
	wsmanager "markmywords-backend/internal/websocket"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

type WebSocketHandler struct {
	manager *wsmanager.Manager
}

func NewWebSocketHandler() *WebSocketHandler {
	return &WebSocketHandler{
		manager: wsmanager.GetManager(),
	}
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all origins for development
	},
}

func (h *WebSocketHandler) HandleWebSocket(c *gin.Context) {
	// Get user ID from query parameter
	userIDStr := c.Query("user_id")
	if userIDStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "user_id is required"})
		return
	}

	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user_id"})
		return
	}

	// Upgrade HTTP connection to WebSocket
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Printf("Error upgrading connection: %v", err)
		return
	}

	// Create WebSocket client
	client := &types.WebSocketConnection{
		UserID: uint(userID),
		Conn:   conn,
	}

	// Register client with manager
	h.manager.RegisterClient(client)

	// Handle WebSocket messages
	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			log.Printf("Error reading message: %v", err)
			h.manager.UnregisterClient(client)
			break
		}

		// Parse message
		var wsMessage types.WebSocketMessage
		if err := json.Unmarshal(message, &wsMessage); err != nil {
			log.Printf("Error parsing message: %v", err)
			continue
		}

		// Broadcast message
		h.manager.BroadcastMessage(&wsMessage)
	}
}
