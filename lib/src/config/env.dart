import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flavors.dart';

/// Environment-specific configuration.
class EnvConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  const EnvConfig({
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
  });
}

/// Provides the current flavor.
final flavorProvider = Provider<Flavor>((ref) => F.appFlavor);

/// Provides the flavor display name.
final flavorNameProvider = Provider<String>((ref) => F.name);

/// Provides the flavor title.
final flavorTitleProvider = Provider<String>((ref) => F.title);

/// Provides environment-specific configuration based on current flavor.
final envConfigProvider = Provider<EnvConfig>((ref) {
  final flavor = ref.watch(flavorProvider);
  switch (flavor) {
    case Flavor.dev:
      return const EnvConfig(
        apiBaseUrl: 'https://api-dev.startfront.io',
        enableLogging: true,
        enableAnalytics: false,
      );
    case Flavor.uat:
      return const EnvConfig(
        apiBaseUrl: 'https://api-uat.startfront.io',
        enableLogging: true,
        enableAnalytics: true,
      );
    case Flavor.prod:
      return const EnvConfig(
        apiBaseUrl: 'https://api.startfront.io',
        enableLogging: false,
        enableAnalytics: true,
      );
  }
});
