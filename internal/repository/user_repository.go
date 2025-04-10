package repository

import (
	"startfront-backend/internal/domain"
)

func InsertUser(user domain.User) error {
	query := `
		INSERT INTO users (email, name, role)
		VALUES ($1, $2, $3)
	`
	_, err := db.Exec(query, user.Email, user.Name, user.Role)
	return err
}

func GetUserByID(id int) (domain.User, error) {
	var user domain.User
	err := db.Get(&user, `SELECT * FROM users WHERE id = $1`, id)
	return user, err
}
