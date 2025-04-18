package delivery

import (
	"startfront-backend/internal/handler"
	"time"

	"github.com/gin-gonic/gin"
)

func StartServer() {
	r := gin.Default()

	// API group for WebSocket and HTTP routes
	api := r.Group("/api")
	{
		// WebSocket handler for real-time updates
		api.GET("/ws", handler.WebSocketHandlerGin)

		go func() {
			time.Sleep(2 * time.Second) // wait a bit for clients to reconnect
			handler.SendToClients("🔄 Server restarted, welcome back!")
		}()

		// Users routes
		api.POST("/users", handler.CreateUser)
		api.GET("/users/:id", handler.GetUser)
		api.PUT("/users/:id", handler.UpdateUser)
		api.DELETE("/users/:id", handler.DeleteUser)

		// Applications routes
		api.POST("/applications", handler.CreateApplication)
		api.GET("/applications", handler.ListApplications)
		api.GET("/application/:code", handler.GetApplication)
		api.PUT("/application/:code", handler.UpdateApplication)
		api.DELETE("/application/:code", handler.DeleteApplication)

		// Screens routes
		api.POST("/screens", handler.CreateScreen)
		api.GET("/screens/:code", handler.GetScreensByAppCode)
		api.PUT("/screens/:code", handler.UpdateScreen)
		api.DELETE("/screens/:code", handler.DeleteScreen)

		// Widgets routes
		api.POST("/widgets", handler.CreateWidget)
		api.GET("/widgets/:screen_id", handler.GetWidgetsByScreenID)
		api.PUT("/widgets/:id", handler.UpdateWidget)
		api.DELETE("/widgets/:id", handler.DeleteWidget)

		// Widget Presets routes
		api.POST("/widget-presets", handler.CreateWidgetPreset)
		api.GET("/widget-presets", handler.GetWidgetPresets)

		// App Connections routes
		api.POST("/app-connections", handler.CreateAppConnection)
		api.GET("/app-connections/:application_id", handler.GetAppConnectionsByAppID)

		// Widget Bindings routes
		api.POST("/widget-bindings", handler.CreateWidgetBinding)
		api.GET("/widget-bindings/:widget_id", handler.GetWidgetBindings)

		// Application Collaborators routes
		api.POST("/application-collaborators", handler.CreateApplicationCollaborator)
		api.GET("/application-collaborators/:application_id", handler.GetApplicationCollaborators)
	}

	// Start the HTTP server
	r.Run(":8080")
}
