import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/theme.dart';
import '../../../core/components/glass_card.dart';
import '../../../core/services/base_service.dart';
import '../../../core/components/skeleton_loader.dart';

class UserDialog extends ConsumerStatefulWidget {
  final Map<String, String>? initialData;
  const UserDialog({super.key, this.initialData});

  @override
  ConsumerState<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends ConsumerState<UserDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  String _selectedRole = 'Viewer';
  List<String> _availableRoles = ['Super Admin', 'Admin', 'Editor', 'Viewer'];
  bool _isLoadingRoles = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _emailController = TextEditingController(text: widget.initialData?['email'] ?? '');
    _selectedRole = widget.initialData?['role'] ?? 'Viewer';
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');

    // Fetch live roles from backend database
    Future.microtask(() => _fetchRoles());
  }

  Future<void> _fetchRoles() async {
    try {
      final baseService = ref.read(baseServiceProvider);
      final data = await baseService.listRoles(
        page: 1,
        limit: 100,
      );
      if (data != null && data is List) {
        final rolesList = data
            .map<String>((r) {
              return r['role_name'] as String? ?? '';
            })
            .where((name) => name.isNotEmpty)
            .toList();

        if (rolesList.isNotEmpty && mounted) {
          setState(() {
            _availableRoles = rolesList;

            // Adjust casing or matching for initially selected role
            final hasMatch = _availableRoles.any((r) => r.toLowerCase() == _selectedRole.toLowerCase());
            if (hasMatch) {
              _selectedRole = _availableRoles.firstWhere((r) => r.toLowerCase() == _selectedRole.toLowerCase());
            } else {
              _selectedRole = _availableRoles.first;
            }
            _isLoadingRoles = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching roles in dialog: $e');
    }
    if (mounted) {
      setState(() {
        _isLoadingRoles = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  IconData _getRoleIcon(String role) {
    final r = role.toLowerCase();
    if (r.contains('super')) return Icons.workspace_premium_rounded;
    if (r.contains('admin')) return Icons.admin_panel_settings_rounded;
    if (r.contains('editor')) return Icons.edit_rounded;
    return Icons.visibility_rounded;
  }

  Color _getRoleColor(String role) {
    final r = role.toLowerCase();
    if (r.contains('super')) return const Color(0xFFFFB020); // Amber Gold
    if (r.contains('admin')) return const Color(0xFFC084FC); // Purple
    if (r.contains('editor')) return const Color(0xFF22D3EE); // Teal
    return Colors.white60; // Silver/Grey
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 500,
          child: GlassCard(
            backgroundOpacity: 0.2,
            borderOpacity: 0.3,
            borderRadius: 24,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialData == null ? 'ADD NEW USER' : 'EDIT USER',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'FULL NAME',
                  hint: 'e.g. John Doe',
                  controller: _nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'EMAIL ADDRESS',
                  hint: 'e.g. john@startfront.io',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildRoleDropdown(),
                const SizedBox(height: 16),
                _buildField(
                  label: 'BIO / DESCRIPTION',
                  hint: 'Briefly describe user responsibilities...',
                  controller: _descriptionController,
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        'Cancel',
                        onTap: () => Navigator.pop(context),
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildButton(
                        widget.initialData == null ? 'Create User' : 'Save Changes',
                        onTap: () {
                          if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
                            Navigator.pop(context, {
                              'name': _nameController.text,
                              'email': _emailController.text,
                              'role': _selectedRole,
                              'description': _descriptionController.text,
                            });
                          }
                        },
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PLATFORM ROLE',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _isLoadingRoles
            ? const Row(
                children: [
                  SkeletonLoader(width: 100, height: 32, borderRadius: BorderRadius.all(Radius.circular(8))),
                  SizedBox(width: 8),
                  SkeletonLoader(width: 80, height: 32, borderRadius: BorderRadius.all(Radius.circular(8))),
                  SizedBox(width: 8),
                  SkeletonLoader(width: 80, height: 32, borderRadius: BorderRadius.all(Radius.circular(8))),
                ],
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableRoles.map((role) {
                  final isSelected = _selectedRole.toLowerCase() == role.toLowerCase();
                  final roleColor = _getRoleColor(role);
                  final roleIcon = _getRoleIcon(role);
                  return _RoleChip(
                    role: role,
                    isSelected: isSelected,
                    color: roleColor,
                    icon: roleIcon,
                    onTap: () {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    bool isFocused = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Focus(
              onFocusChange: (focus) => setState(() => isFocused = focus),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isFocused ? 0.08 : 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? AppTheme.primaryColor.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  decoration: AppTheme.inputDecoration(
                    hint: hint,
                    prefixIcon: icon,
                    isFocused: isFocused,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(String label, {required VoidCallback onTap, required bool isPrimary}) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: isPrimary ? AppTheme.primaryGradient : null,
                color: isPrimary ? null : Colors.white.withValues(alpha: isHovered ? 0.12 : 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: isHovered ? 0.2 : 0.1),
                ),
                boxShadow: isPrimary && isHovered
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: isHovered ? 1.0 : 0.9),
                  fontWeight: isHovered ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoleChip extends StatefulWidget {
  final String role;
  final bool isSelected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleChip({
    required this.role,
    required this.isSelected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_RoleChip> createState() => _RoleChipState();
}

class _RoleChipState extends State<_RoleChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color;
    final isSelected = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.08),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.3),
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                widget.role.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
