package services

import (
	"errors"

	"markmywords-backend/internal/models"
	"markmywords-backend/pkg/database"

	"gorm.io/gorm"
)

type ThreadService struct {
	db *gorm.DB
}

func NewThreadService() *ThreadService {
	return &ThreadService{
		db: database.GetDB(),
	}
}

func (s *ThreadService) CreateThread(req *models.CreateThreadRequest, userID uint) (*models.ThreadResponse, error) {
	thread := models.Thread{
		Title:       req.Title,
		Description: req.Description,
		IsPrivate:   req.IsPrivate,
		UserID:      userID,
	}

	if err := s.db.Create(&thread).Error; err != nil {
		return nil, err
	}

	return s.GetThreadByID(thread.ID, userID)
}

func (s *ThreadService) GetUserThreads(userID uint) ([]models.ThreadResponse, error) {
	var threads []models.Thread
	err := s.db.Where("user_id = ?", userID).
		Preload("User").
		Preload("Collaborators.User").
		Preload("Notes").
		Find(&threads).Error

	if err != nil {
		return nil, err
	}

	var responses []models.ThreadResponse
	for _, thread := range threads {
		response := models.ThreadResponse{
			ID:          thread.ID,
			Title:       thread.Title,
			Description: thread.Description,
			IsPrivate:   thread.IsPrivate,
			UserID:      thread.UserID,
			NotesCount:  len(thread.Notes),
			CreatedAt:   thread.CreatedAt,
			UpdatedAt:   thread.UpdatedAt,
		}

		if thread.User.ID != 0 {
			response.User = models.UserResponse{
				ID:        thread.User.ID,
				Email:     thread.User.Email,
				Username:  thread.User.Username,
				FirstName: thread.User.FirstName,
				LastName:  thread.User.LastName,
				CreatedAt: thread.User.CreatedAt,
			}
		}

		for _, collab := range thread.Collaborators {
			response.Collaborators = append(response.Collaborators, models.UserResponse{
				ID:        collab.User.ID,
				Email:     collab.User.Email,
				Username:  collab.User.Username,
				FirstName: collab.User.FirstName,
				LastName:  collab.User.LastName,
				CreatedAt: collab.User.CreatedAt,
			})
		}

		responses = append(responses, response)
	}

	return responses, nil
}

func (s *ThreadService) GetThreadByID(threadID, userID uint) (*models.ThreadResponse, error) {
	var thread models.Thread
	err := s.db.Where("id = ?", threadID).
		Preload("User").
		Preload("Collaborators.User").
		Preload("Notes").
		First(&thread).Error

	if err != nil {
		return nil, err
	}

	// Check if user has access to this thread
	if thread.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.ThreadCollaborator
		if err := s.db.Where("thread_id = ? AND user_id = ?", threadID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	response := models.ThreadResponse{
		ID:          thread.ID,
		Title:       thread.Title,
		Description: thread.Description,
		IsPrivate:   thread.IsPrivate,
		UserID:      thread.UserID,
		NotesCount:  len(thread.Notes),
		CreatedAt:   thread.CreatedAt,
		UpdatedAt:   thread.UpdatedAt,
	}

	if thread.User.ID != 0 {
		response.User = models.UserResponse{
			ID:        thread.User.ID,
			Email:     thread.User.Email,
			Username:  thread.User.Username,
			FirstName: thread.User.FirstName,
			LastName:  thread.User.LastName,
			CreatedAt: thread.User.CreatedAt,
		}
	}

	for _, collab := range thread.Collaborators {
		response.Collaborators = append(response.Collaborators, models.UserResponse{
			ID:        collab.User.ID,
			Email:     collab.User.Email,
			Username:  collab.User.Username,
			FirstName: collab.User.FirstName,
			LastName:  collab.User.LastName,
			CreatedAt: collab.User.CreatedAt,
		})
	}

	return &response, nil
}

func (s *ThreadService) UpdateThread(threadID, userID uint, req *models.UpdateThreadRequest) (*models.ThreadResponse, error) {
	var thread models.Thread
	if err := s.db.First(&thread, threadID).Error; err != nil {
		return nil, err
	}

	// Only the owner can update the thread
	if thread.UserID != userID {
		return nil, errors.New("access denied")
	}

	// Update fields
	if req.Title != "" {
		thread.Title = req.Title
	}
	if req.Description != "" {
		thread.Description = req.Description
	}
	if req.IsPrivate != nil {
		thread.IsPrivate = *req.IsPrivate
	}

	if err := s.db.Save(&thread).Error; err != nil {
		return nil, err
	}

	return s.GetThreadByID(threadID, userID)
}

func (s *ThreadService) DeleteThread(threadID, userID uint) error {
	var thread models.Thread
	if err := s.db.First(&thread, threadID).Error; err != nil {
		return err
	}

	// Only the owner can delete the thread
	if thread.UserID != userID {
		return errors.New("access denied")
	}

	return s.db.Delete(&thread).Error
}

func (s *ThreadService) GetCollaborativeThreads(userID uint) ([]models.ThreadResponse, error) {
	var threads []models.Thread
	err := s.db.Joins("JOIN thread_collaborators ON threads.id = thread_collaborators.thread_id").
		Where("thread_collaborators.user_id = ?", userID).
		Preload("User").
		Preload("Collaborators.User").
		Preload("Notes").
		Find(&threads).Error

	if err != nil {
		return nil, err
	}

	var responses []models.ThreadResponse
	for _, thread := range threads {
		response := models.ThreadResponse{
			ID:          thread.ID,
			Title:       thread.Title,
			Description: thread.Description,
			IsPrivate:   thread.IsPrivate,
			UserID:      thread.UserID,
			NotesCount:  len(thread.Notes),
			CreatedAt:   thread.CreatedAt,
			UpdatedAt:   thread.UpdatedAt,
		}

		if thread.User.ID != 0 {
			response.User = models.UserResponse{
				ID:        thread.User.ID,
				Email:     thread.User.Email,
				Username:  thread.User.Username,
				FirstName: thread.User.FirstName,
				LastName:  thread.User.LastName,
				CreatedAt: thread.User.CreatedAt,
			}
		}

		for _, collab := range thread.Collaborators {
			response.Collaborators = append(response.Collaborators, models.UserResponse{
				ID:        collab.User.ID,
				Email:     collab.User.Email,
				Username:  collab.User.Username,
				FirstName: collab.User.FirstName,
				LastName:  collab.User.LastName,
				CreatedAt: collab.User.CreatedAt,
			})
		}

		responses = append(responses, response)
	}

	return responses, nil
}
