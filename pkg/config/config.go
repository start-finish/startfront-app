package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v2"
)

type DBConfig struct {
	Host     string `yaml:"host"`
	Port     int    `yaml:"port"`
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	DBName   string `yaml:"dbname"`
	SSLMode  string `yaml:"sslmode"`
}

type Config struct {
	Database DBConfig `yaml:"database"`
}

var DB *DBConfig

func InitDB() {
	// Open and decode the YAML file
	data, err := os.ReadFile("configs/db.yaml")
	if err != nil {
		panic("Failed to read db.yaml: " + err.Error())
	}

	var cfg Config
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		panic("Failed to parse db.yaml: " + err.Error())
	}

	DB = &cfg.Database
	fmt.Println("✅ Loaded DB config:", DB)
}
