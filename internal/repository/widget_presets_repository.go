package repository

import "startfront-backend/internal/domain"

func InsertWidgetPreset(wp domain.WidgetPreset) error {
	query := `
        INSERT INTO widget_presets (name, type, props, created_by)
        VALUES ($1, $2, $3, $4)
    `
	_, err := db.Exec(query, wp.Name, wp.Type, wp.Props, wp.CreatedBy)
	return err
}

func GetAllWidgetPresets() ([]domain.WidgetPreset, error) {
	var presets []domain.WidgetPreset
	err := db.Select(&presets, `SELECT * FROM widget_presets`)
	return presets, err
}
