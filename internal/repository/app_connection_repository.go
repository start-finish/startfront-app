package repository

import (
	"startfront-backend/internal/domain"
)

func InsertAppConnection(c domain.AppConnection) error {
	query := `
		INSERT INTO app_connections (application_id, name, type, config)
		VALUES ($1, $2, $3, $4)
	`
	_, err := db.Exec(query, c.ApplicationID, c.Name, c.Type, c.Config)
	return err
}

func GetAppConnectionsByAppID(appID int) ([]domain.AppConnection, error) {
	var connections []domain.AppConnection
	query := `SELECT * FROM app_connections WHERE application_id = $1`
	err := db.Select(&connections, query, appID)
	return connections, err
}
