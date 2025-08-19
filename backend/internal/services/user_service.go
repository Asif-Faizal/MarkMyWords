package services

import (
	"errors"

	"markmywords-backend/internal/types"
	"markmywords-backend/pkg/auth"
	"markmywords-backend/pkg/database"

	"gorm.io/gorm"
)

type UserService struct {
	db *gorm.DB
}

func NewUserService() *UserService {
	return &UserService{
		db: database.GetDB(),
	}
}

func (s *UserService) Register(req *types.RegisterRequest) (*types.UserResponse, error) {
	// Check if user already exists
	var existingUser types.User
	if err := s.db.Where("email = ? OR username = ?", req.Email, req.Username).First(&existingUser).Error; err == nil {
		return nil, errors.New("user with this email or username already exists")
	}

	// Hash password
	hashedPassword, err := auth.HashPassword(req.Password)
	if err != nil {
		return nil, err
	}

	// Create user
	user := types.User{
		Email:     req.Email,
		Username:  req.Username,
		Password:  hashedPassword,
		FirstName: req.FirstName,
		LastName:  req.LastName,
	}

	if err := s.db.Create(&user).Error; err != nil {
		return nil, err
	}

	return &types.UserResponse{
		ID:        user.ID,
		Email:     user.Email,
		Username:  user.Username,
		FirstName: user.FirstName,
		LastName:  user.LastName,
		CreatedAt: user.CreatedAt,
	}, nil
}

func (s *UserService) Login(req *types.LoginRequest) (*types.UserResponse, string, error) {
	var user types.User
	if err := s.db.Where("email = ?", req.Email).First(&user).Error; err != nil {
		return nil, "", errors.New("invalid credentials")
	}

	if !auth.CheckPassword(req.Password, user.Password) {
		return nil, "", errors.New("invalid credentials")
	}

	// Generate JWT token
	token, err := auth.GenerateToken(user.ID, user.Email)
	if err != nil {
		return nil, "", err
	}

	return &types.UserResponse{
		ID:        user.ID,
		Email:     user.Email,
		Username:  user.Username,
		FirstName: user.FirstName,
		LastName:  user.LastName,
		CreatedAt: user.CreatedAt,
	}, token, nil
}

func (s *UserService) GetUserByID(userID uint) (*types.UserResponse, error) {
	var user types.User
	if err := s.db.First(&user, userID).Error; err != nil {
		return nil, err
	}

	return &types.UserResponse{
		ID:        user.ID,
		Email:     user.Email,
		Username:  user.Username,
		FirstName: user.FirstName,
		LastName:  user.LastName,
		CreatedAt: user.CreatedAt,
	}, nil
}

func (s *UserService) SearchUsers(query string, currentUserID uint) ([]types.UserResponse, error) {
	var users []types.User
	err := s.db.Where("(username LIKE ? OR email LIKE ? OR first_name LIKE ? OR last_name LIKE ?) AND id != ?",
		"%"+query+"%", "%"+query+"%", "%"+query+"%", "%"+query+"%", currentUserID).
		Limit(10).
		Find(&users).Error

	if err != nil {
		return nil, err
	}

	var responses []types.UserResponse
	for _, user := range users {
		responses = append(responses, types.UserResponse{
			ID:        user.ID,
			Email:     user.Email,
			Username:  user.Username,
			FirstName: user.FirstName,
			LastName:  user.LastName,
			CreatedAt: user.CreatedAt,
		})
	}

	return responses, nil
}
