package handlers

import (
	"net/http"
	"strconv"

	"markmywords-backend/internal/middleware"
	"markmywords-backend/internal/models"
	"markmywords-backend/internal/services"

	"github.com/gin-gonic/gin"
)

type NoteHandler struct {
	noteService *services.NoteService
}

func NewNoteHandler() *NoteHandler {
	return &NoteHandler{
		noteService: services.NewNoteService(),
	}
}

func (h *NoteHandler) CreateNote(c *gin.Context) {
	var req models.CreateNoteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := middleware.GetUserID(c)
	note, err := h.noteService.CreateNote(&req, userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Note created successfully",
		"note":    note,
	})
}

func (h *NoteHandler) GetNotes(c *gin.Context) {
	userID := middleware.GetUserID(c)
	notes, err := h.noteService.GetUserNotes(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"notes": notes})
}

func (h *NoteHandler) GetNote(c *gin.Context) {
	noteID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid note ID"})
		return
	}

	userID := middleware.GetUserID(c)
	note, err := h.noteService.GetNoteByID(uint(noteID), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"note": note})
}

func (h *NoteHandler) UpdateNote(c *gin.Context) {
	noteID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid note ID"})
		return
	}

	var req models.UpdateNoteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := middleware.GetUserID(c)
	note, err := h.noteService.UpdateNote(uint(noteID), userID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Note updated successfully",
		"note":    note,
	})
}

func (h *NoteHandler) DeleteNote(c *gin.Context) {
	noteID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid note ID"})
		return
	}

	userID := middleware.GetUserID(c)
	err = h.noteService.DeleteNote(uint(noteID), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Note deleted successfully"})
}

func (h *NoteHandler) GetCollaborativeNotes(c *gin.Context) {
	userID := middleware.GetUserID(c)
	notes, err := h.noteService.GetCollaborativeNotes(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"notes": notes})
}
