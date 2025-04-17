package repository

import (
	"startfront-backend/internal/domain"
)

// InsertScreen creates a new screen in the database
func InsertScreen(screen domain.Screen) error {
	_, err := db.DB.Exec("INSERT INTO screens (application_id, name, code, route) VALUES (?, ?, ?, ?)", screen.AppID, screen.Name, screen.Code, screen.Route)
	return err
}

// GetScreensByAppCode fetches screens by application code
func GetScreensByAppCode(code string) ([]domain.Screen, error) {
	rows, err := db.DB.Query("SELECT id, application_id, name, code, route FROM screens WHERE application_id = (SELECT id FROM applications WHERE code = ?)", code)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var screens []domain.Screen
	for rows.Next() {
		var screen domain.Screen
		if err := rows.Scan(&screen.ID, &screen.AppID, &screen.Name, &screen.Code, &screen.Route); err != nil {
			return nil, err
		}
		screens = append(screens, screen)
	}
	return screens, nil
}

// UpdateScreen updates a screen in the database
func UpdateScreen(code string, screen domain.Screen) error {
	_, err := db.DB.Exec("UPDATE screens SET name = ?, route = ? WHERE code = ?", screen.Name, screen.Route, code)
	return err
}

// DeleteScreen deletes a screen by its code
func DeleteScreen(code string) error {
	_, err := db.DB.Exec("DELETE FROM screens WHERE code = ?", code)
	return err
}
