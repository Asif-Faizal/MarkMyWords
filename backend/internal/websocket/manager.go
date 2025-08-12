package websocket

import (
	"encoding/json"
	"log"
	"sync"

	"markmywords-backend/internal/models"
	"github.com/gorilla/websocket"
)

type Manager struct {
	threadSessions map[uint]*models.ThreadSession
	clients        map[uint]*models.WebSocketConnection
	register       chan *models.WebSocketConnection
	unregister     chan *models.WebSocketConnection
	broadcast      chan *models.WebSocketMessage
	mutex          sync.RWMutex
}

func NewManager() *Manager {
	return &Manager{
		threadSessions: make(map[uint]*models.ThreadSession),
		clients:        make(map[uint]*models.WebSocketConnection),
		register:       make(chan *models.WebSocketConnection),
		unregister:     make(chan *models.WebSocketConnection),
		broadcast:      make(chan *models.WebSocketMessage),
	}
}

func (m *Manager) Start() {
	for {
		select {
		case client := <-m.register:
			m.mutex.Lock()
			m.clients[client.UserID] = client
			m.mutex.Unlock()
			log.Printf("Client registered: UserID=%d", client.UserID)

		case client := <-m.unregister:
			m.mutex.Lock()
			if _, ok := m.clients[client.UserID]; ok {
				delete(m.clients, client.UserID)
			}
			// Remove from all thread sessions
			for threadID, session := range m.threadSessions {
				if _, ok := session.Users[client.UserID]; ok {
					delete(session.Users, client.UserID)
					if len(session.Users) == 0 {
						delete(m.threadSessions, threadID)
					}
				}
			}
			m.mutex.Unlock()
			log.Printf("Client unregistered: UserID=%d", client.UserID)

		case message := <-m.broadcast:
			m.handleMessage(message)
		}
	}
}

func (m *Manager) handleMessage(message *models.WebSocketMessage) {
	switch message.Type {
	case "thread_join":
		var joinMsg models.ThreadJoinMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &joinMsg); err == nil {
				m.handleThreadJoin(joinMsg)
			}
		}

	case "thread_leave":
		var leaveMsg models.ThreadLeaveMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &leaveMsg); err == nil {
				m.handleThreadLeave(leaveMsg)
			}
		}

	case "note_add":
		var noteMsg models.NoteAddMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &noteMsg); err == nil {
				m.handleNoteAdd(noteMsg)
			}
		}

	case "note_update":
		var noteMsg models.NoteUpdateMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &noteMsg); err == nil {
				m.handleNoteUpdate(noteMsg)
			}
		}

	case "note_delete":
		var noteMsg models.NoteDeleteMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &noteMsg); err == nil {
				m.handleNoteDelete(noteMsg)
			}
		}

	case "user_typing":
		var typingMsg models.UserTypingMessage
		if data, err := json.Marshal(message.Payload); err == nil {
			if err := json.Unmarshal(data, &typingMsg); err == nil {
				m.handleUserTyping(typingMsg)
			}
		}
	}
}

func (m *Manager) handleThreadJoin(msg models.ThreadJoinMessage) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if session, exists := m.threadSessions[msg.ThreadID]; exists {
		if client, ok := m.clients[msg.UserID]; ok {
			session.Users[msg.UserID] = client
		}
	} else {
		session := &models.ThreadSession{
			ThreadID: msg.ThreadID,
			Users:    make(map[uint]*models.WebSocketConnection),
		}
		if client, ok := m.clients[msg.UserID]; ok {
			session.Users[msg.UserID] = client
		}
		m.threadSessions[msg.ThreadID] = session
	}

	// Notify other users in the thread
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type: "user_joined",
		Payload: map[string]interface{}{
			"thread_id": msg.ThreadID,
			"user_id":   msg.UserID,
		},
	}, msg.UserID)
}

func (m *Manager) handleThreadLeave(msg models.ThreadLeaveMessage) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if session, exists := m.threadSessions[msg.ThreadID]; exists {
		delete(session.Users, msg.UserID)
		if len(session.Users) == 0 {
			delete(m.threadSessions, msg.ThreadID)
		}
	}

	// Notify other users in the thread
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type: "user_left",
		Payload: map[string]interface{}{
			"thread_id": msg.ThreadID,
			"user_id":   msg.UserID,
		},
	}, msg.UserID)
}

func (m *Manager) handleNoteAdd(msg models.NoteAddMessage) {
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type:    "note_added",
		Payload: msg.Note,
	}, 0)
}

func (m *Manager) handleNoteUpdate(msg models.NoteUpdateMessage) {
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type:    "note_updated",
		Payload: msg.Note,
	}, 0)
}

func (m *Manager) handleNoteDelete(msg models.NoteDeleteMessage) {
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type: "note_deleted",
		Payload: map[string]interface{}{
			"thread_id": msg.ThreadID,
			"note_id":   msg.NoteID,
		},
	}, 0)
}

func (m *Manager) handleUserTyping(msg models.UserTypingMessage) {
	m.broadcastToThread(msg.ThreadID, &models.WebSocketMessage{
		Type: "user_typing",
		Payload: map[string]interface{}{
			"thread_id": msg.ThreadID,
			"user_id":   msg.UserID,
			"username":  msg.Username,
		},
	}, msg.UserID)
}

func (m *Manager) broadcastToThread(threadID uint, message *models.WebSocketMessage, excludeUserID uint) {
	if session, exists := m.threadSessions[threadID]; exists {
		data, err := json.Marshal(message)
		if err != nil {
			log.Printf("Error marshaling message: %v", err)
			return
		}

		for userID, client := range session.Users {
			if userID != excludeUserID {
				if conn, ok := client.Conn.(*websocket.Conn); ok {
					if err := conn.WriteMessage(websocket.TextMessage, data); err != nil {
						log.Printf("Error sending message to user %d: %v", userID, err)
						conn.Close()
						delete(session.Users, userID)
					}
				}
			}
		}
	}
}

// Public methods for external use
func (m *Manager) RegisterClient(client *models.WebSocketConnection) {
	m.register <- client
}

func (m *Manager) UnregisterClient(client *models.WebSocketConnection) {
	m.unregister <- client
}

func (m *Manager) BroadcastMessage(message *models.WebSocketMessage) {
	m.broadcast <- message
}

// Global manager instance
var globalManager *Manager

func GetManager() *Manager {
	if globalManager == nil {
		globalManager = NewManager()
		go globalManager.Start()
	}
	return globalManager
}
