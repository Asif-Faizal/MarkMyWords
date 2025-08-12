package models

import (
	"time"

	"gorm.io/gorm"
)

type Note struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Content   string         `json:"content" gorm:"not null"`
	ThreadID  uint           `json:"thread_id" gorm:"not null"`
	Thread    Thread         `json:"thread" gorm:"foreignKey:ThreadID"`
	UserID    uint           `json:"user_id" gorm:"not null"`
	User      User           `json:"user" gorm:"foreignKey:UserID"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index"`
}

type CreateNoteRequest struct {
	Content  string `json:"content" binding:"required"`
	ThreadID uint   `json:"thread_id" binding:"required"`
}

type UpdateNoteRequest struct {
	Content string `json:"content" binding:"required"`
}

type NoteResponse struct {
	ID        uint         `json:"id"`
	Content   string       `json:"content"`
	ThreadID  uint         `json:"thread_id"`
	UserID    uint         `json:"user_id"`
	User      UserResponse `json:"user"`
	CreatedAt time.Time    `json:"created_at"`
	UpdatedAt time.Time    `json:"updated_at"`
}
