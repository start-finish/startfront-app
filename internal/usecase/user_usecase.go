package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

// CreateUser creates a new user
func CreateUser(user domain.User) error {
	return repository.InsertUser(user)
}

// GetUser fetches a user by ID
func GetUser(id string) (domain.User, error) {
	return repository.GetUser(id)
}

// UpdateUser updates user details
func UpdateUser(id string, user domain.User) error {
	return repository.UpdateUser(id, user)
}

// DeleteUser deletes a user
func DeleteUser(id string) error {
	return repository.DeleteUser(id)
}
