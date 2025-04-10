package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateWidgetPreset(preset domain.WidgetPreset) error {
	return repository.InsertWidgetPreset(preset)
}

func GetWidgetPresets() ([]domain.WidgetPreset, error) {
	return repository.GetAllWidgetPresets()
}
