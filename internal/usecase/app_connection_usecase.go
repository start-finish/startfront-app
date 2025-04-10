package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateAppConnection(c domain.AppConnection) error {
	return repository.InsertAppConnection(c)
}

func ListAppConnectionsByAppID(appID int) ([]domain.AppConnection, error) {
	return repository.GetAppConnectionsByAppID(appID)
}
