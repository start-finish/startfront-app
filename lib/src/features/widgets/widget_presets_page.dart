import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import '../../core/components/pagination_bar.dart';

class WidgetPresetsPage extends ConsumerStatefulWidget {
  const WidgetPresetsPage({super.key});

  @override
  ConsumerState<WidgetPresetsPage> createState() => _WidgetPresetsPageState();
}

class _WidgetPresetsPageState extends ConsumerState<WidgetPresetsPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  final int _pageSize = 10;

  final List<_PresetData> _presets = [
    _PresetData(
      name: 'Login Form',
      description: 'Email and password form with submit button',
      category: 'Forms',
      widgets: ['TextField', 'TextField', 'ElevatedButton'],
      usageCount: 8,
      lastUsed: '2 days ago',
    ),
    _PresetData(
      name: 'Hero Section',
      description: 'Large title, subtitle, and CTA button',
      category: 'Layout',
      widgets: ['Text', 'Text', 'ElevatedButton', 'Image'],
      usageCount: 15,
      lastUsed: '1 week ago',
    ),
    _PresetData(
      name: 'Feature Card',
      description: 'Icon, title, description in a card layout',
      category: 'Content',
      widgets: ['Image', 'Text', 'Text'],
      usageCount: 22,
      lastUsed: '3 days ago',
    ),
    _PresetData(
      name: 'Navigation Bar',
      description: 'Logo and menu items in a horizontal layout',
      category: 'Navigation',
      widgets: ['Row', 'Image', 'Text', 'Text', 'Text'],
      usageCount: 12,
      lastUsed: '5 days ago',
    ),
    _PresetData(
      name: 'Registration Grid',
      description: 'Sign up layout with multiple input boxes',
      category: 'Forms',
      widgets: ['Column', 'TextField', 'TextField', 'TextField', 'Checkbox', 'ElevatedButton'],
      usageCount: 7,
      lastUsed: '10 mins ago',
    ),
    _PresetData(
      name: 'Pricing Card',
      description: 'Feature listing with bold price tag and CTA',
      category: 'Content',
      widgets: ['Card', 'Text', 'Text', 'Divider', 'ListView', 'ElevatedButton'],
      usageCount: 19,
      lastUsed: '1 day ago',
    ),
    _PresetData(
      name: 'Profile Header',
      description: 'User avatar, bio details, and follow button',
      category: 'Layout',
      widgets: ['Stack', 'CircleAvatar', 'Text', 'Text', 'ElevatedButton'],
      usageCount: 31,
      lastUsed: '4 hours ago',
    ),
    _PresetData(
      name: 'Comment Thread',
      description: 'Indented replies list with avatar and actions',
      category: 'Content',
      widgets: ['ListView', 'ListTile', 'Row', 'IconButton'],
      usageCount: 14,
      lastUsed: 'Yesterday',
    ),
    _PresetData(
      name: 'Product Details',
      description: 'Product image, title, price, description and Add to Cart button',
      category: 'Content',
      widgets: ['Column', 'Image', 'Text', 'Text', 'RatingBar', 'ElevatedButton'],
      usageCount: 25,
      lastUsed: '3 days ago',
    ),
    _PresetData(
      name: 'Checkout Form',
      description: 'Payment and shipping forms with summaries',
      category: 'Forms',
      widgets: ['Column', 'ExpansionTile', 'TextField', 'Dropdown', 'ElevatedButton'],
      usageCount: 9,
      lastUsed: '2 days ago',
    ),
    _PresetData(
      name: 'Stats Dashboard',
      description: 'Interactive analytics metrics card row',
      category: 'Layout',
      widgets: ['Row', 'Card', 'Text', 'Icon', 'Card', 'Text', 'Icon'],
      usageCount: 18,
      lastUsed: '1 week ago',
    ),
    _PresetData(
      name: 'Alert Banner Stack',
      description: 'Warning and error toast messages stack',
      category: 'Navigation',
      widgets: ['Stack', 'SnackBar', 'SnackBar', 'SnackBar'],
      usageCount: 11,
      lastUsed: '5 days ago',
    ),
    _PresetData(
      name: 'Contact Us Form',
      description: 'Beautiful contact form with subject and message',
      category: 'Forms',
      widgets: ['TextField', 'TextField', 'TextField', 'ElevatedButton'],
      usageCount: 5,
      lastUsed: '3 weeks ago',
    ),
    _PresetData(
      name: 'Testimonials Slider',
      description: 'Customer quotes slider with author avatars',
      category: 'Content',
      widgets: ['PageView', 'Card', 'Text', 'CircleAvatar', 'Text'],
      usageCount: 13,
      lastUsed: '2 days ago',
    ),
    _PresetData(
      name: 'Search Bar Header',
      description: 'Premium search bar with voice search icon',
      category: 'Navigation',
      widgets: ['Row', 'TextField', 'IconButton'],
      usageCount: 27,
      lastUsed: '3 hours ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'WIDGET PRESETS';
      ref.read(pageSubtitleProvider.notifier).state = 'Ready-to-use component combinations for your app';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_PresetData> get _filteredPresets {
    return _presets.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.widgets.any((w) => w.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<_PresetData> get _paginatedPresets {
    final filtered = _filteredPresets;
    final startIndex = (_currentPage - 1) * _pageSize;
    if (startIndex >= filtered.length) {
      return [];
    }
    final endIndex = startIndex + _pageSize;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  void _duplicatePreset(_PresetData preset) async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Duplicate',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Duplicate Preset',
        message: 'Do you want to create a copy of the "${preset.name}" preset?',
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _presets.add(
          _PresetData(
            name: '${preset.name} Copy',
            description: preset.description,
            category: preset.category,
            widgets: List.from(preset.widgets),
            usageCount: 0,
            lastUsed: 'Just now',
          ),
        );
        _currentPage = 1;
      });
      AppNotification.show(
        context,
        title: 'Preset Duplicated',
        message: '"${preset.name}" has been cloned successfully.',
      );
    }
  }

  void _deletePreset(_PresetData preset) async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Delete',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Delete Preset',
        message: 'Are you sure you want to permanently delete "${preset.name}"?',
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
        _presets.remove(preset);
        _currentPage = 1;
      });
      AppNotification.show(
        context,
        title: 'Preset Deleted',
        message: 'Preset "${preset.name}" has been removed.',
        type: NotificationType.error,
      );
    }
  }

  void _usePreset(_PresetData preset) async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Confirm Usage',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => ConfirmDialog(
        title: 'Use Preset',
        message: 'Do you want to apply the "${preset.name}" configuration to your active editor?',
        confirmLabel: 'Apply Preset',
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      AppNotification.show(
        context,
        title: 'Preset Applied',
        message: 'Configuration for "${preset.name}" has been loaded.',
      );
    }
  }

  void _viewCode(_PresetData preset) {
    AppNotification.show(
      context,
      title: 'Preset Code',
      message: 'Generating bundle code for "${preset.name}"...',
      type: NotificationType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedPresets = _paginatedPresets;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 802;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Section
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 1200 ? 4 : 2;
              final aspectRatio = constraints.maxWidth > 1200
                  ? (constraints.maxWidth / 4) / 110
                  : (constraints.maxWidth / 2) / 100;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: count,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: aspectRatio,
                children: [
                  _buildStatCard('${_presets.length}', 'Total Presets', isActive: true),
                  _buildStatCard('${_presets.fold<int>(0, (sum, p) => sum + p.usageCount)}', 'Total Usage'),
                  _buildStatCard('${_presets.where((p) => p.category == 'Forms').length}', 'Form Presets'),
                  _buildStatCard('${_presets.where((p) => p.category == 'Layout').length}', 'Layout Presets'),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Search and Filter Bar
          _buildFilterAndSearchBar(isMobile),
          const SizedBox(height: 32),

          // Presets Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200 ? 2 : 1;

              if (paginatedPresets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.white.withValues(alpha: 0.2)),
                        const SizedBox(height: 16),
                        Text(
                          'No presets found matching your criteria',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: isMobile ? 280 : 260,
                    ),
                    itemCount: paginatedPresets.length,
                    itemBuilder: (context, index) {
                      final preset = paginatedPresets[index];
                      return _PresetCard(
                        preset: preset,
                        onDuplicate: () => _duplicatePreset(preset),
                        onDelete: () => _deletePreset(preset),
                        onUse: () => _usePreset(preset),
                        onViewCode: () => _viewCode(preset),
                        onEdit: () {
                          AppNotification.show(
                            context,
                            title: 'Edit Mode',
                            message: 'Opening preset editor for "${preset.name}"...',
                            type: NotificationType.info,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  PaginationBar(
                    currentPage: _currentPage,
                    totalPages: (_filteredPresets.length / _pageSize).ceil(),
                    totalItems: _filteredPresets.length,
                    pageSize: _pageSize,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSearchBar(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Filter:',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...['All', 'Forms', 'Layout', 'Content', 'Navigation'].map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _CategoryChip(
                      label: cat,
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() {
                        _selectedCategory = cat;
                        _currentPage = 1;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            width: isMobile ? double.infinity : 300,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.white.withValues(alpha: 0.4), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {
                      _searchQuery = val;
                      _currentPage = 1;
                    }),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                       hintText: 'Search presets...',
                       hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                       border: InputBorder.none,
                       isCollapsed: true,
                       contentPadding: const EdgeInsets.symmetric(vertical: 12),
                       suffixIcon: _searchQuery.isNotEmpty ? _buildClearButton() : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              _searchController.clear();
              this.setState(() {
                _searchQuery = '';
                _currentPage = 1;
              });
            },
            child: AnimatedScale(
              scale: isHovered ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.close,
                size: 14,
                color: isHovered ? Colors.white : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
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
}

class _PresetData {
  final String name;
  final String description;
  final String category;
  final List<String> widgets;
  final int usageCount;
  final String lastUsed;

  _PresetData({
    required this.name,
    required this.description,
    required this.category,
    required this.widgets,
    required this.usageCount,
    required this.lastUsed,
  });
}

class _CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.white.withValues(alpha: 0.1)
                  : _isHovered
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected
                    ? Colors.white
                    : _isHovered
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.4),
                fontSize: 13,
                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetCard extends StatefulWidget {
  final _PresetData preset;
  final VoidCallback onDuplicate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUse;
  final VoidCallback onViewCode;

  const _PresetCard({
    required this.preset,
    required this.onDuplicate,
    required this.onEdit,
    required this.onDelete,
    required this.onUse,
    required this.onViewCode,
  });

  @override
  State<_PresetCard> createState() => _PresetCardState();
}

class _PresetCardState extends State<_PresetCard> {
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.05),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.preset.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.preset.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _ActionButton(
                        iconPath: 'assets/icons/copy.svg',
                        onTap: widget.onDuplicate,
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        iconPath: 'assets/icons/edit.svg',
                        onTap: widget.onEdit,
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        iconPath: 'assets/icons/delete.svg',
                        onTap: widget.onDelete,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCategoryBadge(widget.preset.category),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Widget:',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.preset.widgets.map((w) => _WidgetMiniChip(label: w)).toList(),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Used ${widget.preset.usageCount} times',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.preset.lastUsed,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _PresetActionButton(
                      label: 'View Code',
                      iconPath: 'assets/icons/editor.svg',
                      onTap: widget.onViewCode,
                      isSecondary: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PresetActionButton(
                      label: 'Use Preset',
                      onTap: widget.onUse,
                    ),
                  ),
                ],
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
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WidgetMiniChip extends StatelessWidget {
  final String label;

  const _WidgetMiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 10,
        ),
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
            width: 32,
            height: 32,
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

class _PresetActionButton extends StatefulWidget {
  final String label;
  final String? iconPath;
  final VoidCallback onTap;
  final bool isSecondary;

  const _PresetActionButton({
    required this.label,
    this.iconPath,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  State<_PresetActionButton> createState() => _PresetActionButtonState();
}

class _PresetActionButtonState extends State<_PresetActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 40,
            decoration: BoxDecoration(
              gradient: !widget.isSecondary ? AppTheme.primaryGradient : null,
              color: widget.isSecondary ? Colors.white.withValues(alpha: _isHovered ? 0.1 : 0.05) : null,
              borderRadius: BorderRadius.circular(8),
              border: widget.isSecondary ? Border.all(color: Colors.white.withValues(alpha: 0.1)) : null,
              boxShadow: !widget.isSecondary && _isHovered
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.iconPath != null) ...[
                  SvgPicture.asset(
                    widget.iconPath!,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
