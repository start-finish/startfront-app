package handler

import (
	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"

	"github.com/gin-gonic/gin"
)

func CreateScreen(c *gin.Context) {
	var screen domain.Screen
	if err := c.ShouldBindJSON(&screen); err != nil {
		response.Error(c, "Invalid request payload: "+err.Error())
		return
	}

	err := usecase.CreateScreen(screen)
	if err != nil {
		response.Error(c, "Failed to create screen: "+err.Error())
		return
	}

	response.Success(c, gin.H{
		"message": "Screen created successfully",
	})
}

func GetScreensByAppCode(c *gin.Context) {
	code := c.Param("code")

	screens, err := usecase.GetScreensByAppCode(code)
	if err != nil {
		response.Error(c, "Failed to fetch screens")
		return
	}

	response.Success(c, gin.H{"screens": screens})
}
