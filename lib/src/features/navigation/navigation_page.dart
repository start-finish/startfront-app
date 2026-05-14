import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import 'components/new_menu_item_dialog.dart';

class NavItem {
  final String title;
  final String tag;
  final String path;
  final String icon;
  final String iconPath;
  bool visible;

  NavItem({
    required this.title,
    required this.tag,
    required this.path,
    required this.icon,
    required this.iconPath,
    this.visible = true,
  });
}

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  final List<NavItem> _items = [
    NavItem(
      title: 'DASHBOARD',
      tag: 'Authenticated',
      path: '/dashboard',
      icon: 'LayoutDashboard',
      iconPath: 'assets/icons/dashboard.svg',
    ),
    NavItem(
      title: 'VISUAL EDITOR',
      tag: 'Authenticated',
      path: '/editor',
      icon: 'Palette',
      iconPath: 'assets/icons/widget palatte.svg',
    ),
    NavItem(
      title: 'API MANAGER',
      tag: 'Authenticated',
      path: '/templates',
      icon: 'Database',
      iconPath: 'assets/icons/database.svg',
    ),
    NavItem(
      title: 'Templates',
      tag: 'Public',
      path: '/templates',
      icon: 'Grid3X3',
      iconPath: 'assets/icons/container.svg',
    ),
    NavItem(
      title: 'Profile',
      tag: 'Authenticated',
      path: '/templates',
      icon: 'Grid3X3',
      iconPath: 'assets/icons/profile.svg',
      visible: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'NAVIGATION MENUS';
      ref.read(pageSubtitleProvider.notifier).state = '';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  void _showAddMenuItemDialog() async {
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Menu Item',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const MenuItemDialog(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );

    if (result != null && mounted) {
      final confirmed = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Confirm',
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
          title: 'Confirm Add',
          message: 'Are you sure you want to add this menu item to your platform navigation?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _items.add(
            NavItem(
              title: result['title']!,
              tag: result['tag']!,
              path: result['path']!,
              icon: result['icon']!,
              iconPath: 'assets/icons/container.svg', // Default fallback
            ),
          );
        });
        AppNotification.show(
          context,
          title: 'Item Added',
          message: 'Menu item "${result['title']}" has been created.',
        );
      }
    }
  }

  void _showEditMenuItemDialog(int index) async {
    final item = _items[index];
    final result = await showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Menu Item',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => MenuItemDialog(
        initialData: {
          'title': item.title,
          'path': item.path,
          'tag': item.tag,
          'icon': item.icon,
        },
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
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
          message: 'Are you sure you want to save the changes for this menu item?',
        ),
        transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          _items[index] = NavItem(
            title: result['title']!,
            tag: result['tag']!,
            path: result['path']!,
            icon: result['icon']!,
            iconPath: item.iconPath, // Keep original icon path for now
            visible: item.visible,
          );
        });
        AppNotification.show(
          context,
          title: 'Item Updated',
          message: 'Menu item "${result['title']}" has been updated.',
        );
      }
    }
  }

  void _deleteItem(int index) async {
    final item = _items[index];
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Delete',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Delete Item',
        message: 'Are you sure you want to permanently delete "${item.title}"? This action cannot be undone.',
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
        _items.removeAt(index);
      });
      AppNotification.show(
        context,
        title: 'Item Deleted',
        message: 'Menu item "${item.title}" has been removed.',
        type: NotificationType.error,
      );
    }
  }

  void _toggleVisibility(int index) {
    setState(() {
      _items[index].visible = !_items[index].visible;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final NavItem item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 802;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderButton(
              label: 'Add Menu Item',
              iconPath: 'assets/icons/add.svg',
              onTap: _showAddMenuItemDialog,
              isPrimary: true,
              isFullWidth: isMobile,
            ),
            const SizedBox(height: 16),
            if (isMobile)
              Column(
                children: [
                  _SectionHeader(
                    title: 'Main Navigation',
                    child: _NavigationList(
                      items: _items,
                      onToggleVisibility: _toggleVisibility,
                      onEdit: _showEditMenuItemDialog,
                      onDelete: _deleteItem,
                      onReorder: _onReorder,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Navigation Preview',
                    child: _NavigationPreview(items: _items),
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Navigation Column
                  Expanded(
                    flex: 3,
                    child: _SectionHeader(
                      title: 'Main Navigation',
                        child: _NavigationList(
                          items: _items,
                          onToggleVisibility: _toggleVisibility,
                          onEdit: _showEditMenuItemDialog,
                          onDelete: _deleteItem,
                          onReorder: _onReorder,
                        ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Navigation Preview Column
                  Expanded(
                    flex: 2,
                    child: _SectionHeader(
                      title: 'Navigation Preview',
                      child: _NavigationPreview(items: _items),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required String label,
    required String iconPath,
    VoidCallback? onTap,
    bool isPrimary = false,
    bool isFullWidth = false,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        final content = AnimatedScale(
          scale: isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isPrimary ? AppTheme.primaryGradient : null,
              color: isPrimary ? null : Colors.white.withValues(alpha: isHovered ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: isHovered ? 0.2 : 0.1)),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: isHovered ? 0.5 : 0.3),
                        blurRadius: isHovered ? 16 : 12,
                        spreadRadius: isHovered ? 2 : 1,
                      ),
                    ]
                  : isHovered
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: onTap != null ? GestureDetector(onTap: onTap, child: content) : content,
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionHeader({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassDecoration(opacity: 0.05, borderOpacity: 0.1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _NavigationList extends StatelessWidget {
  final List<NavItem> items;
  final Function(int) onToggleVisibility;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final Function(int, int) onReorder;

  const _NavigationList({
    required this.items,
    required this.onToggleVisibility,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final item = items[index];
        return _NavItemCard(
          key: ValueKey(item.title),
          item: item,
          index: index,
          onToggleVisibility: () => onToggleVisibility(index),
          onEdit: () => onEdit(index),
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}

class _NavItemCard extends StatefulWidget {
  final NavItem item;
  final int index;
  final VoidCallback onToggleVisibility;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NavItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onToggleVisibility,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_NavItemCard> createState() => _NavItemCardState();
}

class _NavItemCardState extends State<_NavItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.05),
            ),
          ),
          child: Row(
            children: [
              // Drag Handle
              MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: ReorderableDragStartListener(
                  index: widget.index,
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.item.tag,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.item.path} • Icon: ${widget.item.icon}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    iconPath: widget.item.visible ? 'assets/icons/eye.svg' : 'assets/icons/eye close.svg',
                    onTap: widget.onToggleVisibility,
                    color: widget.item.visible ? null : const Color(0xFFFF5252),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    iconPath: 'assets/icons/edit.svg',
                    onTap: widget.onEdit,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    iconPath: 'assets/icons/delete.svg',
                    isDestructive: true,
                    onTap: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback? onTap;
  final Color? color;
  final bool isDestructive;
  const _ActionButton({required this.iconPath, this.onTap, this.color, this.isDestructive = false});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDestructive ? Colors.redAccent : (widget.color ?? Colors.white);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovered ? baseColor.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: baseColor.withValues(alpha: _isHovered ? 0.15 : 0.0),
                width: 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: SvgPicture.asset(
              widget.iconPath,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                baseColor.withValues(alpha: _isHovered ? 1.0 : 0.6),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationPreview extends StatelessWidget {
  final List<NavItem> items;
  const _NavigationPreview({required this.items});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.where((item) => item.visible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'StartFront',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Text(
                'Platform Navigation',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              if (visibleItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No items visible',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                ...visibleItems.map((item) => _PreviewItem(label: item.title, isChecked: true)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'This shows how the navigation will appear to users.\n• White eye = visible, Red eye = hidden\n• Click eye icon to toggle visibility\n• Drag handle to reorder items',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _PreviewItem extends StatelessWidget {
  final String label;
  final bool isChecked;

  const _PreviewItem({required this.label, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isChecked ? Colors.white : Colors.transparent,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: isChecked ? 0.9 : 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
