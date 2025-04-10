package repository

import (
	"startfront-backend/internal/domain"
)

func InsertApplication(app domain.Application) error {
	query := `
	INSERT INTO applications (name, code, route, description, created_by, auth_by)
	VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := db.Exec(query,
		app.Name, app.Code, app.Route, app.Description, app.CreatedBy, app.AuthBy,
	)
	return err
}

func GetAllApplications() ([]domain.Application, error) {
	var apps []domain.Application
	err := db.Select(&apps, `SELECT * FROM applications`)
	return apps, err
}

func GetApplicationByCode(code string) (domain.Application, error) {
	var app domain.Application
	err := db.Get(&app, `SELECT * FROM applications WHERE code = $1`, code)
	return app, err
}
