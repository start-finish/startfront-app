package handler

import (
	"github.com/gin-gonic/gin"
	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"
)

// CreateScreen handles the creation of a new screen
func CreateScreen(c *gin.Context) {
	var screen domain.Screen
	if err := c.ShouldBindJSON(&screen); err != nil {
		response.Error(c, "Invalid request payload")
		return
	}

	err := usecase.CreateScreen(screen)
	if err != nil {
		response.Error(c, "Failed to create screen")
		return
	}

	// Send WebSocket message
	SendToClients("New screen created")

	response.Success(c, gin.H{"message": "Screen created successfully"})
}

// GetScreensByAppCode fetches screens by application code
func GetScreensByAppCode(c *gin.Context) {
	code := c.Param("code")
	screens, err := usecase.GetScreensByAppCode(code)
	if err != nil {
		response.Error(c, "Failed to fetch screens")
		return
	}

	response.Success(c, gin.H{"screens": screens})
}

// UpdateScreen updates a screen
func UpdateScreen(c *gin.Context) {
	code := c.Param("code")
	var screen domain.Screen
	if err := c.ShouldBindJSON(&screen); err != nil {
		response.Error(c, "Invalid request payload")
		return
	}

	err := usecase.UpdateScreen(code, screen)
	if err != nil {
		response.Error(c, "Failed to update screen")
		return
	}

	// Send WebSocket message
	SendToClients("Screen updated")

	response.Success(c, gin.H{"message": "Screen updated successfully"})
}

// DeleteScreen deletes a screen
func DeleteScreen(c *gin.Context) {
	code := c.Param("code")
	err := usecase.DeleteScreen(code)
	if err != nil {
		response.Error(c, "Failed to delete screen")
		return
	}

	// Send WebSocket message
	SendToClients("Screen deleted")

	response.Success(c, gin.H{"message": "Screen deleted successfully"})
}
