package repository

import (
	"startfront-backend/internal/domain"
)

// InsertApplication creates a new application in the database
func InsertApplication(application domain.Application) error {
	_, err := db.DB.Exec("INSERT INTO applications (name, code, description) VALUES (?, ?, ?)", application.Name, application.Code, application.Description)
	return err
}

// GetApplication fetches an application by its code
func GetApplication(code string) (domain.Application, error) {
	var app domain.Application
	err := db.DB.QueryRow("SELECT id, name, code, description FROM applications WHERE code = ?", code).Scan(&app.ID, &app.Name, &app.Code, &app.Description)
	return app, err
}

// GetAllApplications fetches all applications
func GetAllApplications() ([]domain.Application, error) {
	rows, err := db.DB.Query("SELECT id, name, code, description FROM applications")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var apps []domain.Application
	for rows.Next() {
		var app domain.Application
		if err := rows.Scan(&app.ID, &app.Name, &app.Code, &app.Description); err != nil {
			return nil, err
		}
		apps = append(apps, app)
	}
	return apps, nil
}

// UpdateApplication updates an application's details
func UpdateApplication(code string, application domain.Application) error {
	_, err := db.DB.Exec("UPDATE applications SET name = ?, description = ? WHERE code = ?", application.Name, application.Description, code)
	return err
}

// DeleteApplication deletes an application
func DeleteApplication(code string) error {
	_, err := db.DB.Exec("DELETE FROM applications WHERE code = ?", code)
	return err
}
