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
	// Check if note exists and user owns it
	var note models.Note
	if err := s.db.First(&note, req.NoteID).Error; err != nil {
		return nil, errors.New("note not found")
	}

	if note.UserID != fromUserID {
		return nil, errors.New("access denied")
	}

	// Check if target user exists
	var toUser models.User
	if err := s.db.First(&toUser, req.ToUserID).Error; err != nil {
		return nil, errors.New("user not found")
	}

	// Check if invite already exists
	var existingInvite models.Invite
	if err := s.db.Where("note_id = ? AND to_user_id = ? AND status = ?",
		req.NoteID, req.ToUserID, models.InviteStatusPending).First(&existingInvite).Error; err == nil {
		return nil, errors.New("invite already exists")
	}

	// Check if user is already a collaborator
	var existingCollab models.NoteCollaborator
	if err := s.db.Where("note_id = ? AND user_id = ?", req.NoteID, req.ToUserID).First(&existingCollab).Error; err == nil {
		return nil, errors.New("user is already a collaborator")
	}

	// Create invite
	invite := models.Invite{
		NoteID:     req.NoteID,
		FromUserID: fromUserID,
		ToUserID:   req.ToUserID,
		Status:     models.InviteStatusPending,
	}

	if err := s.db.Create(&invite).Error; err != nil {
		return nil, err
	}

	return s.GetInviteByID(invite.ID)
}

func (s *InviteService) GetInviteByID(inviteID uint) (*models.InviteResponse, error) {
	var invite models.Invite
	err := s.db.Where("id = ?", inviteID).
		Preload("Note").
		Preload("FromUser").
		Preload("ToUser").
		First(&invite).Error

	if err != nil {
		return nil, err
	}

	return &models.InviteResponse{
		ID:         invite.ID,
		NoteID:     invite.NoteID,
		FromUserID: invite.FromUserID,
		ToUserID:   invite.ToUserID,
		Status:     invite.Status,
		CreatedAt:  invite.CreatedAt,
		UpdatedAt:  invite.UpdatedAt,
		Note: models.NoteResponse{
			ID:        invite.Note.ID,
			Title:     invite.Note.Title,
			Content:   invite.Note.Content,
			IsPrivate: invite.Note.IsPrivate,
			UserID:    invite.Note.UserID,
			CreatedAt: invite.Note.CreatedAt,
			UpdatedAt: invite.Note.UpdatedAt,
		},
		FromUser: models.UserResponse{
			ID:        invite.FromUser.ID,
			Email:     invite.FromUser.Email,
			Username:  invite.FromUser.Username,
			FirstName: invite.FromUser.FirstName,
			LastName:  invite.FromUser.LastName,
			CreatedAt: invite.FromUser.CreatedAt,
		},
		ToUser: models.UserResponse{
			ID:        invite.ToUser.ID,
			Email:     invite.ToUser.Email,
			Username:  invite.ToUser.Username,
			FirstName: invite.ToUser.FirstName,
			LastName:  invite.ToUser.LastName,
			CreatedAt: invite.ToUser.CreatedAt,
		},
	}, nil
}

func (s *InviteService) GetUserInvites(userID uint) ([]models.InviteResponse, error) {
	var invites []models.Invite
	err := s.db.Where("to_user_id = ? AND status = ?", userID, models.InviteStatusPending).
		Preload("Note").
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
			NoteID:     invite.NoteID,
			FromUserID: invite.FromUserID,
			ToUserID:   invite.ToUserID,
			Status:     invite.Status,
			CreatedAt:  invite.CreatedAt,
			UpdatedAt:  invite.UpdatedAt,
			Note: models.NoteResponse{
				ID:        invite.Note.ID,
				Title:     invite.Note.Title,
				Content:   invite.Note.Content,
				IsPrivate: invite.Note.IsPrivate,
				UserID:    invite.Note.UserID,
				CreatedAt: invite.Note.CreatedAt,
				UpdatedAt: invite.Note.UpdatedAt,
			},
			FromUser: models.UserResponse{
				ID:        invite.FromUser.ID,
				Email:     invite.FromUser.Email,
				Username:  invite.FromUser.Username,
				FirstName: invite.FromUser.FirstName,
				LastName:  invite.FromUser.LastName,
				CreatedAt: invite.FromUser.CreatedAt,
			},
			ToUser: models.UserResponse{
				ID:        invite.ToUser.ID,
				Email:     invite.ToUser.Email,
				Username:  invite.ToUser.Username,
				FirstName: invite.ToUser.FirstName,
				LastName:  invite.ToUser.LastName,
				CreatedAt: invite.ToUser.CreatedAt,
			},
		}
		responses = append(responses, response)
	}

	return responses, nil
}

func (s *InviteService) AcceptInvite(inviteID, userID uint) error {
	var invite models.Invite
	if err := s.db.Where("id = ? AND to_user_id = ? AND status = ?",
		inviteID, userID, models.InviteStatusPending).First(&invite).Error; err != nil {
		return errors.New("invite not found or already processed")
	}

	// Start transaction
	tx := s.db.Begin()

	// Update invite status
	if err := tx.Model(&invite).Update("status", models.InviteStatusAccepted).Error; err != nil {
		tx.Rollback()
		return err
	}

	// Create collaboration
	collaborator := models.NoteCollaborator{
		NoteID: invite.NoteID,
		UserID: userID,
	}

	if err := tx.Create(&collaborator).Error; err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit().Error
}

func (s *InviteService) DeclineInvite(inviteID, userID uint) error {
	var invite models.Invite
	if err := s.db.Where("id = ? AND to_user_id = ? AND status = ?",
		inviteID, userID, models.InviteStatusPending).First(&invite).Error; err != nil {
		return errors.New("invite not found or already processed")
	}

	return s.db.Model(&invite).Update("status", models.InviteStatusDeclined).Error
}
