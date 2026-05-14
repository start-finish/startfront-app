import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/components/glass_card.dart';

class RoleDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const RoleDialog({super.key, this.initialData});

  @override
  State<RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final List<String> _permissions = ['read', 'write', 'delete', 'admin'];
  late List<String> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
    _selectedPermissions = List<String>.from(widget.initialData?['permissions'] ?? ['read']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                      widget.initialData == null ? 'CREATE NEW ROLE' : 'EDIT ROLE',
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
                  label: 'ROLE NAME',
                  hint: 'e.g. Content Manager',
                  controller: _nameController,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'DESCRIPTION',
                  hint: 'What can this role do?',
                  controller: _descriptionController,
                  icon: Icons.description_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Text(
                  'PERMISSIONS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _permissions.map((p) => _buildPermissionChip(p)).toList(),
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
                        widget.initialData == null ? 'Create Role' : 'Save Changes',
                        onTap: () {
                          if (_nameController.text.isNotEmpty) {
                            Navigator.pop(context, {
                              'name': _nameController.text,
                              'description': _descriptionController.text,
                              'permissions': _selectedPermissions,
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

  Widget _buildPermissionChip(String permission) {
    final isSelected = _selectedPermissions.contains(permission);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            if (_selectedPermissions.length > 1) {
              _selectedPermissions.remove(permission);
            }
          } else {
            _selectedPermissions.add(permission);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          permission.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
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
