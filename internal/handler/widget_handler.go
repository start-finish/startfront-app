package handler

import (
	"strconv"

	"startfront-backend/internal/domain"
	"startfront-backend/internal/usecase"
	"startfront-backend/pkg/response"

	"github.com/gin-gonic/gin"
)

func CreateWidget(c *gin.Context) {
	var widget domain.Widget
	if err := c.ShouldBindJSON(&widget); err != nil {
		response.Error(c, "Invalid request payload")
		return
	}

	if err := usecase.CreateWidget(widget); err != nil {
		response.Error(c, "Failed to create widget: "+err.Error())
		return
	}

	response.Success(c, gin.H{"message": "Widget created successfully"})
}

func GetWidgetsByScreenID(c *gin.Context) {
	idStr := c.Param("screen_id")
	screenID, err := strconv.Atoi(idStr)
	if err != nil {
		response.Error(c, "Invalid screen_id")
		return
	}

	widgets, err := usecase.GetWidgets(screenID)
	if err != nil {
		response.Error(c, "Failed to fetch widgets")
		return
	}

	response.Success(c, gin.H{"widgets": widgets})
}
