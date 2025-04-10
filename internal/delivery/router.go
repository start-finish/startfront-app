package delivery

import (
	"startfront-backend/internal/handler"

	"github.com/gin-gonic/gin"
)

func StartServer() {
	r := gin.Default()

	api := r.Group("/api")
	{
		// user
		api.POST("/users", handler.CreateUser)
		api.GET("/users/:id", handler.GetUser)

		// applications
		api.POST("/applications", handler.CreateApplication)
		api.GET("/applications", handler.ListApplications)
		api.GET("/application/:code", handler.GetApplication)

		// screens
		api.POST("/screens", handler.CreateScreen)
		api.GET("/screens/:code", handler.GetScreensByAppCode)

		// widgets
		api.POST("/widgets", handler.CreateWidget)
		api.GET("/widgets/:screen_id", handler.GetWidgetsByScreenID)

		// widget_presets
		api.POST("/widget-presets", handler.CreateWidgetPreset)
		api.GET("/widget-presets", handler.GetWidgetPresets)

		// app_connection
		api.POST("/app-connections", handler.CreateAppConnection)
		api.GET("/app-connections/:application_id", handler.GetAppConnectionsByAppID)

		// widget_bindings
		api.POST("/widget-bindings", handler.CreateWidgetBinding)
		api.GET("/widget-bindings/:widget_id", handler.GetWidgetBindings)

		// auth_bindings
		api.POST("/auth-bindings", handler.CreateAuthBinding)
		api.GET("/auth-bindings/:app_id", handler.GetAuthBindingsByAppID)

		// application collaborations
		// Add these lines in your router setup
		api.POST("/application-collaborators", handler.CreateApplicationCollaborator)
		api.GET("/application-collaborators/:application_id", handler.GetApplicationCollaborators)

	}

	r.Run(":8080")
}
