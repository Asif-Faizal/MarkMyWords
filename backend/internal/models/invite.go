package models

import (
	"time"

	"gorm.io/gorm"
)

type InviteStatus string

const (
	InviteStatusPending  InviteStatus = "pending"
	InviteStatusAccepted InviteStatus = "accepted"
	InviteStatusDeclined InviteStatus = "declined"
)

type Invite struct {
	ID         uint           `json:"id" gorm:"primaryKey"`
	ThreadID   uint           `json:"thread_id" gorm:"not null"`
	Thread     Thread         `json:"thread" gorm:"foreignKey:ThreadID"`
	FromUserID uint           `json:"from_user_id" gorm:"not null"`
	FromUser   User           `json:"from_user" gorm:"foreignKey:FromUserID"`
	ToUserID   uint           `json:"to_user_id" gorm:"not null"`
	ToUser     User           `json:"to_user" gorm:"foreignKey:ToUserID"`
	Status     InviteStatus   `json:"status" gorm:"default:'pending'"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index"`
}

type CreateInviteRequest struct {
	ThreadID uint `json:"thread_id" binding:"required"`
	ToUserID uint `json:"to_user_id" binding:"required"`
}

type InviteResponse struct {
	ID         uint           `json:"id"`
	ThreadID   uint           `json:"thread_id"`
	Thread     ThreadResponse `json:"thread"`
	FromUserID uint           `json:"from_user_id"`
	FromUser   UserResponse   `json:"from_user"`
	ToUserID   uint           `json:"to_user_id"`
	ToUser     UserResponse   `json:"to_user"`
	Status     InviteStatus   `json:"status"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
}
