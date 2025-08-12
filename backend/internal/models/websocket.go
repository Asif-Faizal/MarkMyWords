package models

import "time"

type WebSocketMessage struct {
	Type    string      `json:"type"`
	Payload interface{} `json:"payload"`
	UserID  uint        `json:"user_id,omitempty"`
}

type NoteJoinMessage struct {
	NoteID uint `json:"note_id"`
}

type NoteLeaveMessage struct {
	NoteID uint `json:"note_id"`
}

type NoteUpdateMessage struct {
	NoteID  uint      `json:"note_id"`
	Content string    `json:"content"`
	Title   string    `json:"title"`
	UserID  uint      `json:"user_id"`
	Time    time.Time `json:"time"`
}

type UserTypingMessage struct {
	NoteID   uint `json:"note_id"`
	UserID   uint `json:"user_id"`
	IsTyping bool `json:"is_typing"`
}

type NoteSession struct {
	NoteID   uint
	UserID   uint
	Conn     *WebSocketConnection
	IsTyping bool
	LastSeen time.Time
}

type WebSocketConnection struct {
	ID     string
	UserID uint
	Send   chan []byte
	NoteID uint
}
