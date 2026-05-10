## Running with Flavors

### Jaspr (Web)

Run the project with a specific flavor using the `-d` flag:

```bash
# Development
jaspr serve -d FLAVOR=dev

# UAT
jaspr serve -d FLAVOR=uat

# Production
jaspr serve -d FLAVOR=prod
```

### Flutter (Mobile/Desktop)

The project is also configured for Flutter flavors:

```bash
# Android
flutter run --flavor dev -t lib/main_dev.dart

# iOS
flutter run --flavor dev -t lib/main_dev.dart
```
