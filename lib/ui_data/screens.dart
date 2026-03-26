import 'home_screen_data.dart';
import 'profile_screen_data.dart';

// Central registry of all dynamic screens
final Map<String, Map<String, dynamic>> screenRegistry = {
  '/': homeScreenData,
  'profile_screen': profileScreenData,
};
