package repository

import (
	"startfront-backend/internal/domain"
)

func InsertApplicationCollaborator(c domain.ApplicationCollaborator) error {
	query := `
		INSERT INTO application_collaborators (application_id, user_id, role)
		VALUES ($1, $2, $3)
	`
	_, err := db.Exec(query, c.ApplicationID, c.UserID, c.Role)
	return err
}

func GetCollaboratorsByAppID(appID int) ([]domain.ApplicationCollaborator, error) {
	var collaborators []domain.ApplicationCollaborator
	query := `SELECT * FROM application_collaborators WHERE application_id = $1`
	err := db.Select(&collaborators, query, appID)
	return collaborators, err
}
