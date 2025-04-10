package handler

import (
	"github.com/gin-gonic/gin"
	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"
)

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

	response.Success(c, gin.H{
		"message": "Application created successfully",
	})
}

func ListApplications(c *gin.Context) {
	apps, err := usecase.ListApplications()
	if err != nil {
		response.Error(c, "Failed to fetch applications")
		return
	}
	response.Success(c, gin.H{"applications": apps})
}

func GetApplication(c *gin.Context) {
	code := c.Param("code")
	app, err := usecase.GetApplicationDetail(code)
	if err != nil {
		response.Error(c, "Application not found")
		return
	}
	response.Success(c, gin.H{"application": app})
}
