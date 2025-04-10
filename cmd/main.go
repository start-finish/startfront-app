package main

import (
	"startfront-backend/pkg/config"
	"startfront-backend/internal/repository"
	"startfront-backend/internal/delivery"
)

func main() {
	config.InitDB()
	repository.InitDB(config.DB)
	delivery.StartServer()
}
