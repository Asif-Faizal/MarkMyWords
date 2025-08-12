package handlers

import (
	"net/http"
	"strconv"

	"markmywords-backend/internal/middleware"
	"markmywords-backend/internal/models"
	"markmywords-backend/internal/services"

	"github.com/gin-gonic/gin"
)

type InviteHandler struct {
	inviteService *services.InviteService
	userService   *services.UserService
}

func NewInviteHandler() *InviteHandler {
	return &InviteHandler{
		inviteService: services.NewInviteService(),
		userService:   services.NewUserService(),
	}
}

func (h *InviteHandler) CreateInvite(c *gin.Context) {
	threadID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid thread ID"})
		return
	}

	var req models.CreateInviteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	req.ThreadID = uint(threadID)
	fromUserID := middleware.GetUserID(c)
	invite, err := h.inviteService.CreateInvite(&req, fromUserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Invite sent successfully",
		"invite":  invite,
	})
}

func (h *InviteHandler) GetUserInvites(c *gin.Context) {
	userID := middleware.GetUserID(c)
	invites, err := h.inviteService.GetUserInvites(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"invites": invites})
}

func (h *InviteHandler) AcceptInvite(c *gin.Context) {
	inviteID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid invite ID"})
		return
	}

	userID := middleware.GetUserID(c)
	err = h.inviteService.AcceptInvite(uint(inviteID), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Invite accepted successfully"})
}

func (h *InviteHandler) DeclineInvite(c *gin.Context) {
	inviteID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid invite ID"})
		return
	}

	userID := middleware.GetUserID(c)
	err = h.inviteService.DeclineInvite(uint(inviteID), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Invite declined successfully"})
}

func (h *InviteHandler) SearchUsers(c *gin.Context) {
	var req models.SearchUserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	currentUserID := middleware.GetUserID(c)
	users, err := h.userService.SearchUsers(req.Query, currentUserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"users": users})
}
