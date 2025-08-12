package models

import (
	"time"

	"gorm.io/gorm"
)

type Invite struct {
	ID         uint           `json:"id" gorm:"primaryKey"`
	NoteID     uint           `json:"note_id" gorm:"not null"`
	FromUserID uint           `json:"from_user_id" gorm:"not null"`
	ToUserID   uint           `json:"to_user_id" gorm:"not null"`
	Status     InviteStatus   `json:"status" gorm:"default:'pending'"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `json:"-" gorm:"index"`

	// Relationships
	Note     Note `json:"note,omitempty"`
	FromUser User `json:"from_user,omitempty"`
	ToUser   User `json:"to_user,omitempty"`
}

type InviteStatus string

const (
	InviteStatusPending  InviteStatus = "pending"
	InviteStatusAccepted InviteStatus = "accepted"
	InviteStatusDeclined InviteStatus = "declined"
)

type CreateInviteRequest struct {
	NoteID   uint `json:"note_id" binding:"required"`
	ToUserID uint `json:"to_user_id" binding:"required"`
}

type InviteResponse struct {
	ID         uint         `json:"id"`
	NoteID     uint         `json:"note_id"`
	FromUserID uint         `json:"from_user_id"`
	ToUserID   uint         `json:"to_user_id"`
	Status     InviteStatus `json:"status"`
	CreatedAt  time.Time    `json:"created_at"`
	UpdatedAt  time.Time    `json:"updated_at"`
	Note       NoteResponse `json:"note,omitempty"`
	FromUser   UserResponse `json:"from_user,omitempty"`
	ToUser     UserResponse `json:"to_user,omitempty"`
}
