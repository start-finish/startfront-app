import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage the current page title displayed in the MainLayout header.
final pageTitleProvider = StateProvider<String>((ref) => 'ADMIN DASHBOARD');

/// Provider to manage the page subtitle/overview text.
final pageSubtitleProvider = StateProvider<String>((ref) => 'Overview of your platform performance');

/// Provider to manage custom action widgets in the header (e.g. Add User button).
final headerActionsProvider = StateProvider<List<Widget>>((ref) => []);
