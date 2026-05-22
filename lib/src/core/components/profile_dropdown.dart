import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';

class ProfileDropdown extends ConsumerWidget {
  final VoidCallback onClose;
  final VoidCallback onLogout;

  const ProfileDropdown({
    super.key,
    required this.onClose,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final email = auth.email ?? 'admin@startfront.com';

    // Extract formatted name from email (e.g. admin@startfront.com -> ADMIN)
    final rawName = email.split('@').first;
    final displayName = rawName.toUpperCase();
    final initials = rawName.substring(0, rawName.length > 1 ? 2 : 1).toUpperCase();

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 18, top: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User header info
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Styled Avatar Circle
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Administrator role pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00D2D2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Platform Admin',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

              // Action Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    _HoverMenuOption(
                      icon: Icons.settings_suggest_rounded,
                      label: 'Account Settings',
                      onTap: () {
                        onClose();
                        context.go('/settings');
                      },
                    ),
                    const SizedBox(height: 4),
                    _HoverMenuOption(
                      icon: Icons.list_alt_rounded,
                      label: 'Activity Log',
                      onTap: () {
                        onClose();
                        context.go('/user-management'); // Route to active dashboard log/mgmt
                      },
                    ),
                    const SizedBox(height: 4),
                    _HoverMenuOption(
                      icon: Icons.palette_rounded,
                      label: 'Global Theme',
                      onTap: () {
                        onClose();
                        context.go('/global-themes');
                      },
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                    const SizedBox(height: 12),
                    _HoverMenuOption(
                      icon: Icons.logout_rounded,
                      label: 'Logout Session',
                      iconColor: const Color(0xFFFF4D4F),
                      textColor: const Color(0xFFFF4D4F),
                      hoverColor: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
                      onTap: () {
                        onClose();
                        onLogout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverMenuOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? hoverColor;

  const _HoverMenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.hoverColor,
  });

  @override
  State<_HoverMenuOption> createState() => _HoverMenuOptionState();
}

class _HoverMenuOptionState extends State<_HoverMenuOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeHoverColor = widget.hoverColor ?? Colors.white.withValues(alpha: 0.08);
    final finalIconColor = widget.iconColor ?? Colors.white70;
    final finalTextColor = widget.textColor ?? Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? themeHoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_isHovered ? 2 : 0, 0, 0),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: _isHovered ? (widget.iconColor ?? Colors.white) : finalIconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: _isHovered ? (widget.textColor ?? Colors.white) : finalTextColor.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovered ? 0.6 : 0.0,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
