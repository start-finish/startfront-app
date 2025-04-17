package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

// CreateApplication creates a new application
func CreateApplication(application domain.Application) error {
	return repository.InsertApplication(application)
}

// GetApplication fetches application details by code
func GetApplication(code string) (domain.Application, error) {
	return repository.GetApplication(code)
}

// ListApplications lists all applications
func ListApplications() ([]domain.Application, error) {
	return repository.GetAllApplications()
}

// UpdateApplication updates application details
func UpdateApplication(code string, application domain.Application) error {
	return repository.UpdateApplication(code, application)
}

// DeleteApplication deletes an application
func DeleteApplication(code string) error {
	return repository.DeleteApplication(code)
}
