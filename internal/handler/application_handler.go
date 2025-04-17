package handler

import (
	"github.com/gin-gonic/gin"
	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"
)

// CreateApplication handles the creation of a new application
func CreateApplication(c *gin.Context) {
	var app domain.Application
	if err := c.ShouldBindJSON(&app); err != nil {
		response.Error(c, "Invalid request payload")
		return
	}

	err := usecase.CreateApplication(app)
	if err != nil {
		response.Error(c, "Failed to create application")
		return
	}

	// Send WebSocket message
	SendToClients("New application created")

	response.Success(c, gin.H{"message": "Application created successfully"})
}

// GetApplication fetches application details by code
func GetApplication(c *gin.Context) {
	code := c.Param("code")
	app, err := usecase.GetApplication(code)
	if err != nil {
		response.Error(c, "Failed to fetch application")
		return
	}

	response.Success(c, gin.H{"application": app})
}

// UpdateApplication updates application details
func UpdateApplication(c *gin.Context) {
	code := c.Param("code")
	var app domain.Application
	if err := c.ShouldBindJSON(&app); err != nil {
		response.Error(c, "Invalid request payload")
		return
	}

	err := usecase.UpdateApplication(code, app)
	if err != nil {
		response.Error(c, "Failed to update application")
		return
	}

	// Send WebSocket message
	SendToClients("Application updated")

	response.Success(c, gin.H{"message": "Application updated successfully"})
}

// DeleteApplication deletes an application
func DeleteApplication(c *gin.Context) {
	code := c.Param("code")
	err := usecase.DeleteApplication(code)
	if err != nil {
		response.Error(c, "Failed to delete application")
		return
	}

	// Send WebSocket message
	SendToClients("Application deleted")

	response.Success(c, gin.H{"message": "Application deleted successfully"})
}

// ListApplications retrieves all applications
func ListApplications(c *gin.Context) {
	applications, err := usecase.ListApplications()
	if err != nil {
		response.Error(c, "Failed to fetch applications")
		return
	}

	response.Success(c, gin.H{
		"message": "Applications retrieved successfully",
		"data":    applications,
	})
}