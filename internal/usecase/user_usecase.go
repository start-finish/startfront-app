package usecase

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/repository"
)

func CreateUser(user domain.User) error {
	return repository.InsertUser(user)
}

func GetUser(id int) (domain.User, error) {
	return repository.GetUserByID(id)
}
