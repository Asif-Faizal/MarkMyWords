package services

import (
	"errors"

	"markmywords-backend/internal/models"
	"markmywords-backend/pkg/database"

	"gorm.io/gorm"
)

type InviteService struct {
	db *gorm.DB
}

func NewInviteService() *InviteService {
	return &InviteService{
		db: database.GetDB(),
	}
}

func (s *InviteService) CreateInvite(req *models.CreateInviteRequest, fromUserID uint) (*models.InviteResponse, error) {
	// Check if thread exists and user owns it
	var thread models.Thread
	if err := s.db.First(&thread, req.ThreadID).Error; err != nil {
		return nil, errors.New("thread not found")
	}

	if thread.UserID != fromUserID {
		return nil, errors.New("access denied")
	}

	// Check if target user exists
	var toUser models.User
	if err := s.db.First(&toUser, req.ToUserID).Error; err != nil {
		return nil, errors.New("target user not found")
	}

	// Check if invite already exists
	var existingInvite models.Invite
	if err := s.db.Where("thread_id = ? AND to_user_id = ? AND status = ?", 
		req.ThreadID, req.ToUserID, models.InviteStatusPending).First(&existingInvite).Error; err == nil {
		return nil, errors.New("invite already exists")
	}

	// Check if user is already a collaborator
	var existingCollaborator models.ThreadCollaborator
	if err := s.db.Where("thread_id = ? AND user_id = ?", req.ThreadID, req.ToUserID).First(&existingCollaborator).Error; err == nil {
		return nil, errors.New("user is already a collaborator")
	}

	invite := models.Invite{
		ThreadID:   req.ThreadID,
		FromUserID: fromUserID,
		ToUserID:   req.ToUserID,
		Status:     models.InviteStatusPending,
	}

	if err := s.db.Create(&invite).Error; err != nil {
		return nil, err
	}

	return s.GetInviteByID(invite.ID)
}

func (s *InviteService) GetUserInvites(userID uint) ([]models.InviteResponse, error) {
	var invites []models.Invite
	err := s.db.Where("to_user_id = ?", userID).
		Preload("Thread").
		Preload("FromUser").
		Preload("ToUser").
		Find(&invites).Error

	if err != nil {
		return nil, err
	}

	var responses []models.InviteResponse
	for _, invite := range invites {
		response := models.InviteResponse{
			ID:         invite.ID,
			ThreadID:   invite.ThreadID,
			FromUserID: invite.FromUserID,
			ToUserID:   invite.ToUserID,
			Status:     invite.Status,
			CreatedAt:  invite.CreatedAt,
			UpdatedAt:  invite.UpdatedAt,
		}

		if invite.Thread.ID != 0 {
			response.Thread = models.ThreadResponse{
				ID:          invite.Thread.ID,
				Title:       invite.Thread.Title,
				Description: invite.Thread.Description,
				IsPrivate:   invite.Thread.IsPrivate,
				UserID:      invite.Thread.UserID,
				CreatedAt:   invite.Thread.CreatedAt,
				UpdatedAt:   invite.Thread.UpdatedAt,
			}
		}

		if invite.FromUser.ID != 0 {
			response.FromUser = models.UserResponse{
				ID:        invite.FromUser.ID,
				Email:     invite.FromUser.Email,
				Username:  invite.FromUser.Username,
				FirstName: invite.FromUser.FirstName,
				LastName:  invite.FromUser.LastName,
				CreatedAt: invite.FromUser.CreatedAt,
			}
		}

		if invite.ToUser.ID != 0 {
			response.ToUser = models.UserResponse{
				ID:        invite.ToUser.ID,
				Email:     invite.ToUser.Email,
				Username:  invite.ToUser.Username,
				FirstName: invite.ToUser.FirstName,
				LastName:  invite.ToUser.LastName,
				CreatedAt: invite.ToUser.CreatedAt,
			}
		}

		responses = append(responses, response)
	}

	return responses, nil
}

func (s *InviteService) AcceptInvite(inviteID, userID uint) error {
	var invite models.Invite
	if err := s.db.First(&invite, inviteID).Error; err != nil {
		return errors.New("invite not found")
	}

	if invite.ToUserID != userID {
		return errors.New("access denied")
	}

	if invite.Status != models.InviteStatusPending {
		return errors.New("invite is not pending")
	}

	// Start a transaction
	tx := s.db.Begin()

	// Update invite status
	if err := tx.Model(&invite).Update("status", models.InviteStatusAccepted).Error; err != nil {
		tx.Rollback()
		return err
	}

	// Add user as collaborator
	collaborator := models.ThreadCollaborator{
		ThreadID: invite.ThreadID,
		UserID:   userID,
	}

	if err := tx.Create(&collaborator).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

func (s *InviteService) DeclineInvite(inviteID, userID uint) error {
	var invite models.Invite
	if err := s.db.First(&invite, inviteID).Error; err != nil {
		return errors.New("invite not found")
	}

	if invite.ToUserID != userID {
		return errors.New("access denied")
	}

	if invite.Status != models.InviteStatusPending {
		return errors.New("invite is not pending")
	}

	return s.db.Model(&invite).Update("status", models.InviteStatusDeclined).Error
}

func (s *InviteService) GetInviteByID(inviteID uint) (*models.InviteResponse, error) {
	var invite models.Invite
	err := s.db.Where("id = ?", inviteID).
		Preload("Thread").
		Preload("FromUser").
		Preload("ToUser").
		First(&invite).Error

	if err != nil {
		return nil, err
	}

	response := models.InviteResponse{
		ID:         invite.ID,
		ThreadID:   invite.ThreadID,
		FromUserID: invite.FromUserID,
		ToUserID:   invite.ToUserID,
		Status:     invite.Status,
		CreatedAt:  invite.CreatedAt,
		UpdatedAt:  invite.UpdatedAt,
	}

	if invite.Thread.ID != 0 {
		response.Thread = models.ThreadResponse{
			ID:          invite.Thread.ID,
			Title:       invite.Thread.Title,
			Description: invite.Thread.Description,
			IsPrivate:   invite.Thread.IsPrivate,
			UserID:      invite.Thread.UserID,
			CreatedAt:   invite.Thread.CreatedAt,
			UpdatedAt:   invite.Thread.UpdatedAt,
		}
	}

	if invite.FromUser.ID != 0 {
		response.FromUser = models.UserResponse{
			ID:        invite.FromUser.ID,
			Email:     invite.FromUser.Email,
			Username:  invite.FromUser.Username,
			FirstName: invite.FromUser.FirstName,
			LastName:  invite.FromUser.LastName,
			CreatedAt: invite.FromUser.CreatedAt,
		}
	}

	if invite.ToUser.ID != 0 {
		response.ToUser = models.UserResponse{
			ID:        invite.ToUser.ID,
			Email:     invite.ToUser.Email,
			Username:  invite.ToUser.Username,
			FirstName: invite.ToUser.FirstName,
			LastName:  invite.ToUser.LastName,
			CreatedAt: invite.ToUser.CreatedAt,
		}
	}

	return &response, nil
}
