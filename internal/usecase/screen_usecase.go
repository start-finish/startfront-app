package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

// CreateScreen creates a new screen
func CreateScreen(screen domain.Screen) error {
	return repository.InsertScreen(screen)
}

// GetScreensByAppCode fetches screens by application code
func GetScreensByAppCode(code string) ([]domain.Screen, error) {
	return repository.GetScreensByAppCode(code)
}

// UpdateScreen updates screen details
func UpdateScreen(code string, screen domain.Screen) error {
	return repository.UpdateScreen(code, screen)
}

// DeleteScreen deletes a screen
func DeleteScreen(code string) error {
	return repository.DeleteScreen(code)
}
