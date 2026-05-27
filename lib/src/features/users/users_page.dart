import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as developer;
import '../../core/constants/theme.dart';
import '../../core/components/glass_card.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import '../../core/services/base_service.dart';
import 'components/user_dialog.dart';
import '../../core/components/skeleton_loader.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  late List<_UserData> _users;
  bool _isLoading = true;
  int _totalCount = 0;
  int _activeCount = 0;
  int _newTodayCount = 0;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _users = [];
    Future.microtask(() {
      if (!mounted) return;
      ref.read(pageTitleProvider.notifier).state = 'USER MANAGEMENT';
      ref.read(pageSubtitleProvider.notifier).state = 'Manage your platform users and their access levels';
      ref.read(headerActionsProvider.notifier).state = [];
      _loadUsers();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final baseService = ref.read(baseServiceProvider);
      final data = await baseService.listUsers(
        page: 1,
        limit: 100,
      );
      if (data != null && data is List) {
        setState(() {
          _users = data.map<_UserData>((u) {
            final id = u['id'] as int?;
            final username = u['username'] as String? ?? '';
            final email = u['email'] as String? ?? '';
            final role = u['role'] as String? ?? 'Viewer';
            final description = u['description'] as String? ?? '';
            final status = u['status'] as String? ?? 'Active';
            final initials = username.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
            return _UserData(
              id: id,
              name: username,
              email: email,
              role: role,
              description: description,
              status: status,
              initials: initials,
              color: Colors.blueAccent,
            );
          }).toList();
        });
      }

      // Load counts
      final countRes = await baseService.getUsersCount();
      if (countRes != null && countRes is Map) {
        setState(() {
          _totalCount = (countRes['total'] as num?)?.toInt() ?? 0;
          _activeCount = (countRes['active'] as num?)?.toInt() ?? 0;
          _newTodayCount = (countRes['new_today'] as num?)?.toInt() ?? 0;
          _pendingCount = (countRes['pending'] as num?)?.toInt() ?? 0;
        });
      }
    } catch (e) {
      developer.log('Error loading users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddUserDialog() async {
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add User',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const UserDialog(),
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
          title: 'Confirm Add User',
          message: 'Are you sure you want to add this new member to the platform?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        try {
          final baseService = ref.read(baseServiceProvider);
          await baseService.createUser(
            username: result['name']!,
            email: result['email']!,
            password: 'UserPassword123!',
            status: 'Active',
            role: result['role']!,
            description: result['description']!,
          );
          _loadUsers();
          AppNotification.show(
            context,
            title: 'User Added',
            message: 'New member "${result['name']}" has been registered.',
          );
        } catch (e) {
          AppNotification.show(
            context,
            title: 'Error Adding User',
            message: e.toString().replaceAll('Exception:', ''),
            type: NotificationType.error,
          );
        }
      }
    }
  }

  void _showEditUserDialog(int index) async {
    final user = _users[index];
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit User',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => UserDialog(
        initialData: {
          'name': user.name,
          'email': user.email,
          'role': user.role,
          'description': user.description,
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
          message: 'Are you sure you want to save these changes to the user profile?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        try {
          final baseService = ref.read(baseServiceProvider);
          await baseService.updateUser(
            id: user.id!,
            username: result['name']!,
            email: result['email']!,
            role: result['role']!,
            description: result['description']!,
          );
          _loadUsers();
          AppNotification.show(
            context,
            title: 'User Updated',
            message: 'Profile for "${result['name']}" has been updated.',
          );
        } catch (e) {
          AppNotification.show(
            context,
            title: 'Error Updating User',
            message: e.toString().replaceAll('Exception:', ''),
            type: NotificationType.error,
          );
        }
      }
    }
  }

  void _deleteUser(int index) async {
    final user = _users[index];
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Delete',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Delete User',
        message: 'Are you sure you want to permanently remove "${user.name}"? This action cannot be undone.',
        confirmLabel: 'Yes, Delete',
        isDestructive: true,
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final baseService = ref.read(baseServiceProvider);
        await baseService.deleteUser(user.id!);
        _loadUsers();
        AppNotification.show(
          context,
          title: 'User Deleted',
          message: 'Account for "${user.name}" has been removed.',
          type: NotificationType.error,
        );
      } catch (e) {
        AppNotification.show(
          context,
          title: 'Error Deleting User',
          message: e.toString().replaceAll('Exception:', ''),
          type: NotificationType.error,
        );
      }
    }
  }

  void _onSearchChanged() {
    if (!mounted) return;
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    try {
      _searchController.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 802;

    final allUsers = _users;
    final filteredUsers = allUsers.where((user) {
      return user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery) ||
          user.role.toLowerCase().contains(_searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards
          _buildStatSection(isMobile),
          const SizedBox(height: 32),

          // Search & Actions
          _buildTopBar(isMobile),
          const SizedBox(height: 24),

          // Users List (Card Style)
          if (_isLoading)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 20,
                backgroundOpacity: 0.04,
                borderOpacity: 0.08,
                child: Row(
                  children: [
                    const SkeletonLoader(
                      width: 52,
                      height: 52,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLoader(width: 140, height: 16),
                          const SizedBox(height: 8),
                          const SkeletonLoader(width: 200, height: 12),
                          if (!isMobile) ...[
                            const SizedBox(height: 8),
                            const SkeletonLoader(width: 320, height: 10),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (!isMobile) ...[
                      const SkeletonLoader(width: 80, height: 24),
                      const SizedBox(width: 24),
                      const SkeletonLoader(width: 60, height: 24),
                      const SizedBox(width: 24),
                    ],
                    const SkeletonLoader(width: 32, height: 32, borderRadius: BorderRadius.all(Radius.circular(8))),
                  ],
                ),
              ),
            )
          else if (filteredUsers.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _UserListItem(
                user: filteredUsers[index],
                isMobile: isMobile,
                onEdit: () => _showEditUserDialog(_users.indexOf(filteredUsers[index])),
                onDelete: () => _deleteUser(_users.indexOf(filteredUsers[index])),
                onToggleStatus: () async {
                  final user = filteredUsers[index];
                  final isActive = user.status.toLowerCase() == 'active';
                  final newStatus = isActive ? 'Inactive' : 'Active';
                  try {
                    final baseService = ref.read(baseServiceProvider);
                    await baseService.updateUser(
                      id: user.id!,
                      status: newStatus,
                    );
                    _loadUsers();
                    AppNotification.show(
                      context,
                      title: 'Status Updated',
                      message: '"${user.name}" is now $newStatus.',
                      type: NotificationType.info,
                    );
                  } catch (e) {
                    AppNotification.show(
                      context,
                      title: 'Error Updating Status',
                      message: e.toString().replaceAll('Exception:', ''),
                      type: NotificationType.error,
                    );
                  }
                },
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatSection(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isMobile ? 2 : (constraints.maxWidth > 1200 ? 4 : 2);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isMobile ? 1.4 : 2.8,
          children: [
            _buildStatCard('$_totalCount', 'Total Users', Icons.group_rounded, const Color(0xFF6366F1)),
            _buildStatCard('$_activeCount', 'Active Now', Icons.bolt_rounded, const Color(0xFF10B981)),
            _buildStatCard('$_newTodayCount', 'New Today', Icons.person_add_rounded, const Color(0xFFF59E0B)),
            _buildStatCard('$_pendingCount', 'Pending', Icons.hourglass_empty_rounded, const Color(0xFFEF4444)),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: SkeletonLoader(width: 40, height: 16),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: _buildAddUserButton()),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildAddUserButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF002451).withValues(alpha: 0.4), // Darker, hollow feel
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)), // Subtle border
      ),
      child: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, email or role...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.3), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAddUserButton() {
    return _PrimaryActionButton(
      label: 'Add User',
      icon: Icons.add_rounded,
      onTap: _showAddUserDialog,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, color: Colors.white.withValues(alpha: 0.1), size: 64),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: isHovered ? 0.4 : 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: isHovered ? 0.5 : 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: isHovered ? 0.2 : 0.1),
                  blurRadius: isHovered ? 15 : 10,
                  offset: Offset(0, isHovered ? 6 : 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserData {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String initials;
  final Color color;
  final String description;

  _UserData({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.initials,
    required this.color,
    required this.description,
  });
}

class _UserListItem extends StatefulWidget {
  final _UserData user;
  final bool isMobile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _UserListItem({
    required this.user,
    required this.isMobile,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  State<_UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<_UserListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.user.status.toLowerCase() == 'active';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        backgroundOpacity: _isHovered ? 0.08 : 0.04,
        borderOpacity: _isHovered ? 0.15 : 0.08,
        child: Row(
          children: [
            // User Icon Box
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.user.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      widget.user.initials,
                      style: TextStyle(
                        color: widget.user.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),

            // User Main Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 13,
                    ),
                  ),
                  if (!widget.isMobile) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.user.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.15),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (!widget.isMobile) ...[
              // Role Badge
              _buildTextBadge(widget.user.role),
              const SizedBox(width: 8),

              // Status Badge
              _buildStatusBadge(isActive, onTap: widget.onToggleStatus),
              const SizedBox(width: 16),
            ],

            // Actions
            Row(
              children: [
                _buildActionIcon('assets/icons/edit.svg', onTap: widget.onEdit),
                const SizedBox(width: 8),
                _buildActionIcon('assets/icons/delete.svg', isDelete: true, onTap: widget.onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toLowerCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive, {required VoidCallback onTap}) {
    final color = isActive ? const Color(0xFF10B981) : Colors.white.withValues(alpha: 0.3);
    bool isBadgeHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isBadgeHovered = true),
          onExit: (_) => setState(() => isBadgeHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: isBadgeHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isBadgeHovered ? 0.15 : 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: isBadgeHovered ? 0.3 : 0.1)),
                  boxShadow: isBadgeHovered
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.user.status.toLowerCase(),
                      style: TextStyle(
                        color: color.withValues(alpha: isBadgeHovered ? 1.0 : 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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

  Widget _buildActionIcon(String iconPath, {bool isDelete = false, required VoidCallback onTap}) {
    bool isIconHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isIconHovered = true),
          onExit: (_) => setState(() => isIconHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: isIconHovered ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isIconHovered
                      ? (isDelete ? Colors.redAccent : Colors.white).withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    isIconHovered ? (isDelete ? Colors.redAccent : Colors.white) : Colors.white.withValues(alpha: 0.2),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
