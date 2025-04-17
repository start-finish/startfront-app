package repository

import (
	"fmt"
	"log"
	"startfront-backend/internal/domain"
	"strings"
)

// InsertUser inserts a new user into the database
func InsertUser(user domain.User) error {
	_, err := db.DB.Exec("INSERT INTO users (name, email, role) VALUES ($1, $2, $3)", user.Name, user.Email, user.Role)
	if err != nil {
		// Check if the error is a duplicate key error
		if isDuplicateKeyError(err) {
			log.Println("Duplicate email/name error:", err)
			return fmt.Errorf("duplicate_found")
		}
		// Log and return the error for any other case
		log.Println("Error inserting user:", err)
		return err
	}
	return nil
}

// isDuplicateKeyError checks if the error is due to a unique constraint violation
func isDuplicateKeyError(err error) bool {
	if err != nil && (strings.Contains(err.Error(), "duplicate key value violates unique constraint") || strings.Contains(err.Error(), "users_email_key") || strings.Contains(err.Error(), "users_name_key")) {
		return true
	}
	return false
}

// GetUser fetches a user by ID
func GetUser(id string) (domain.User, error) {
	var user domain.User
	err := db.DB.QueryRow("SELECT id, name, email, role FROM users WHERE id = ?", id).Scan(&user.ID, &user.Name, &user.Email, &user.Role)
	return user, err
}

// UpdateUser updates a user's information
func UpdateUser(id string, user domain.User) error {
	_, err := db.DB.Exec("UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?", user.Name, user.Email, user.Role, id)
	return err
}

// DeleteUser deletes a user by ID
func DeleteUser(id string) error {
	_, err := db.DB.Exec("DELETE FROM users WHERE id = ?", id)
	return err
}
