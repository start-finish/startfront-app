import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/theme.dart';

/// Premium icon sidebar with glassmorphism styling and GoRouter navigation.
class Sidebar extends StatelessWidget {
  final bool isDrawer;
  const Sidebar({super.key, this.isDrawer = false});

  static const _navItems = [
    _NavItem(icon: 'assets/icons/dashboard.svg', label: 'Dashboard', path: '/'),
    _NavItem(icon: 'assets/icons/platform screen.svg', label: 'Platform', path: '/platform'),
    _NavItem(icon: 'assets/icons/navigation.svg', label: 'Navigation', path: '/navigation'),
    _NavItem(icon: 'assets/icons/widget management.svg', label: 'Widget Management', path: '/widget-management'),
    _NavItem(icon: 'assets/icons/widget preset.svg', label: 'Widget Preset', path: '/widget-preset'),
    // _NavItem(icon: 'assets/icons/media.svg', label: 'Assets', path: '/assets'),
    // _NavItem(icon: 'assets/icons/tree.svg', label: 'Layers', path: '/layers'),
    // _NavItem(icon: 'assets/icons/action.svg', label: 'Log', path: '/settings'),
    _NavItem(icon: 'assets/icons/settings.svg', label: 'Settings', path: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();

    return Container(
      // width: 70,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Blur Layer (Strictly clipped to sidebar bounds)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Content Layer (Clip.none to allow labels to float outside)
          Column(
            children: [
              const SizedBox(height: 32),

              // Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.whiteGlassColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LOGO',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Nav Items
              Expanded(
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Column(
                    children: _navItems.map((item) {
                      final isActive = currentPath == item.path;
                      return _SidebarButton(
                        item: item,
                        isActive: isActive,
                        isDrawer: isDrawer,
                        onTap: () {
                          context.go(item.path);
                          if (isDrawer) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  final bool isDrawer;

  const _SidebarButton({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.isDrawer = false,
  });

  @override
  State<_SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<_SidebarButton> {
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovering = true);
        },
        onExit: (_) {
          setState(() => _hovering = false);
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.isDrawer
              ? AnimatedScale(
                  scale: _hovering ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppTheme.whiteGlassColor.withValues(alpha: 0.15)
                          : _hovering
                          ? AppTheme.whiteGlassColor.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.isActive
                            ? Colors.white.withValues(alpha: 0.2)
                            : _hovering
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      boxShadow: _hovering || widget.isActive
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        AnimatedRotation(
                          turns: _hovering ? 0.01 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          child: AnimatedScale(
                            scale: _hovering ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: SvgPicture.asset(
                              widget.item.icon,
                              width: 32,
                              height: 32,
                              colorFilter: ColorFilter.mode(
                                widget.isActive
                                    ? Colors.white
                                    : _hovering
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: widget.isActive
                                ? Colors.white
                                : _hovering
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            fontWeight: widget.isActive || _hovering ? FontWeight.bold : FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                          child: Text(widget.item.label),
                        ),
                        const Spacer(),
                        if (widget.isActive)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Active/Hover Indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: _hovering || widget.isActive ? -12 : -16,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _hovering || widget.isActive ? 1.0 : 0.0,
                        child: Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Icon Container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? AppTheme.blackGlassColor
                            : _hovering
                            ? AppTheme.blackGlassColor.withValues(alpha: 0.6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.isActive
                              ? Colors.white.withValues(alpha: 0.2)
                              : _hovering
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                        boxShadow: _hovering || widget.isActive
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: AnimatedRotation(
                        turns: _hovering ? 0.01 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        alignment: Alignment.center,
                        child: AnimatedScale(
                          scale: _hovering ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            transform: Matrix4.translationValues(0, _hovering ? -1 : 0, 0),
                            child: SvgPicture.asset(
                              widget.item.icon,
                              width: 36,
                              height: 36,
                              colorFilter: ColorFilter.mode(
                                widget.isActive
                                    ? Colors.white
                                    : _hovering
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : Colors.white.withValues(alpha: 0.4),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Premium Hint Label (Floating on the right)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      left: _hovering ? 68 : 50,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _hovering ? 1.0 : 0.0,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.item.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  final String path;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
