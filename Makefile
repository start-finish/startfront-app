.PHONY: dev dev-uat dev-prod build-dev build-uat build-prod build-wasm clean flavors

## ── Development ──

dev:
	flutter run -d chrome --dart-define=FLAVOR=dev

dev-uat:
	flutter run -d chrome --dart-define=FLAVOR=uat

dev-prod:
	flutter run -d chrome --dart-define=FLAVOR=prod

## ── Build (Standard) ──

build-dev:
	flutter build web --dart-define=FLAVOR=dev

build-uat:
	flutter build web --dart-define=FLAVOR=uat

build-prod:
	flutter build web --dart-define=FLAVOR=prod

## ── Build (Wasm - High Performance) ──

build-wasm:
	flutter build web --wasm --dart-define=FLAVOR=prod

build-wasm-dev:
	flutter build web --wasm --dart-define=FLAVOR=dev

## ── Utilities ──

clean:
	flutter clean && flutter pub get

flavors:
	flutter pub run flutter_flavorizr

analyze:
	flutter analyze

format:
	dart format lib/
