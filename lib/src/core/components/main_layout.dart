import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/flavors.dart';
import '../providers/layout_provider.dart';
import 'background_blobs.dart';
import 'sidebar.dart';

/// Shell layout combining background blobs + sidebar + scrollable content area.
/// Used as the builder for GoRouter's ShellRoute.
class MainLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  static final _blobKey = GlobalKey();
  bool _isLogoutHovered = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 802;

    return Scaffold(
      key: _scaffoldKey,
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
              child: BackgroundBlobs(key: _blobKey),
            ),
          ),

          // Main layout content + sidebar
          Positioned.fill(
            child: Row(
              children: [
                if (!isMobile) const SizedBox(width: 96), // 80 (sidebar) + 16 (margin)
                Expanded(
                  child: Column(
                    children: [
                      // Dynamic Header
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: _buildHeader(isMobile),
                      ),
                      // Content
                      Expanded(child: widget.child),
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
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final title = ref.watch(pageTitleProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isMobile) ...[
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(width: 8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildEnvironmentBadge(),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            ...ref.watch(headerActionsProvider),
            if (ref.watch(headerActionsProvider).isNotEmpty) const SizedBox(width: 24),
            if (!isMobile) ...[
              _buildHeaderIcon(null, 'Notifications', svgPath: 'assets/icons/notification.svg', hasBadge: true),
              _buildHeaderIcon(null, 'Profile', svgPath: 'assets/icons/user.svg'),
            ],
            const SizedBox(width: 16),
            MouseRegion(
              onEnter: (_) => setState(() => _isLogoutHovered = true),
              onExit: (_) => setState(() => _isLogoutHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isLogoutHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isLogoutHovered
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      if (_isLogoutHovered)
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AnimatedScale(
                        scale: _isLogoutHovered ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(_isLogoutHovered ? 2 : 0, 0, 0),
                          child: Icon(
                            Icons.logout_rounded,
                            size: 18,
                            color: _isLogoutHovered ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: _isLogoutHovered ? Colors.white : Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData? icon, String tooltip, {String? svgPath, bool hasBadge = false}) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
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
