package models

import (
	"time"

	"gorm.io/gorm"
)

type Note struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Title     string         `json:"title" gorm:"not null"`
	Content   string         `json:"content"`
	IsPrivate bool           `json:"is_private" gorm:"default:true"`
	UserID    uint           `json:"user_id" gorm:"not null"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`

	// Relationships
	User          User               `json:"user,omitempty"`
	Collaborators []NoteCollaborator `json:"collaborators,omitempty"`
}

type NoteCollaborator struct {
	ID     uint `json:"id" gorm:"primaryKey"`
	NoteID uint `json:"note_id" gorm:"not null"`
	UserID uint `json:"user_id" gorm:"not null"`

	// Relationships
	Note Note `json:"note,omitempty"`
	User User `json:"user,omitempty"`
}

type CreateNoteRequest struct {
	Title     string `json:"title" binding:"required"`
	Content   string `json:"content"`
	IsPrivate bool   `json:"is_private"`
}

type UpdateNoteRequest struct {
	Title     string `json:"title"`
	Content   string `json:"content"`
	IsPrivate *bool  `json:"is_private"`
}

type NoteResponse struct {
	ID            uint           `json:"id"`
	Title         string         `json:"title"`
	Content       string         `json:"content"`
	IsPrivate     bool           `json:"is_private"`
	UserID        uint           `json:"user_id"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	User          UserResponse   `json:"user,omitempty"`
	Collaborators []UserResponse `json:"collaborators,omitempty"`
}
