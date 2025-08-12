package services

import (
	"errors"

	"markmywords-backend/internal/models"
	"markmywords-backend/pkg/database"

	"gorm.io/gorm"
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
	// Check if user has access to the thread
	var thread models.Thread
	if err := s.db.First(&thread, req.ThreadID).Error; err != nil {
		return nil, errors.New("thread not found")
	}

	// Check if user can add notes to this thread
	if thread.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.ThreadCollaborator
		if err := s.db.Where("thread_id = ? AND user_id = ?", req.ThreadID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	note := models.Note{
		Content:  req.Content,
		ThreadID: req.ThreadID,
		UserID:   userID,
	}

	if err := s.db.Create(&note).Error; err != nil {
		return nil, err
	}

	return s.GetNoteByID(note.ID, userID)
}

func (s *NoteService) GetThreadNotes(threadID, userID uint) ([]models.NoteResponse, error) {
	// Check if user has access to the thread
	var thread models.Thread
	if err := s.db.First(&thread, threadID).Error; err != nil {
		return nil, errors.New("thread not found")
	}

	// Check if user can view notes in this thread
	if thread.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.ThreadCollaborator
		if err := s.db.Where("thread_id = ? AND user_id = ?", threadID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	var notes []models.Note
	err := s.db.Where("thread_id = ?", threadID).
		Preload("User").
		Order("created_at ASC").
		Find(&notes).Error

	if err != nil {
		return nil, err
	}

	var responses []models.NoteResponse
	for _, note := range notes {
		response := models.NoteResponse{
			ID:        note.ID,
			Content:   note.Content,
			ThreadID:  note.ThreadID,
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

		responses = append(responses, response)
	}

	return responses, nil
}

func (s *NoteService) GetNoteByID(noteID, userID uint) (*models.NoteResponse, error) {
	var note models.Note
	err := s.db.Where("id = ?", noteID).
		Preload("User").
		First(&note).Error

	if err != nil {
		return nil, err
	}

	// Check if user has access to this note (through thread access)
	var thread models.Thread
	if err := s.db.First(&thread, note.ThreadID).Error; err != nil {
		return nil, errors.New("thread not found")
	}

	if thread.UserID != userID {
		// Check if user is a collaborator
		var collaborator models.ThreadCollaborator
		if err := s.db.Where("thread_id = ? AND user_id = ?", note.ThreadID, userID).First(&collaborator).Error; err != nil {
			return nil, errors.New("access denied")
		}
	}

	response := models.NoteResponse{
		ID:        note.ID,
		Content:   note.Content,
		ThreadID:  note.ThreadID,
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

	return &response, nil
}

func (s *NoteService) UpdateNote(noteID, userID uint, req *models.UpdateNoteRequest) (*models.NoteResponse, error) {
	var note models.Note
	if err := s.db.First(&note, noteID).Error; err != nil {
		return nil, err
	}

	// Only the note author can edit the note
	if note.UserID != userID {
		return nil, errors.New("access denied")
	}

	// Update content
	note.Content = req.Content

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

	// Only the note author can delete the note
	if note.UserID != userID {
		return errors.New("access denied")
	}

	return s.db.Delete(&note).Error
}
