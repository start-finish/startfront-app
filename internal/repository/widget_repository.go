package repository

import (
	"startfront-backend/internal/domain"
)

func InsertWidget(w domain.Widget) error {
	query := `
		INSERT INTO widgets (screen_id, parent_id, type, props, child_index, auth_by)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := db.Exec(query, w.ScreenID, w.ParentID, w.Type, w.Props, w.ChildIndex, w.AuthBy)
	return err
}

func GetWidgetsByScreenID(screenID int) ([]domain.Widget, error) {
	var widgets []domain.Widget
	err := db.Select(&widgets, `SELECT * FROM widgets WHERE screen_id = $1`, screenID)
	return widgets, err
}
