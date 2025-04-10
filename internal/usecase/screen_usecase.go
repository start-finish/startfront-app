package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateScreen(screen domain.Screen) error {
	return repository.InsertScreen(screen)
}

func GetScreensByAppCode(code string) ([]domain.Screen, error) {
	app, err := repository.GetApplicationByCode(code)
	if err != nil {
		return nil, err
	}
	return repository.GetScreensByApplicationID(app.ID)
}
