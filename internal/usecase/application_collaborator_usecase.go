package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateApplicationCollaborator(c domain.ApplicationCollaborator) error {
	return repository.InsertApplicationCollaborator(c)
}

func ListApplicationCollaborators(appID int) ([]domain.ApplicationCollaborator, error) {
	return repository.GetCollaboratorsByAppID(appID)
}
