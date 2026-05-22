import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/components/glass_card.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import 'components/role_dialog.dart';
import '../../core/constants/theme.dart';

class RolePermissionPage extends ConsumerStatefulWidget {
  const RolePermissionPage({super.key});

  @override
  ConsumerState<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends ConsumerState<RolePermissionPage> {
  late List<_RoleData> _roles;

  @override
  void initState() {
    super.initState();
    _roles = _getInitialRoles();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(pageTitleProvider.notifier).state = 'ROLES & PERMISSIONS';
      ref.read(pageSubtitleProvider.notifier).state = 'Manage user roles and their associated permissions';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  void _showCreateRoleDialog() async {
    final result = await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create Role',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const RoleDialog(),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );

    if (result != null && mounted) {
      final confirmed = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Confirm',
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
          title: 'Confirm Create Role',
          message: 'Are you sure you want to create this new user role?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _roles.add(
            _RoleData(
              name: result['name']!,
              description: result['description']!,
              userCount: 0,
              permissions: List<String>.from(result['permissions']),
            ),
          );
        });
        AppNotification.show(
          context,
          title: 'Role Created',
          message: 'The role "${result['name']}" has been added successfully.',
        );
      }
    }
  }

  void _showEditRoleDialog(int index) async {
    final role = _roles[index];
    final result = await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Role',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => RoleDialog(
        initialData: {
          'name': role.name,
          'description': role.description,
          'permissions': role.permissions,
        },
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );

    if (result != null && mounted) {
      final confirmed = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Confirm Update',
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
          title: 'Confirm Update',
          message: 'Are you sure you want to save these changes to the role?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _roles[index] = _RoleData(
            name: result['name']!,
            description: result['description']!,
            userCount: role.userCount,
            permissions: List<String>.from(result['permissions']),
          );
        });
        AppNotification.show(
          context,
          title: 'Role Updated',
          message: 'The role "${result['name']}" has been modified.',
        );
      }
    }
  }

  void _deleteRole(int index) async {
    final role = _roles[index];
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Delete',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Delete Role',
        message:
            'Are you sure you want to permanently delete the "${role.name}" role? This may affect users assigned to it.',
        confirmLabel: 'Yes, Delete',
        isDestructive: true,
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _roles.removeAt(index);
      });
      AppNotification.show(
        context,
        title: 'Role Deleted',
        message: 'The role "${role.name}" has been removed.',
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Row
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 802 ? 2 : 1),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: constraints.maxWidth > 1200 ? 2.5 : (constraints.maxWidth > 802 ? 3.0 : 4.0),
                children: [
                  _buildStatCard('4', 'Total Roles'),
                  _buildStatCard('44', 'Total Users'),
                  _buildStatCard('1', 'Admin Roles'),
                  _buildStatCard('4', 'Permission Types'),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Role Management Main Card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Role Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCreateRoleButton(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildRoleList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRoleButton() {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            scale: isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _showCreateRoleDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Create Role',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
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

  Widget _buildRoleList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _roles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _RoleItemCard(
        role: _roles[index],
        onEdit: () => _showEditRoleDialog(index),
        onDelete: () => _deleteRole(index),
      ),
    );
  }

  List<_RoleData> _getInitialRoles() {
    return [
      _RoleData(
        name: 'Super Admin',
        description: 'Full access to all platform features',
        userCount: 2,
        permissions: ['read', 'write', 'delete', 'admin'],
      ),
      _RoleData(
        name: 'Admin',
        description: 'Administrative access with some restrictions',
        userCount: 5,
        permissions: ['read', 'write', 'delete'],
      ),
      _RoleData(
        name: 'Editor',
        description: 'Can create and edit content',
        userCount: 12,
        permissions: ['read', 'write'],
      ),
      _RoleData(
        name: 'Viewer',
        description: 'Read-only access',
        userCount: 25,
        permissions: ['read'],
      ),
    ];
  }
}

class _RoleData {
  final String name;
  final String description;
  final int userCount;
  final List<String> permissions;

  _RoleData({
    required this.name,
    required this.description,
    required this.userCount,
    required this.permissions,
  });
}

class _RoleItemCard extends StatefulWidget {
  final _RoleData role;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _RoleItemCard({
    required this.role,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_RoleItemCard> createState() => _RoleItemCardState();
}

class _RoleItemCardState extends State<_RoleItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  'assets/icons/role permission.svg',
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.5),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.role.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.role.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 14, color: Colors.white.withValues(alpha: 0.3)),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.role.userCount} users',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (MediaQuery.of(context).size.width > 600)
              Wrap(
                spacing: 8,
                children: widget.role.permissions.map((p) => _buildPermissionBadge(p)).toList(),
              ),
            const SizedBox(width: 24),
            Row(
              children: [
                _buildActionIcon('assets/icons/edit.svg', widget.onEdit),
                const SizedBox(width: 12),
                _buildActionIcon('assets/icons/delete.svg', widget.onDelete, isDelete: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionBadge(String permission) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        permission,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionIcon(String iconPath, VoidCallback onTap, {bool isDelete = false}) {
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
              scale: isHovered ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: SvgPicture.asset(
                iconPath,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  isHovered ? (isDelete ? Colors.redAccent : Colors.white) : Colors.white.withValues(alpha: 0.4),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
