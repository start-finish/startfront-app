import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ui_data/screens.dart';
import '../services/api_service.dart';

// Provides the entire screen registry
final screenRegistryProvider = Provider<Map<String, Map<String, dynamic>>>((ref) {
  return screenRegistry;
});

// A family provider to asynchronously fetch a specific screen's UI data by route name
final uiForRouteProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, routeName) async {
  return ApiService().fetchScreenUi(routeName);
});
