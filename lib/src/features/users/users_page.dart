import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  @override
  @override
  void initState() {
    super.initState();
    // Update the layout header when the page is mounted.
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'USER MANAGEMENT';
      ref.read(pageSubtitleProvider.notifier).state = '';
      ref.read(headerActionsProvider.notifier).state = []; // No actions in header
    });
  }

  bool _isAddHovered = false;

  Widget _buildAddUserButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isAddHovered = true),
          onExit: (_) => setState(() => _isAddHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {},
            child: AnimatedScale(
              scale: _isAddHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: _isAddHovered ? 0.5 : 0.3),
                      blurRadius: _isAddHovered ? 20 : 12,
                      spreadRadius: _isAddHovered ? 2 : 1,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add User',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Actions Row
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white.withValues(alpha: 0.4)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search users...',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildAddUserButton(),
            ],
          ),
          const SizedBox(height: 24),

          // User Table
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _tableHeader(),
                const Divider(color: Colors.white10, height: 24),
                _row('Alex Johnson', 'alex@startfront.io', 'Admin', true),
                _row('Sarah Chen', 'sarah@startfront.io', 'Editor', true),
                _row('Mike Torres', 'mike@startfront.io', 'Viewer', false),
                _row('Lisa Wang', 'lisa@startfront.io', 'Editor', true),
                _row('James Park', 'james@startfront.io', 'Viewer', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: [
        _hdr('Name', 3),
        _hdr('Email', 3),
        _hdr('Role', 2),
        _hdr('Status', 2),
      ],
    );
  }

  Widget _hdr(String s, int f) => Expanded(
    flex: f,
    child: Text(
      s,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    ),
  );

  Widget _row(String name, String email, String role, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              email,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              role,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (active ? Colors.greenAccent : Colors.grey).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                active ? 'Active' : 'Inactive',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: active ? Colors.greenAccent : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
