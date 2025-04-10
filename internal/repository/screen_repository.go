package repository

import "startfront-backend/internal/domain"

func InsertScreen(s domain.Screen) error {
	query := `
		INSERT INTO screens 
		(application_id, name, code, route, description, params, validate, auth_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`
	_, err := db.Exec(query,
		s.AppID, s.Name, s.Code, s.Route,
		s.Description, s.Params, s.Validate, s.AuthBy,
	)
	return err
}

func GetScreensByApplicationID(appID int) ([]domain.Screen, error) {
	var screens []domain.Screen
	err := db.Select(&screens, `SELECT * FROM screens WHERE application_id = $1`, appID)
	return screens, err
}
