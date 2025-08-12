package websocket

import (
	"encoding/json"
	"log"
	"sync"
	"time"

	"markmywords-backend/internal/models"
)

type Manager struct {
	clients    map[string]*models.WebSocketConnection
	noteRooms  map[uint]map[string]*models.NoteSession
	broadcast  chan models.WebSocketMessage
	register   chan *models.WebSocketConnection
	unregister chan *models.WebSocketConnection
	mutex      sync.RWMutex
}

func NewManager() *Manager {
	return &Manager{
		clients:    make(map[string]*models.WebSocketConnection),
		noteRooms:  make(map[uint]map[string]*models.NoteSession),
		broadcast:  make(chan models.WebSocketMessage),
		register:   make(chan *models.WebSocketConnection),
		unregister: make(chan *models.WebSocketConnection),
	}
}

func (m *Manager) Start() {
	for {
		select {
		case client := <-m.register:
			m.mutex.Lock()
			m.clients[client.ID] = client
			m.mutex.Unlock()

		case client := <-m.unregister:
			m.mutex.Lock()
			if _, ok := m.clients[client.ID]; ok {
				delete(m.clients, client.ID)
				close(client.Send)
			}
			// Remove from note rooms
			if client.NoteID != 0 {
				if room, exists := m.noteRooms[client.NoteID]; exists {
					delete(room, client.ID)
					if len(room) == 0 {
						delete(m.noteRooms, client.NoteID)
					}
				}
			}
			m.mutex.Unlock()

		case message := <-m.broadcast:
			m.handleMessage(message)
		}
	}
}

func (m *Manager) handleMessage(message models.WebSocketMessage) {
	switch message.Type {
	case "note:join":
		m.handleNoteJoin(message)
	case "note:leave":
		m.handleNoteLeave(message)
	case "note:update":
		m.handleNoteUpdate(message)
	case "note:user_typing":
		m.handleUserTyping(message)
	}
}

func (m *Manager) handleNoteJoin(message models.WebSocketMessage) {
	var joinMsg models.NoteJoinMessage
	if data, ok := message.Payload.(map[string]interface{}); ok {
		if noteID, ok := data["note_id"].(float64); ok {
			joinMsg.NoteID = uint(noteID)
		}
	}

	m.mutex.Lock()
	if m.noteRooms[joinMsg.NoteID] == nil {
		m.noteRooms[joinMsg.NoteID] = make(map[string]*models.NoteSession)
	}

	// Find the client
	var client *models.WebSocketConnection
	for _, c := range m.clients {
		if c.UserID == message.UserID {
			client = c
			break
		}
	}

	if client != nil {
		client.NoteID = joinMsg.NoteID
		session := &models.NoteSession{
			NoteID:   joinMsg.NoteID,
			UserID:   message.UserID,
			Conn:     client,
			LastSeen: time.Now(),
		}
		m.noteRooms[joinMsg.NoteID][client.ID] = session
	}
	m.mutex.Unlock()

	// Notify other users in the room
	m.broadcastToNote(joinMsg.NoteID, models.WebSocketMessage{
		Type: "note:user_joined",
		Payload: map[string]interface{}{
			"user_id": message.UserID,
		},
	})
}

func (m *Manager) handleNoteLeave(message models.WebSocketMessage) {
	var leaveMsg models.NoteLeaveMessage
	if data, ok := message.Payload.(map[string]interface{}); ok {
		if noteID, ok := data["note_id"].(float64); ok {
			leaveMsg.NoteID = uint(noteID)
		}
	}

	m.mutex.Lock()
	if room, exists := m.noteRooms[leaveMsg.NoteID]; exists {
		for clientID, session := range room {
			if session.UserID == message.UserID {
				delete(room, clientID)
				break
			}
		}
		if len(room) == 0 {
			delete(m.noteRooms, leaveMsg.NoteID)
		}
	}
	m.mutex.Unlock()

	// Notify other users in the room
	m.broadcastToNote(leaveMsg.NoteID, models.WebSocketMessage{
		Type: "note:user_left",
		Payload: map[string]interface{}{
			"user_id": message.UserID,
		},
	})
}

func (m *Manager) handleNoteUpdate(message models.WebSocketMessage) {
	var updateMsg models.NoteUpdateMessage
	if data, ok := message.Payload.(map[string]interface{}); ok {
		if noteID, ok := data["note_id"].(float64); ok {
			updateMsg.NoteID = uint(noteID)
		}
		if content, ok := data["content"].(string); ok {
			updateMsg.Content = content
		}
		if title, ok := data["title"].(string); ok {
			updateMsg.Title = title
		}
		updateMsg.UserID = message.UserID
		updateMsg.Time = time.Now()
	}

	// Broadcast to all users in the note room except the sender
	m.broadcastToNoteExcept(updateMsg.NoteID, message.UserID, models.WebSocketMessage{
		Type:    "note:update",
		Payload: updateMsg,
	})
}

func (m *Manager) handleUserTyping(message models.WebSocketMessage) {
	var typingMsg models.UserTypingMessage
	if data, ok := message.Payload.(map[string]interface{}); ok {
		if noteID, ok := data["note_id"].(float64); ok {
			typingMsg.NoteID = uint(noteID)
		}
		if isTyping, ok := data["is_typing"].(bool); ok {
			typingMsg.IsTyping = isTyping
		}
		typingMsg.UserID = message.UserID
	}

	// Broadcast to all users in the note room except the sender
	m.broadcastToNoteExcept(typingMsg.NoteID, message.UserID, models.WebSocketMessage{
		Type:    "note:user_typing",
		Payload: typingMsg,
	})
}

func (m *Manager) broadcastToNote(noteID uint, message models.WebSocketMessage) {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	if room, exists := m.noteRooms[noteID]; exists {
		data, err := json.Marshal(message)
		if err != nil {
			log.Printf("Error marshaling message: %v", err)
			return
		}

		for _, session := range room {
			select {
			case session.Conn.Send <- data:
			default:
				close(session.Conn.Send)
				delete(room, session.Conn.ID)
			}
		}
	}
}

func (m *Manager) broadcastToNoteExcept(noteID uint, exceptUserID uint, message models.WebSocketMessage) {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	if room, exists := m.noteRooms[noteID]; exists {
		data, err := json.Marshal(message)
		if err != nil {
			log.Printf("Error marshaling message: %v", err)
			return
		}

		for _, session := range room {
			if session.UserID != exceptUserID {
				select {
				case session.Conn.Send <- data:
				default:
					close(session.Conn.Send)
					delete(room, session.Conn.ID)
				}
			}
		}
	}
}

func (m *Manager) GetManager() *Manager {
	return m
}

// RegisterClient registers a new WebSocket client
func (m *Manager) RegisterClient(client *models.WebSocketConnection) {
	m.register <- client
}

// UnregisterClient unregisters a WebSocket client
func (m *Manager) UnregisterClient(client *models.WebSocketConnection) {
	m.unregister <- client
}

// BroadcastMessage broadcasts a message to all clients
func (m *Manager) BroadcastMessage(message models.WebSocketMessage) {
	m.broadcast <- message
}
