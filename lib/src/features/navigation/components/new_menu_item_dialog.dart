import 'package:flutter/material.dart';
import '../../../core/components/glass_card.dart';
import '../../../core/constants/theme.dart';

class MenuItemDialog extends StatefulWidget {
  final Map<String, String>? initialData;
  const MenuItemDialog({super.key, this.initialData});

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  late final TextEditingController _labelController;
  late final TextEditingController _pathController;
  late final TextEditingController _tagController;
  late final TextEditingController _iconController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _pathController = TextEditingController(text: widget.initialData?['path'] ?? '');
    _tagController = TextEditingController(text: widget.initialData?['tag'] ?? '');
    _iconController = TextEditingController(text: widget.initialData?['icon'] ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    _pathController.dispose();
    _tagController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: GlassCard(
            backgroundOpacity: 0.12,
            borderOpacity: 0.15,
            borderRadius: 24,
            padding: const EdgeInsets.all(32),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'EDIT MENU ITEM' : 'ADD MENU ITEM',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing ? 'Modify your navigation item' : 'Configure your platform navigation',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_note_rounded : Icons.menu_open_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Fields
                  _buildField(
                    label: 'ITEM LABEL',
                    controller: _labelController,
                    icon: Icons.text_fields_rounded,
                    hint: 'e.g. Dashboard',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'ROUTE PATH',
                    controller: _pathController,
                    icon: Icons.link_rounded,
                    hint: 'e.g. /dashboard',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'TAG / ACCESS',
                    controller: _tagController,
                    icon: Icons.shield_outlined,
                    hint: 'e.g. Authenticated',
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    label: 'ICON NAME',
                    controller: _iconController,
                    icon: Icons.image_outlined,
                    hint: 'e.g. dashboard',
                  ),
                  const SizedBox(height: 40),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          label: 'Cancel',
                          onTap: () => Navigator.pop(context),
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildButton(
                          label: isEditing ? 'Save Changes' : 'Add Item',
                          onTap: () {
                            if (_labelController.text.isNotEmpty && _pathController.text.isNotEmpty) {
                              Navigator.pop(context, {
                                'title': _labelController.text,
                                'path': _pathController.text,
                                'tag': _tagController.text.isEmpty ? 'Public' : _tagController.text,
                                'icon': _iconController.text.isEmpty ? 'Grid3X3' : _iconController.text,
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
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
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
                color: Colors.white.withValues(alpha: 0.4),
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
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 13),
                    prefixIcon: Icon(
                      icon,
                      color: isFocused ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.3),
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 44,
              decoration: BoxDecoration(
                gradient: isPrimary ? AppTheme.primaryGradient : null,
                color: isPrimary ? null : Colors.white.withValues(alpha: isHovered ? 0.12 : 0.06),
                borderRadius: BorderRadius.circular(10),
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
              child: Center(
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
          ),
        );
      },
    );
  }
}
