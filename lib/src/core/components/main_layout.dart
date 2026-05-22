import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/flavors.dart';
import '../../features/auth/auth_provider.dart';
import '../providers/layout_provider.dart';
import '../providers/notification_provider.dart';
import 'background_blobs.dart';
import 'sidebar.dart';
import 'notification_panel.dart';
import 'page_entrance.dart';
import 'profile_dropdown.dart';

/// Shell layout combining background blobs + sidebar + scrollable content area.
/// Used as the builder for GoRouter's ShellRoute.
class MainLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool _showNotifications = false;
  bool _showProfileMenu = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  color: Colors.white.withValues(alpha: 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Confirm Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to end your session?\nAny unsaved progress will be lost.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                fixedSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                              ),
                              child: const Text(
                                'Stay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref.read(authProvider.notifier).logout();
                                    context.go('/login');
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Center(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 802;

    return Scaffold(
      drawer: isMobile
          ? const SizedBox(
              width: 280,
              child: Sidebar(isDrawer: true),
            )
          : null,
      body: Stack(
        children: [
          // Animated background - COMPLETELY DECOUPLED
          Positioned.fill(
            child: RepaintBoundary(
              child: const BackgroundBlobs(),
            ),
          ),

          // Main layout content + sidebar
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) const SizedBox(width: 96), // 80 (sidebar) + 16 (margin)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dynamic Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: _buildHeader(isMobile),
                      ),
                      // Content area that fills the remaining space and is scrollable
                      Expanded(
                        child: PageEntrance(
                          key: ValueKey(GoRouterState.of(context).uri.path),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sidebar on top (Desktop only)
          if (!isMobile)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Sidebar(),
            ),

          // Click outside to close notifications and profile dropdown (backdrop with premium blur and dim focus)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_showNotifications && !_showProfileMenu,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: (_showNotifications || _showProfileMenu) ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  if (value == 0.0) return const SizedBox.shrink();
                  return ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: value * 12,
                        sigmaY: value * 12,
                      ),
                      child: Container(
                        color: Colors.black.withValues(alpha: value * 0.25),
                        child: child,
                      ),
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () => setState(() {
                    _showNotifications = false;
                    _showProfileMenu = false;
                  }),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // Notification Panel Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            right: _showNotifications ? 0 : -420,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showNotifications ? 1.0 : 0.0,
              curve: Curves.easeInOutCubic,
              child: GestureDetector(
                onTap: () {}, // Prevent closing when clicking inside
                child: NotificationPanel(
                  onClose: () => setState(() => _showNotifications = false),
                ),
              ),
            ),
          ),

          // Profile Dropdown Menu Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            right: _showProfileMenu ? 0 : -350,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showProfileMenu ? 1.0 : 0.0,
              curve: Curves.easeInOutCubic,
              child: GestureDetector(
                onTap: () {}, // Prevent closing when clicking inside
                child: Align(
                  alignment: Alignment.topRight,
                  child: ProfileDropdown(
                    onClose: () => setState(() => _showProfileMenu = false),
                    onLogout: _showLogoutDialog,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final titleFromProvider = ref.watch(pageTitleProvider);
    final currentPath = GoRouterState.of(context).uri.path;

    // Determine title: prioritize provider, fallback to path-based title for instant feedback
    String title = titleFromProvider;
    if (titleFromProvider.isEmpty || titleFromProvider == 'ADMIN DASHBOARD') {
      // If the provider hasn't updated yet (common with deferred pages), use a fallback
      switch (currentPath) {
        case '/':
          title = 'ADMIN DASHBOARD';
          break;
        case '/platform':
          title = 'PLATFORM SCREENS';
          break;
        case '/navigation':
          title = 'NAVIGATION';
          break;
        case '/widget-management':
          title = 'WIDGET MANAGEMENT';
          break;
        case '/widget-preset':
          title = 'WIDGET PRESETS';
          break;
        case '/global-themes':
          title = 'GLOBAL THEMES';
          break;
        case '/user-management':
          title = 'USER MANAGEMENT';
          break;
        case '/role-permission':
          title = 'ROLE & PERMISSION';
          break;
        case '/analytics':
          title = 'ANALYTICS';
          break;
        case '/settings':
          title = 'SETTINGS';
          break;
        case '/assets':
          title = 'ASSETS';
          break;
        case '/layers':
          title = 'LAYERS';
          break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isMobile) ...[
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              const SizedBox(width: 8),
            ],
            _buildHeaderTitle(title, isMobile),
          ],
        ),
        Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(
                key: ValueKey(ref.watch(headerActionsProvider).length),
                children: [
                  ...ref.watch(headerActionsProvider),
                  if (ref.watch(headerActionsProvider).isNotEmpty) const SizedBox(width: 24),
                ],
              ),
            ),
            if (!isMobile) ...[
              _buildHeaderIcon(
                null,
                'Notifications',
                svgPath: 'assets/icons/notification.svg',
                hasBadge: ref.watch(unreadNotificationCountProvider) > 0,
                onTap: () => setState(() {
                  _showNotifications = !_showNotifications;
                  _showProfileMenu = false;
                }),
              ),
              _buildHeaderIcon(
                null,
                'Profile',
                svgPath: 'assets/icons/user.svg',
                onTap: () => setState(() {
                  _showProfileMenu = !_showProfileMenu;
                  _showNotifications = false;
                }),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderTitle(String title, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text(
            title,
            key: ValueKey(title),
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildEnvironmentBadge(),
      ],
    );
  }

  Widget _buildHeaderIcon(
    IconData? icon,
    String tooltip, {
    String? svgPath,
    bool hasBadge = false,
    VoidCallback? onTap,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: isHovered ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    if (isHovered)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (svgPath != null)
                      SvgPicture.asset(
                        svgPath,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          isHovered ? Colors.white : Colors.white70,
                          BlendMode.srcIn,
                        ),
                      )
                    else if (icon != null)
                      Icon(icon, color: isHovered ? Colors.white : Colors.white70, size: 20),
                    if (hasBadge)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnvironmentBadge() {
    final (label, color) = switch (F.appFlavor) {
      Flavor.dev => ('DEV', const Color(0xFFFF9800)),
      Flavor.uat => ('UAT', const Color(0xFF9C27B0)),
      Flavor.prod => ('LIVE', const Color(0xFF3B82F6)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
