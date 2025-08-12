package database

import (
	"log"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"markmywords-backend/internal/models"
)

var DB *gorm.DB

func InitDB() {
	var err error

	// Use SQLite for development
	DB, err = gorm.Open(sqlite.Open("markmywords.db"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})

	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Drop existing tables to handle schema changes
	log.Println("Dropping existing tables for schema migration...")
	DB.Migrator().DropTable(&models.Invite{})
	DB.Migrator().DropTable(&models.Note{})
	DB.Migrator().DropTable(&models.ThreadCollaborator{})
	DB.Migrator().DropTable(&models.Thread{})
	DB.Migrator().DropTable(&models.User{})

	// Auto migrate the schema
	err = DB.AutoMigrate(
		&models.User{},
		&models.Thread{},
		&models.ThreadCollaborator{},
		&models.Note{},
		&models.Invite{},
	)

	if err != nil {
		log.Fatal("Failed to migrate database:", err)
	}

	log.Println("Database connected and migrated successfully")
}

func GetDB() *gorm.DB {
	return DB
}
