package main

import (
	"log"

	"markmywords-backend/pkg/database"
)

func main() {
	log.Println("Starting database migration...")

	// Initialize database
	database.InitDB()

	log.Println("Database migration completed successfully!")
}
