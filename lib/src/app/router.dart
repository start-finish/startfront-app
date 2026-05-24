import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/components/main_layout.dart';
// Deferred imports for code splitting
import '../features/dashboard/dashboard_page.dart' deferred as dashboard;
import '../features/platform/platform_page.dart' deferred as platform;
import '../features/navigation/navigation_page.dart' deferred as nav;
import '../features/widgets/widget_management_page.dart' deferred as widget_mgmt;
import '../features/widgets/widget_presets_page.dart' deferred as widget_presets;
import '../features/theme/global_theme_page.dart' deferred as themes;
import '../features/users/users.dart' deferred as users;
import '../features/analytics/analytics_page.dart' deferred as analytics;
import '../features/settings/settings_page.dart' deferred as settings;
import '../features/auth/login_page.dart' deferred as login;
import '../features/auth/signup_page.dart' deferred as signup;
import '../features/editor/editor_page.dart' deferred as editor;

/// Global navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Global GoRouter provider.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => _DeferredPage(
          loader: login.loadLibrary,
          builder: () => login.LoginPage(),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => _DeferredPage(
          loader: signup.loadLibrary,
          builder: () => signup.SignupPage(),
        ),
      ),
      GoRoute(
        path: '/editor',
        builder: (context, state) => _DeferredPage(
          loader: editor.loadLibrary,
          builder: () => editor.EditorPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: dashboard.loadLibrary,
                builder: () => dashboard.DashboardPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/platform',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: platform.loadLibrary,
                builder: () => platform.PlatformPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/navigation',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: nav.loadLibrary,
                builder: () => nav.NavigationPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/widget-management',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: widget_mgmt.loadLibrary,
                builder: () => widget_mgmt.WidgetManagementPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/widget-preset',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: widget_presets.loadLibrary,
                builder: () => widget_presets.WidgetPresetsPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/global-themes',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: themes.loadLibrary,
                builder: () => themes.GlobalThemePage(),
              ),
            ),
          ),
          GoRoute(
            path: '/role-permission',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredPage(
                loader: users.loadLibrary,
                builder: () => users.RolePermissionPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/user-management',
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
        final isDone = snapshot.connectionState == ConnectionState.done;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: isDone
              ? builder()
              : const Align(
                  alignment: Alignment.topLeft,
                  key: ValueKey('loader'),
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: Color(0xFF00D2D2),
                      strokeWidth: 2,
                    ),
                  ),
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
