import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/components/glass_card.dart';

class UserDialog extends StatefulWidget {
  final Map<String, String>? initialData;
  const UserDialog({super.key, this.initialData});

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _emailController = TextEditingController(text: widget.initialData?['email'] ?? '');
    _roleController = TextEditingController(text: widget.initialData?['role'] ?? 'Viewer');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
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
                _buildField(
                  label: 'PLATFORM ROLE',
                  hint: 'e.g. Admin, Editor, Viewer',
                  controller: _roleController,
                  icon: Icons.shield_outlined,
                ),
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
                              'role': _roleController.text,
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
