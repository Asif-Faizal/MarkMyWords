package handlers

import (
	"net/http"
	"strconv"

	"markmywords-backend/internal/middleware"
	"markmywords-backend/internal/services"
	"markmywords-backend/internal/types"

	"github.com/gin-gonic/gin"
)

type ThreadHandler struct {
	threadService *services.ThreadService
}

func NewThreadHandler() *ThreadHandler {
	return &ThreadHandler{
		threadService: services.NewThreadService(),
	}
}

func (h *ThreadHandler) CreateThread(c *gin.Context) {
	var req types.CreateThreadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := middleware.GetUserID(c)
	thread, err := h.threadService.CreateThread(&req, userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Thread created successfully",
		"thread":  thread,
	})
}

func (h *ThreadHandler) GetThreads(c *gin.Context) {
	userID := middleware.GetUserID(c)
	threads, err := h.threadService.GetUserThreads(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"threads": threads})
}

func (h *ThreadHandler) GetThread(c *gin.Context) {
	threadID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid thread ID"})
		return
	}

	userID := middleware.GetUserID(c)
	thread, err := h.threadService.GetThreadByID(uint(threadID), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"thread": thread})
}

func (h *ThreadHandler) UpdateThread(c *gin.Context) {
	threadID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid thread ID"})
		return
	}

	var req types.UpdateThreadRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := middleware.GetUserID(c)
	thread, err := h.threadService.UpdateThread(uint(threadID), userID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Thread updated successfully",
		"thread":  thread,
	})
}

func (h *ThreadHandler) DeleteThread(c *gin.Context) {
	threadID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid thread ID"})
		return
	}

	userID := middleware.GetUserID(c)
	err = h.threadService.DeleteThread(uint(threadID), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Thread deleted successfully"})
}

func (h *ThreadHandler) GetCollaborativeThreads(c *gin.Context) {
	userID := middleware.GetUserID(c)
	threads, err := h.threadService.GetCollaborativeThreads(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"threads": threads})
}
