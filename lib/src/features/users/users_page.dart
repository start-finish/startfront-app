import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/components/glass_card.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import 'components/user_dialog.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  late List<_UserData> _users;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _users = _getInitialUsers();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(pageTitleProvider.notifier).state = 'USER MANAGEMENT';
      ref.read(pageSubtitleProvider.notifier).state = 'Manage your platform users and their access levels';
      ref.read(headerActionsProvider.notifier).state = [];
    });
    _searchController.addListener(_onSearchChanged);
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
        setState(() {
          final initials = result['name']!.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

          _users.add(
            _UserData(
              name: result['name']!,
              email: result['email']!,
              role: result['role']!,
              description: result['description']!,
              status: 'Active',
              initials: initials,
              color: Colors.blueAccent,
            ),
          );
        });
        AppNotification.show(
          context,
          title: 'User Added',
          message: 'New member "${result['name']}" has been registered.',
        );
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
        setState(() {
          final initials = result['name']!.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

          _users[index] = _UserData(
            name: result['name']!,
            email: result['email']!,
            role: result['role']!,
            description: result['description']!,
            status: user.status,
            initials: initials,
            color: user.color,
          );
        });
        AppNotification.show(
          context,
          title: 'User Updated',
          message: 'Profile for "${result['name']}" has been updated.',
        );
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
      setState(() {
        _users.removeAt(index);
      });
      AppNotification.show(
        context,
        title: 'User Deleted',
        message: 'Account for "${user.name}" has been removed.',
        type: NotificationType.error,
      );
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
          if (filteredUsers.isEmpty)
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
                onToggleStatus: () {
                  setState(() {
                    final actualIndex = _users.indexOf(filteredUsers[index]);
                    final user = _users[actualIndex];
                    final newStatus = user.status == 'Active' ? 'Inactive' : 'Active';
                    _users[actualIndex] = _UserData(
                      name: user.name,
                      email: user.email,
                      role: user.role,
                      status: newStatus,
                      initials: user.initials,
                      color: user.color,
                      description: user.description,
                    );
                  });
                  AppNotification.show(
                    context,
                    title: 'Status Updated',
                    message: '"${filteredUsers[index].name}" is now ${filteredUsers[index].status}.',
                    type: NotificationType.info,
                  );
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
            _buildStatCard('128', 'Total Users', Icons.group_rounded, const Color(0xFF6366F1)),
            _buildStatCard('94', 'Active Now', Icons.bolt_rounded, const Color(0xFF10B981)),
            _buildStatCard('12', 'New Today', Icons.person_add_rounded, const Color(0xFFF59E0B)),
            _buildStatCard('4', 'Pending', Icons.hourglass_empty_rounded, const Color(0xFFEF4444)),
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
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  List<_UserData> _getInitialUsers() {
    return [
      _UserData(
        name: 'Alex Johnson',
        email: 'alex@startfront.io',
        role: 'Super Admin',
        status: 'Active',
        initials: 'AJ',
        color: const Color(0xFF6366F1),
        description: 'Full access to all platform features and settings.',
      ),
      _UserData(
        name: 'Sarah Chen',
        email: 'sarah@startfront.io',
        role: 'Admin',
        status: 'Active',
        initials: 'SC',
        color: const Color(0xFF10B981),
        description: 'Administrative access with some system restrictions.',
      ),
      _UserData(
        name: 'Mike Torres',
        email: 'mike@startfront.io',
        role: 'Viewer',
        status: 'Inactive',
        initials: 'MT',
        color: const Color(0xFFF59E0B),
        description: 'Read-only access to dashboard and reporting tools.',
      ),
      _UserData(
        name: 'Lisa Wang',
        email: 'lisa@startfront.io',
        role: 'Editor',
        status: 'Active',
        initials: 'LW',
        color: const Color(0xFFEC4899),
        description: 'Can create, edit and manage platform content.',
      ),
      _UserData(
        name: 'James Park',
        email: 'james@startfront.io',
        role: 'Viewer',
        status: 'Active',
        initials: 'JP',
        color: const Color(0xFF8B5CF6),
        description: 'Read-only access to dashboard and reporting tools.',
      ),
    ];
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
  final String name;
  final String email;
  final String role;
  final String status;
  final String initials;
  final Color color;
  final String description;

  _UserData({
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
    final isActive = widget.user.status == 'Active';

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
