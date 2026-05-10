import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _isLogoutHovered = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1024;

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
          // Animated background
          const Positioned.fill(child: BackgroundBlobs()),

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

          // Sidebar on top of everything (Desktop only)
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
            // Custom Page Actions
            ...ref.watch(headerActionsProvider),
            if (ref.watch(headerActionsProvider).isNotEmpty) const SizedBox(width: 24),
            // Placeholder circles (Hide on mobile)
            if (!isMobile)
              ...List.generate(
                3,
                (index) => Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            // Logout Button
            MouseRegion(
              onEnter: (_) => setState(() => _isLogoutHovered = true),
              onExit: (_) => setState(() => _isLogoutHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
