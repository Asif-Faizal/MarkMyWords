package models

import (
	"time"

	"gorm.io/gorm"
)

type Thread struct {
	ID            uint                 `json:"id" gorm:"primaryKey"`
	Title         string               `json:"title" gorm:"not null"`
	Description   string               `json:"description"`
	IsPrivate     bool                 `json:"is_private" gorm:"default:true"`
	UserID        uint                 `json:"user_id" gorm:"not null"`
	User          User                 `json:"user" gorm:"foreignKey:UserID"`
	Collaborators []ThreadCollaborator `json:"collaborators" gorm:"foreignKey:ThreadID"`
	Notes         []Note               `json:"notes" gorm:"foreignKey:ThreadID"`
	CreatedAt     time.Time            `json:"created_at"`
	UpdatedAt     time.Time            `json:"updated_at"`
	DeletedAt     gorm.DeletedAt       `json:"deleted_at,omitempty" gorm:"index"`
}

type ThreadCollaborator struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	ThreadID  uint      `json:"thread_id" gorm:"not null"`
	UserID    uint      `json:"user_id" gorm:"not null"`
	User      User      `json:"user" gorm:"foreignKey:UserID"`
	CreatedAt time.Time `json:"created_at"`
}

type CreateThreadRequest struct {
	Title       string `json:"title" binding:"required"`
	Description string `json:"description"`
	IsPrivate   bool   `json:"is_private"`
}

type UpdateThreadRequest struct {
	Title       string `json:"title"`
	Description string `json:"description"`
	IsPrivate   *bool  `json:"is_private"`
}

type ThreadResponse struct {
	ID            uint           `json:"id"`
	Title         string         `json:"title"`
	Description   string         `json:"description"`
	IsPrivate     bool           `json:"is_private"`
	UserID        uint           `json:"user_id"`
	User          UserResponse   `json:"user"`
	Collaborators []UserResponse `json:"collaborators"`
	NotesCount    int            `json:"notes_count"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
}
