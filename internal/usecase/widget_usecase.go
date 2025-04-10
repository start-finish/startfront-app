package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateWidget(w domain.Widget) error {
	return repository.InsertWidget(w)
}

func GetWidgets(screenID int) ([]domain.Widget, error) {
	return repository.GetWidgetsByScreenID(screenID)
}
