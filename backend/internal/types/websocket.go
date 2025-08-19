package types

type WebSocketMessage struct {
	Type    string      `json:"type"`
	Payload interface{} `json:"payload"`
}

type ThreadJoinMessage struct {
	ThreadID uint `json:"thread_id"`
	UserID   uint `json:"user_id"`
}

type ThreadLeaveMessage struct {
	ThreadID uint `json:"thread_id"`
	UserID   uint `json:"user_id"`
}

type NoteAddMessage struct {
	ThreadID uint         `json:"thread_id"`
	Note     NoteResponse `json:"note"`
}

type NoteUpdateMessage struct {
	ThreadID uint         `json:"thread_id"`
	Note     NoteResponse `json:"note"`
}

type NoteDeleteMessage struct {
	ThreadID uint `json:"thread_id"`
	NoteID   uint `json:"note_id"`
}

type UserTypingMessage struct {
	ThreadID uint   `json:"thread_id"`
	UserID   uint   `json:"user_id"`
	Username string `json:"username"`
}

type ThreadSession struct {
	ThreadID uint
	Users    map[uint]*WebSocketConnection
}

type WebSocketConnection struct {
	UserID uint
	Conn   interface{} // This will be the actual WebSocket connection
}
