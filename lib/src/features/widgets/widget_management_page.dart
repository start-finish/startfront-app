import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import '../../core/components/skeleton_loader.dart';
import '../../core/components/pagination_bar.dart';
import '../../core/services/base_service.dart';
import 'components/new_widget_dialog.dart';

class WidgetManagementPage extends ConsumerStatefulWidget {
  const WidgetManagementPage({super.key});

  @override
  ConsumerState<WidgetManagementPage> createState() => _WidgetManagementPageState();
}

class _WidgetManagementPageState extends ConsumerState<WidgetManagementPage> {
  final List<_WidgetData> _widgets = [];
  bool _isLoading = true;
  int _totalWidgets = 0;
  int _controlWidgets = 0;
  int _inputWidgets = 0;
  int _layoutWidgets = 0;
  int _displayWidgets = 0;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalPages = 1;

  Future<void> _fetchWidgets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final baseService = ref.read(baseServiceProvider);
      final response = await baseService.listWidgetsFull(
        page: _currentPage,
        limit: _pageSize,
      );
      
      if (mounted) {
        final data = response['data'] as Map<String, dynamic>? ?? {};
        final meta = response['meta'] as Map<String, dynamic>? ?? {};
        final counts = data['counts'] ?? {};
        final items = data['widgets'] as List<dynamic>? ?? [];

        setState(() {
          _widgets.clear();
          _widgets.addAll(items.map((item) => _WidgetData.fromJson(item as Map<String, dynamic>)));
          _totalWidgets = (meta['total'] as num?)?.toInt() ?? (counts['total'] as num?)?.toInt() ?? _widgets.length;
          _totalPages = (meta['totalPages'] as num?)?.toInt() ?? 1;
          _controlWidgets = (counts['control'] as num?)?.toInt() ?? 0;
          _inputWidgets = (counts['input'] as num?)?.toInt() ?? 0;
          _layoutWidgets = (counts['layout'] as num?)?.toInt() ?? 0;
          _displayWidgets = (counts['display'] as num?)?.toInt() ?? 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppNotification.show(
          context,
          title: 'Error Fetching Widgets',
          message: e.toString(),
          type: NotificationType.error,
        );
      }
    }
  }


  void _showCreateWidgetDialog() async {
    final result = await showGeneralDialog<Map<String, dynamic>>(
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
        try {
          final baseService = ref.read(baseServiceProvider);
          final rawName = result['name']!;
          final key = rawName
              .toLowerCase()
              .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
              .replaceAll(RegExp(r'_+'), '_');

          final configSchema = {
            'description': result['description'] ?? '',
            'properties': result['properties'] ?? [],
            'functions': result['functions'] ?? [],
            'renderCode': result['renderCode'] ?? '',
            'properties_count': (result['properties'] as List).length,
            'functions_count': (result['functions'] as List).length,
          };

          await baseService.createWidget(
            key: key,
            label: rawName,
            category: result['category']!.toLowerCase(),
            isBuiltin: false,
            version: '1.0.0',
            iconType: 'svg',
            iconValue: 'widget management.svg',
            configSchema: configSchema,
          );

          await _fetchWidgets();

          if (mounted) {
            AppNotification.show(
              context,
              title: 'Widget Created',
              message: 'New component "$rawName" is now available.',
            );
          }
        } catch (e) {
          if (mounted) {
            AppNotification.show(
              context,
              title: 'Creation Failed',
              message: e.toString(),
              type: NotificationType.error,
            );
          }
        }
      }
    }
  }

  void _showEditWidgetDialog(int index) async {
    final widget = _widgets[index];
    final result = await showGeneralDialog<Map<String, dynamic>>(
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
          'properties': widget.propertiesList,
          'functions': widget.functionsList,
          'renderCode': widget.renderCode,
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
        try {
          final baseService = ref.read(baseServiceProvider);
          final rawName = result['name']!;
          final key = rawName
              .toLowerCase()
              .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
              .replaceAll(RegExp(r'_+'), '_');

          final configSchema = {
            'description': result['description'] ?? '',
            'properties': result['properties'] ?? [],
            'functions': result['functions'] ?? [],
            'renderCode': result['renderCode'] ?? '',
            'properties_count': (result['properties'] as List).length,
            'functions_count': (result['functions'] as List).length,
          };

          await baseService.updateWidget(
            id: widget.id!,
            key: key,
            label: rawName,
            category: result['category']!.toLowerCase(),
            configSchema: configSchema,
          );

          await _fetchWidgets();

          if (mounted) {
            AppNotification.show(
              context,
              title: 'Widget Updated',
              message: 'Configuration for "$rawName" has been saved.',
            );
          }
        } catch (e) {
          if (mounted) {
            AppNotification.show(
              context,
              title: 'Update Failed',
              message: e.toString(),
              type: NotificationType.error,
            );
          }
        }
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
      try {
        final baseService = ref.read(baseServiceProvider);
        await baseService.deleteWidget(widget.id!);
        
        await _fetchWidgets();

        if (mounted) {
          AppNotification.show(
            context,
            title: 'Widget Deleted',
            message: 'Component "${widget.name}" has been removed.',
            type: NotificationType.error,
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotification.show(
            context,
            title: 'Delete Failed',
            message: e.toString(),
            type: NotificationType.error,
          );
        }
      }
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
      try {
        final baseService = ref.read(baseServiceProvider);
        final duplicateName = '${widget.name} Copy';
        final duplicateKey = '${widget.key}_copy';
        
        final configSchema = {
          'description': widget.description,
          'properties': widget.propertiesList,
          'functions': widget.functionsList,
          'renderCode': widget.renderCode,
          'properties_count': widget.properties,
          'functions_count': widget.functions,
        };

        await baseService.createWidget(
          key: duplicateKey,
          label: duplicateName,
          category: widget.category.toLowerCase(),
          isBuiltin: false,
          version: '1.0.0',
          iconType: 'svg',
          iconValue: 'widget management.svg',
          configSchema: configSchema,
        );

        await _fetchWidgets();

        if (mounted) {
          AppNotification.show(
            context,
            title: 'Widget Duplicated',
            message: '"${widget.name}" has been cloned successfully.',
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotification.show(
            context,
            title: 'Duplicate Failed',
            message: e.toString(),
            type: NotificationType.error,
          );
        }
      }
    }
  }

  void _showCodeDialog(int index) {
    final widget = _widgets[index];
    final String widgetCode = widget.renderCode.trim().isNotEmpty
        ? widget.renderCode
        : '''import 'package:flutter/material.dart';

/// ${widget.name} - Custom App Component
///
/// Category: ${widget.category}
/// Description: ${widget.description}
class ${widget.name} extends StatelessWidget {
  const ${widget.name}({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
      ),
      child: const Text(
        '${widget.name} Component',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
''';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Code Preview',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 600,
              height: 500,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.name.toUpperCase()} CODE PREVIEW',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          widgetCode,
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPropertiesDialog(int index) {
    final widget = _widgets[index];
    
    final Map<String, dynamic> schemaMap = {
      "widget": widget.name,
      "key": widget.key,
      "category": widget.category.toLowerCase(),
      "description": widget.description,
      "properties": widget.propertiesList,
      "functions": widget.functionsList,
      "renderCode": widget.renderCode,
      "metadata": {
        "version": "1.0.0",
        "builtin": widget.status == 'Built-in',
        "updatedAt": widget.updatedAt
      }
    };

    final String schemaJson = const JsonEncoder.withIndent('  ').convert(schemaMap);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Schema Preview',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 500,
              height: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.name.toUpperCase()} CONFIG SCHEMA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          schemaJson,
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'WIDGET MANAGEMENT';
      ref.read(pageSubtitleProvider.notifier).state = 'Configure and manage your application widgets';
      ref.read(headerActionsProvider.notifier).state = [];
      _fetchWidgets();
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
              _buildStatCard(
                _isLoading ? null : '$_totalWidgets', 
                'Total Widgets', 
                isActive: true,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                _isLoading ? null : '$_controlWidgets', 
                'Control Widgets',
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                _isLoading ? null : '$_inputWidgets', 
                'Input Widgets',
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                _isLoading ? null : '$_displayWidgets', 
                'Display Widgets',
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                _isLoading ? null : '$_layoutWidgets', 
                'Layout Widgets',
              ),
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
                _isLoading
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => const _WidgetSkeletonItem(),
                      )
                    : _widgets.isEmpty
                        ? Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.widgets_outlined, color: Colors.white.withValues(alpha: 0.2), size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  'No widgets configured yet.',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _widgets.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _WidgetListItem(
                                    data: _widgets[index],
                                    onToggle: () {},
                                    onEdit: () => _showEditWidgetDialog(index),
                                    onDelete: () => _deleteWidget(index),
                                    onDuplicate: () => _duplicateWidget(index),
                                    onViewCode: () => _showCodeDialog(index),
                                    onViewProperties: () => _showPropertiesDialog(index),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              PaginationBar(
                                currentPage: _currentPage,
                                totalPages: _totalPages,
                                totalItems: _totalWidgets,
                                pageSize: _pageSize,
                                onPageChanged: (page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                  _fetchWidgets();
                                },
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String? value, String label, {bool isActive = false}) {
    return _StatCard(value: value, label: label, isActive: isActive);
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

class _WidgetSkeletonItem extends StatelessWidget {
  const _WidgetSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Row(
        children: [
          SkeletonLoader(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(8))),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 140, height: 16),
                SizedBox(height: 6),
                SkeletonLoader(width: 280, height: 12),
                SizedBox(height: 12),
                Row(
                  children: [
                    SkeletonLoader(width: 60, height: 18, borderRadius: BorderRadius.all(Radius.circular(4))),
                    SizedBox(width: 12),
                    SkeletonLoader(width: 80, height: 12),
                    SizedBox(width: 12),
                    SkeletonLoader(width: 80, height: 12),
                    SizedBox(width: 12),
                    SkeletonLoader(width: 110, height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetData {
  final int? id;
  final String key;
  final String name;
  final String category;
  final String description;
  final List<dynamic> propertiesList;
  final List<dynamic> functionsList;
  final String renderCode;
  final int properties;
  final int functions;
  final String updatedAt;
  String status;

  _WidgetData({
    this.id,
    required this.key,
    required this.name,
    required this.category,
    required this.description,
    required this.propertiesList,
    required this.functionsList,
    required this.renderCode,
    required this.properties,
    required this.functions,
    required this.updatedAt,
    required this.status,
  });

  static _WidgetData fromJson(Map<String, dynamic> json) {
    final configSchema = json['config_schema'] ?? {};
    final String description = configSchema['description'] ?? 'A custom widget component.';
    final List<dynamic> propertiesList = configSchema['properties'] as List<dynamic>? ?? [];
    final List<dynamic> functionsList = configSchema['functions'] as List<dynamic>? ?? [];
    final String renderCode = configSchema['renderCode'] ?? '';

    String formattedDate = 'Recent';
    if (json['updated_at'] != null) {
      try {
        final parsed = DateTime.parse(json['updated_at']);
        formattedDate = '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return _WidgetData(
      id: json['id'],
      key: json['key'] ?? '',
      name: json['label'] ?? '',
      category: json['category'] ?? '',
      description: description,
      propertiesList: propertiesList,
      functionsList: functionsList,
      renderCode: renderCode,
      properties: propertiesList.length,
      functions: functionsList.length,
      updatedAt: formattedDate,
      status: json['is_builtin'] == true ? 'Built-in' : 'Custom',
    );
  }
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
    final displayLabel = label.isEmpty 
        ? '' 
        : '${label[0].toUpperCase()}${label.substring(1).toLowerCase()}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayLabel,
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

class _StatCard extends StatefulWidget {
  final String? value;
  final String label;
  final bool isActive;

  const _StatCard({
    required this.value,
    required this.label,
    this.isActive = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showGlow = widget.isActive || _isHovered;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showGlow ? Colors.white.withValues(alpha: widget.isActive ? 0.8 : 0.4) : Colors.white.withValues(alpha: 0.05),
                width: widget.isActive ? 1.5 : (showGlow ? 1.2 : 1.0),
              ),
              boxShadow: showGlow
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: widget.isActive ? 0.05 : 0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.value == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: SkeletonLoader(width: 50, height: 28),
                      )
                    : Text(
                        widget.value!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
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
