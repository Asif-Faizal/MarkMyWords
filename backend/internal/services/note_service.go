package services

import (
	"errors"

	"gorm.io/gorm"
	"markmywords-backend/internal/models"
	"markmywords-backend/pkg/database"
)

type NoteService struct {
	db *gorm.DB
}

func NewNoteService() *NoteService {
	return &NoteService{
		db: database.GetDB(),
	}
}

func (s *NoteService) CreateNote(req *models.CreateNoteRequest, userID uint) (*models.NoteResponse, error) {
	note := models.Note{
		Title:     req.Title,
		Content:   req.Content,
		IsPrivate: req.IsPrivate,
		UserID:    userID,
	}

	if err := s.db.Create(&note).Error; err != nil {
		return nil, err
	}

	return s.GetNoteByID(note.ID, userID)
}

func (s *NoteService) GetUserNotes(userID uint) ([]models.NoteResponse, error) {
	var notes []models.Note
	err := s.db.Where("user_id = ?", userID).
		Preload("User").
		Preload("Collaborators.User").
		Find(&notes).Error

	if err != nil {
		return nil, err
	}

	var responses []models.NoteResponse
	for _, note := range notes {
		response := models.NoteResponse{
			ID:        note.ID,
			Title:     note.Title,
			Content:   note.Content,
			IsPrivate: note.IsPrivate,
			UserID:    note.UserID,
			CreatedAt: note.CreatedAt,
			UpdatedAt: note.UpdatedAt,
		}

		if note.User.ID != 0 {
			response.User = models.UserResponse{
				ID:        note.User.ID,
				Email:     note.User.Email,
				Username:  note.User.Username,
				FirstName: note.User.FirstName,
				LastName:  note.User.LastName,
				CreatedAt: note.User.CreatedAt,
			}
		}

		for _, collab := range note.Collaborators {
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

func (s *NoteService) GetNoteByID(noteID, userID uint) (*models.NoteResponse, error) {
	var note models.Note
	err := s.db.Where("id = ?", noteID).
		Preload("User").
		Preload("Collaborators.User").
		First(&note).Error

	if err != nil {
		return nil, err
	}

	// Check if user has access to this note
	if note.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.NoteCollaborator
		if err := s.db.Where("note_id = ? AND user_id = ?", noteID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	response := models.NoteResponse{
		ID:        note.ID,
		Title:     note.Title,
		Content:   note.Content,
		IsPrivate: note.IsPrivate,
		UserID:    note.UserID,
		CreatedAt: note.CreatedAt,
		UpdatedAt: note.UpdatedAt,
	}

	if note.User.ID != 0 {
		response.User = models.UserResponse{
			ID:        note.User.ID,
			Email:     note.User.Email,
			Username:  note.User.Username,
			FirstName: note.User.FirstName,
			LastName:  note.User.LastName,
			CreatedAt: note.User.CreatedAt,
		}
	}

	for _, collab := range note.Collaborators {
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

func (s *NoteService) UpdateNote(noteID, userID uint, req *models.UpdateNoteRequest) (*models.NoteResponse, error) {
	var note models.Note
	if err := s.db.First(&note, noteID).Error; err != nil {
		return nil, err
	}

	// Check if user can edit this note
	if note.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.NoteCollaborator
		if err := s.db.Where("note_id = ? AND user_id = ?", noteID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	// Update fields
	if req.Title != "" {
		note.Title = req.Title
	}
	if req.Content != "" {
		note.Content = req.Content
	}
	if req.IsPrivate != nil {
		note.IsPrivate = *req.IsPrivate
	}

	if err := s.db.Save(&note).Error; err != nil {
		return nil, err
	}

	return s.GetNoteByID(noteID, userID)
}

func (s *NoteService) DeleteNote(noteID, userID uint) error {
	var note models.Note
	if err := s.db.First(&note, noteID).Error; err != nil {
		return err
	}

	// Only the owner can delete the note
	if note.UserID != userID {
		return errors.New("access denied")
	}

	return s.db.Delete(&note).Error
}

func (s *NoteService) GetCollaborativeNotes(userID uint) ([]models.NoteResponse, error) {
	var notes []models.Note
	err := s.db.Joins("JOIN note_collaborators ON notes.id = note_collaborators.note_id").
		Where("note_collaborators.user_id = ?", userID).
		Preload("User").
		Preload("Collaborators.User").
		Find(&notes).Error

	if err != nil {
		return nil, err
	}

	var responses []models.NoteResponse
	for _, note := range notes {
		response := models.NoteResponse{
			ID:        note.ID,
			Title:     note.Title,
			Content:   note.Content,
			IsPrivate: note.IsPrivate,
			UserID:    note.UserID,
			CreatedAt: note.CreatedAt,
			UpdatedAt: note.UpdatedAt,
		}

		if note.User.ID != 0 {
			response.User = models.UserResponse{
				ID:        note.User.ID,
				Email:     note.User.Email,
				Username:  note.User.Username,
				FirstName: note.User.FirstName,
				LastName:  note.User.LastName,
				CreatedAt: note.User.CreatedAt,
			}
		}

		for _, collab := range note.Collaborators {
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
