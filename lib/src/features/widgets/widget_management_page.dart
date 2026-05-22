import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import 'components/new_widget_dialog.dart';

class WidgetManagementPage extends ConsumerStatefulWidget {
  const WidgetManagementPage({super.key});

  @override
  ConsumerState<WidgetManagementPage> createState() => _WidgetManagementPageState();
}

class _WidgetManagementPageState extends ConsumerState<WidgetManagementPage> {
  final List<_WidgetData> _widgets = [
    _WidgetData(
      name: 'ElevatedButton',
      category: 'Control',
      description: 'A clickable button with elevation and hover effects',
      properties: 5,
      functions: 2,
      updatedAt: '2026-01-20',
      status: 'Active',
    ),
    _WidgetData(
      name: 'Text',
      category: 'Display',
      description: 'A customizable text element with styling options',
      properties: 4,
      functions: 1,
      updatedAt: '2026-01-18',
      status: 'Active',
    ),
    _WidgetData(
      name: 'TextField',
      category: 'Input',
      description: 'An input field for text entry with validation',
      properties: 4,
      functions: 2,
      updatedAt: '2026-01-14',
      status: 'Active',
    ),
  ];

  void _showCreateWidgetDialog() async {
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create Widget',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const NewWidgetDialog(),
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
          title: 'Confirm Create',
          message: 'Are you sure you want to register this new widget component?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _widgets.add(
            _WidgetData(
              name: result['name']!,
              category: result['category']!,
              description: result['description']!,
              properties: 0,
              functions: 0,
              updatedAt: 'Just now',
              status: 'Active',
            ),
          );
        });
        AppNotification.show(
          context,
          title: 'Widget Created',
          message: 'New component "${result['name']}" is now available.',
        );
      }
    }
  }

  void _showEditWidgetDialog(int index) async {
    final widget = _widgets[index];
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Widget',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => NewWidgetDialog(
        initialData: {
          'name': widget.name,
          'category': widget.category,
          'description': widget.description,
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
        barrierLabel: 'Confirm',
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
          title: 'Confirm Update',
          message: 'Are you sure you want to save these changes to the widget configuration?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _widgets[index] = _WidgetData(
            name: result['name']!,
            category: result['category']!,
            description: result['description']!,
            properties: widget.properties,
            functions: widget.functions,
            updatedAt: 'Modified now',
            status: widget.status,
          );
        });
        AppNotification.show(
          context,
          title: 'Widget Updated',
          message: 'Configuration for "${result['name']}" has been saved.',
        );
      }
    }
  }

  void _deleteWidget(int index) async {
    final widget = _widgets[index];
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Delete',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Delete Widget',
        message:
            'Are you sure you want to permanently remove "${widget.name}"? All associated configurations will be lost.',
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
        _widgets.removeAt(index);
      });
      AppNotification.show(
        context,
        title: 'Widget Deleted',
        message: 'Component "${widget.name}" has been removed.',
        type: NotificationType.error,
      );
    }
  }

  void _duplicateWidget(int index) async {
    final widget = _widgets[index];
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Duplicate',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Duplicate Widget',
        message: 'Do you want to create a copy of "${widget.name}"?',
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _widgets.add(
          _WidgetData(
            name: '${widget.name} Copy',
            category: widget.category,
            description: widget.description,
            properties: widget.properties,
            functions: widget.functions,
            updatedAt: 'Just now',
            status: widget.status,
          ),
        );
      });
      AppNotification.show(
        context,
        title: 'Widget Duplicated',
        message: '"${widget.name}" has been cloned successfully.',
      );
    }
  }

  void _showCodeDialog(int index) {
    final widget = _widgets[index];
    AppNotification.show(
      context,
      title: 'Code Preview',
      message: 'Generating Dart code for "${widget.name}"...',
      type: NotificationType.info,
    );
    // In a real app, this would show a dialog with the actual code
  }

  void _showPropertiesDialog(int index) {
    final widget = _widgets[index];
    AppNotification.show(
      context,
      title: 'Widget Properties',
      message: 'Viewing ${widget.properties} properties for "${widget.name}".',
      type: NotificationType.info,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'WIDGET MANAGEMENT';
      ref.read(pageSubtitleProvider.notifier).state = 'Configure and manage your application widgets';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              _buildStatCard('3', 'Total Widgets', isActive: true),
              const SizedBox(width: 16),
              _buildStatCard('1', 'Control Widgets'),
              const SizedBox(width: 16),
              _buildStatCard('1', 'Input Widgets'),
              const SizedBox(width: 16),
              _buildStatCard('0', 'Layout Widgets'),
            ],
          ),
          const SizedBox(height: 32),

          // All Widgets Zone
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Widgets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _HeaderButton(
                      label: 'Create New Widget',
                      icon: Icons.add,
                      onTap: _showCreateWidgetDialog,
                      isPrimary: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Widgets List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _widgets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _WidgetListItem(
                      data: _widgets[index],
                      onToggle: () {
                        setState(() {
                          final widget = _widgets[index];
                          widget.status = widget.status == 'Active' ? 'Inactive' : 'Active';
                        });
                      },
                      onEdit: () => _showEditWidgetDialog(index),
                      onDelete: () => _deleteWidget(index),
                      onDuplicate: () => _duplicateWidget(index),
                      onViewCode: () => _showCodeDialog(index),
                      onViewProperties: () => _showPropertiesDialog(index),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, {bool isActive = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.05),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}

class _HeaderButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isDropdown;

  const _HeaderButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.isPrimary = false,
    this.isDropdown = false,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: widget.isPrimary ? AppTheme.primaryGradient : null,
              color: widget.isPrimary ? null : Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isPrimary
                    ? Colors.white.withValues(alpha: _isHovered ? 0.4 : 0.2)
                    : Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.1),
              ),
              boxShadow: widget.isPrimary && _isHovered
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.isDropdown) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.5), size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WidgetData {
  final String name;
  final String category;
  final String description;
  final int properties;
  final int functions;
  final String updatedAt;
  String status;

  _WidgetData({
    required this.name,
    required this.category,
    required this.description,
    required this.properties,
    required this.functions,
    required this.updatedAt,
    required this.status,
  });
}

class _WidgetListItem extends StatefulWidget {
  final _WidgetData data;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onViewCode;
  final VoidCallback onViewProperties;

  const _WidgetListItem({
    required this.data,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.onViewCode,
    required this.onViewProperties,
  });

  @override
  State<_WidgetListItem> createState() => _WidgetListItemState();
}

class _WidgetListItemState extends State<_WidgetListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _isHovered ? 0.12 : 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: _isHovered ? 0.15 : 0.05),
              width: 0.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: SvgPicture.asset(
                  'assets/icons/widget management.svg',
                  width: 36,
                  height: 36,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.6),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.data.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildCategoryBadge(widget.data.category),
                        const SizedBox(width: 12),
                        _buildMetadataText('${widget.data.properties} properties'),
                        const SizedBox(width: 12),
                        _buildMetadataText('${widget.data.functions} functions'),
                        const SizedBox(width: 12),
                        _buildMetadataText('Updated ${widget.data.updatedAt}'),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              _ActionButton(
                iconPath: 'assets/icons/view code.svg',
                onTap: widget.onViewCode,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                iconPath: 'assets/icons/eye.svg',
                onTap: widget.onViewProperties,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                iconPath: 'assets/icons/copy.svg',
                onTap: widget.onDuplicate,
              ),
              const SizedBox(width: 8),
              _ActionButton(iconPath: 'assets/icons/edit.svg', onTap: widget.onEdit),
              const SizedBox(width: 8),
              _ActionButton(
                iconPath: 'assets/icons/delete.svg',
                onTap: widget.onDelete,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMetadataText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.3),
        fontSize: 11,
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.iconPath,
    required this.onTap,
    this.color,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: SvgPicture.asset(
            widget.iconPath,
            width: 36,
            height: 36,
            colorFilter: ColorFilter.mode(
              (widget.color ?? Colors.white).withValues(alpha: _isHovered ? 1.0 : 0.4),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
