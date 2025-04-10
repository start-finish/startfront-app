package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateApplication(app domain.Application) error {
	return repository.InsertApplication(app)
}

func ListApplications() ([]domain.Application, error) {
	return repository.GetAllApplications()
}

func GetApplicationDetail(code string) (domain.Application, error) {
	return repository.GetApplicationByCode(code)
}
