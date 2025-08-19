package services

import (
	"errors"

	"markmywords-backend/internal/types"
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

func (s *InviteService) CreateInvite(req *types.CreateInviteRequest, fromUserID uint) (*types.InviteResponse, error) {
	// Check if thread exists and user owns it
	var thread types.Thread
	if err := s.db.First(&thread, req.ThreadID).Error; err != nil {
		return nil, errors.New("thread not found")
	}

	if thread.UserID != fromUserID {
		return nil, errors.New("access denied")
	}

	// Check if target user exists
	var toUser types.User
	if err := s.db.First(&toUser, req.ToUserID).Error; err != nil {
		return nil, errors.New("target user not found")
	}

	// Check if invite already exists
	var existingInvite types.Invite
	if err := s.db.Where("thread_id = ? AND to_user_id = ? AND status = ?",
		req.ThreadID, req.ToUserID, types.InviteStatusPending).First(&existingInvite).Error; err == nil {
		return nil, errors.New("invite already exists")
	}

	// Check if user is already a collaborator
	var existingCollaborator types.ThreadCollaborator
	if err := s.db.Where("thread_id = ? AND user_id = ?", req.ThreadID, req.ToUserID).First(&existingCollaborator).Error; err == nil {
		return nil, errors.New("user is already a collaborator")
	}

	invite := types.Invite{
		ThreadID:   req.ThreadID,
		FromUserID: fromUserID,
		ToUserID:   req.ToUserID,
		Status:     types.InviteStatusPending,
	}

	if err := s.db.Create(&invite).Error; err != nil {
		return nil, err
	}

	return s.GetInviteByID(invite.ID)
}

func (s *InviteService) GetUserInvites(userID uint) ([]types.InviteResponse, error) {
	var invites []types.Invite
	err := s.db.Where("to_user_id = ?", userID).
		Preload("Thread").
		Preload("FromUser").
		Preload("ToUser").
		Find(&invites).Error

	if err != nil {
		return nil, err
	}

	var responses []types.InviteResponse
	for _, invite := range invites {
		response := types.InviteResponse{
			ID:         invite.ID,
			ThreadID:   invite.ThreadID,
			FromUserID: invite.FromUserID,
			ToUserID:   invite.ToUserID,
			Status:     invite.Status,
			CreatedAt:  invite.CreatedAt,
			UpdatedAt:  invite.UpdatedAt,
		}

		if invite.Thread.ID != 0 {
			response.Thread = types.ThreadResponse{
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
			response.FromUser = types.UserResponse{
				ID:        invite.FromUser.ID,
				Email:     invite.FromUser.Email,
				Username:  invite.FromUser.Username,
				FirstName: invite.FromUser.FirstName,
				LastName:  invite.FromUser.LastName,
				CreatedAt: invite.FromUser.CreatedAt,
			}
		}

		if invite.ToUser.ID != 0 {
			response.ToUser = types.UserResponse{
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
	var invite types.Invite
	if err := s.db.First(&invite, inviteID).Error; err != nil {
		return errors.New("invite not found")
	}

	if invite.ToUserID != userID {
		return errors.New("access denied")
	}

	if invite.Status != types.InviteStatusPending {
		return errors.New("invite is not pending")
	}

	// Start a transaction
	tx := s.db.Begin()

	// Update invite status
	if err := tx.Model(&invite).Update("status", types.InviteStatusAccepted).Error; err != nil {
		tx.Rollback()
		return err
	}

	// Add user as collaborator
	collaborator := types.ThreadCollaborator{
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
	var invite types.Invite
	if err := s.db.First(&invite, inviteID).Error; err != nil {
		return errors.New("invite not found")
	}

	if invite.ToUserID != userID {
		return errors.New("access denied")
	}

	if invite.Status != types.InviteStatusPending {
		return errors.New("invite is not pending")
	}

	return s.db.Model(&invite).Update("status", types.InviteStatusDeclined).Error
}

func (s *InviteService) GetInviteByID(inviteID uint) (*types.InviteResponse, error) {
	var invite types.Invite
	err := s.db.Where("id = ?", inviteID).
		Preload("Thread").
		Preload("FromUser").
		Preload("ToUser").
		First(&invite).Error

	if err != nil {
		return nil, err
	}

	response := types.InviteResponse{
		ID:         invite.ID,
		ThreadID:   invite.ThreadID,
		FromUserID: invite.FromUserID,
		ToUserID:   invite.ToUserID,
		Status:     invite.Status,
		CreatedAt:  invite.CreatedAt,
		UpdatedAt:  invite.UpdatedAt,
	}

	if invite.Thread.ID != 0 {
		response.Thread = types.ThreadResponse{
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
		response.FromUser = types.UserResponse{
			ID:        invite.FromUser.ID,
			Email:     invite.FromUser.Email,
			Username:  invite.FromUser.Username,
			FirstName: invite.FromUser.FirstName,
			LastName:  invite.FromUser.LastName,
			CreatedAt: invite.FromUser.CreatedAt,
		}
	}

	if invite.ToUser.ID != 0 {
		response.ToUser = types.UserResponse{
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
