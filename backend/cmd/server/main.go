package main

import (
	"log"
	"net/http"

	"markmywords-backend/internal/handlers"
	"markmywords-backend/internal/middleware"
	"markmywords-backend/internal/websocket"
	"markmywords-backend/pkg/database"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	// Initialize database
	database.InitDB()

	// Create WebSocket manager
	wsManager := websocket.NewManager()
	go wsManager.Start()

	// Create handlers
	authHandler := handlers.NewAuthHandler()
	threadHandler := handlers.NewThreadHandler()
	noteHandler := handlers.NewNoteHandler()
	inviteHandler := handlers.NewInviteHandler()
	wsHandler := handlers.NewWebSocketHandler()

	// Setup Gin router
	r := gin.Default()

	// CORS configuration
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization"}
	r.Use(cors.New(config))

	// API routes
	api := r.Group("/api")
	{
		// Auth routes (public)
		auth := api.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
		}

		// Protected routes
		protected := api.Group("")
		protected.Use(middleware.AuthMiddleware())
		{
			// User routes
			protected.GET("/auth/me", authHandler.GetMe)

			// Thread routes
			threads := protected.Group("/threads")
			{
				threads.GET("", threadHandler.GetThreads)
				threads.POST("", threadHandler.CreateThread)
				threads.GET("/:id", threadHandler.GetThread)
				threads.PUT("/:id", threadHandler.UpdateThread)
				threads.DELETE("/:id", threadHandler.DeleteThread)
				threads.GET("/collaborative", threadHandler.GetCollaborativeThreads)
			}

			// Note routes (messages within threads)
			notes := protected.Group("/threads/:threadId/notes")
			{
				notes.GET("", noteHandler.GetThreadNotes)
				notes.POST("", noteHandler.CreateNote)
				notes.GET("/:id", noteHandler.GetNote)
				notes.PUT("/:id", noteHandler.UpdateNote)
				notes.DELETE("/:id", noteHandler.DeleteNote)
			}

			// Invite routes
			invites := protected.Group("/invites")
			{
				invites.GET("", inviteHandler.GetUserInvites)
				invites.POST("/:id/accept", inviteHandler.AcceptInvite)
				invites.POST("/:id/decline", inviteHandler.DeclineInvite)
			}

			// Thread collaboration routes
			threads.POST("/:threadId/invite", inviteHandler.CreateInvite)

			// User search
			protected.POST("/users/search", inviteHandler.SearchUsers)
		}
	}

	// WebSocket route
	r.GET("/ws", wsHandler.HandleWebSocket)

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// Start server
	log.Println("Server starting on :8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
