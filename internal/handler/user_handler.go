package handler

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"
)

func CreateUser(c *gin.Context) {
	var user domain.User
	if err := c.ShouldBindJSON(&user); err != nil {
		response.Error(c, "Invalid user data")
		return
	}

	if err := usecase.CreateUser(user); err != nil {
		response.Error(c, "Failed to create user")
		return
	}

	response.Success(c, gin.H{"message": "User created successfully"})
}

func GetUser(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		response.Error(c, "Invalid user ID")
		return
	}

	user, err := usecase.GetUser(id)
	if err != nil {
		response.Error(c, "User not found")
		return
	}

	response.Success(c, gin.H{"user": user})
}
