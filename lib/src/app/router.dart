import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/components/main_layout.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/platform/platform_page.dart';
import '../features/navigation/navigation_page.dart';
import '../features/widgets/widget_management_page.dart';
import '../features/widgets/widget_presets_page.dart';

// Deferred imports for code splitting
import '../features/users/users_page.dart' deferred as users;
import '../features/analytics/analytics_page.dart' deferred as analytics;
import '../features/settings/settings_page.dart' deferred as settings;

/// Global GoRouter provider.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/platform',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlatformPage(),
            ),
          ),
          GoRoute(
            path: '/navigation',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NavigationPage(),
            ),
          ),
          GoRoute(
            path: '/widget-management',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WidgetManagementPage(),
            ),
          ),
          GoRoute(
            path: '/widget-preset',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WidgetPresetsPage(),
            ),
          ),
          GoRoute(
            path: '/users',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: users.loadLibrary,
                builder: () => users.UsersPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: analytics.loadLibrary,
                builder: () => analytics.AnalyticsPage(),
              ),
            ),
          ),
          // Assets and Layers reuse a placeholder for now
          GoRoute(
            path: '/assets',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _ComingSoonPage(title: 'ASSETS'),
            ),
          ),
          GoRoute(
            path: '/layers',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _ComingSoonPage(title: 'LAYERS'),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: settings.loadLibrary,
                builder: () => settings.SettingsPage(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
});

/// Deferred loading wrapper – shows a loading shimmer while the library loads.
class _DeferredPage extends StatelessWidget {
  final Future<void> Function() loader;
  final Widget Function() builder;

  const _DeferredPage({required this.loader, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loader(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder();
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D2D2),
            strokeWidth: 2,
          ),
        );
      },
    );
  }
}

/// Placeholder page for features not yet implemented.
class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_rounded, size: 48, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('Coming Soon', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.4))),
        ],
      ),
    );
  }
}
