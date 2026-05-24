import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/theme.dart';
import '../../core/components/app_notification.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // Sidebar states
  String _activeBuildTab = 'widgets'; // 'widgets', 'layers', 'routing'
  String _activeConnectTab = ''; // '', 'api', 'assets', 'responsive', 'logic', 'settings'

  // Emulation canvas states
  String _zoomLevel = '100%';
  String _selectedDevice = 'phone'; // 'phone', 'tablet', 'desktop'
  bool _isPortrait = true;

  // Screen Property Editor states
  final TextEditingController _routeController = TextEditingController(text: '/home');
  bool _requiresAuth = false;
  String _scaffoldName = 'HomePage';
  final TextEditingController _scaffoldController = TextEditingController(text: 'HomePage');
  Color _canvasBgColor = Colors.white;
  String _canvasBgHex = '#FFFFFF';

  bool _safeArea = true;
  bool _hideKeyboard = false;
  bool _excludeDismiss = false;
  bool _disableResize = true;
  bool _isDraggingOver = false;
  bool _dropProcessed = false;

  // Active interactive widgets in canvas
  final List<_WidgetNode> _canvasWidgets = [];
  String? _selectedWidgetId;

  // Custom properties per widget ID
  final Map<String, Map<String, dynamic>> _widgetProperties = {};

  // Undo/Redo stack history
  final List<_CanvasState> _history = [];
  int _historyIndex = -1;

  @override
  void initState() {
    super.initState();
    _saveToHistory();
  }

  @override
  void dispose() {
    _routeController.dispose();
    _scaffoldController.dispose();
    super.dispose();
  }

  void _saveToHistory() {
    // Trim history forward of current index if any edits occurred after undo
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(_CanvasState(_canvasWidgets, _widgetProperties));
    _historyIndex = _history.length - 1;
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _canvasWidgets.clear();
        _canvasWidgets.addAll(_history[_historyIndex].widgets.map((n) => n.clone()));
        _widgetProperties.clear();
        _widgetProperties.addAll(
          _history[_historyIndex].properties.map((key, value) => MapEntry(key, Map.from(value))),
        );
        _selectedWidgetId = null; // Reset selection on undo
      });
      AppNotification.show(context, title: 'Undo', message: 'Reverted last action.', type: NotificationType.info);
    }
  }

  void _redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _canvasWidgets.clear();
        _canvasWidgets.addAll(_history[_historyIndex].widgets.map((n) => n.clone()));
        _widgetProperties.clear();
        _widgetProperties.addAll(
          _history[_historyIndex].properties.map((key, value) => MapEntry(key, Map.from(value))),
        );
        _selectedWidgetId = null; // Reset selection on redo
      });
      AppNotification.show(context, title: 'Redo', message: 'Applied next action.', type: NotificationType.info);
    }
  }

  void _addWidget(String type) {
    final newId = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      _canvasWidgets.add(_WidgetNode(id: newId, type: type));
      _selectedWidgetId = newId; // Auto-select dropped widget!
      _saveToHistory();
    });
    AppNotification.show(
      context,
      title: 'Widget Added',
      message: 'Placed $type element into the simulated canvas.',
      type: NotificationType.success,
    );
  }

  void _clearCanvas() {
    if (_canvasWidgets.isEmpty) return;
    setState(() {
      _canvasWidgets.clear();
      _widgetProperties.clear();
      _selectedWidgetId = null;
      _saveToHistory();
    });
    AppNotification.show(
      context,
      title: 'Canvas Cleared',
      message: 'All interactive custom widgets removed.',
      type: NotificationType.info,
    );
  }

  _WidgetNode? _findNode(List<_WidgetNode> nodes, String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
      final found = _findNode(node.children, id);
      if (found != null) return found;
    }
    return null;
  }

  bool _removeNode(List<_WidgetNode> nodes, String id) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == id) {
        nodes.removeAt(i);
        return true;
      }
      if (_removeNode(nodes[i].children, id)) {
        return true;
      }
    }
    return false;
  }

  bool _isDescendantOf(_WidgetNode parent, String childId) {
    for (final child in parent.children) {
      if (child.id == childId) return true;
      if (_isDescendantOf(child, childId)) return true;
    }
    return false;
  }

  bool _isNodeDescendantOfAncestor(String ancestorId, String targetId) {
    final ancestorNode = _findNode(_canvasWidgets, ancestorId);
    if (ancestorNode == null) return false;
    return _isDescendantOf(ancestorNode, targetId);
  }

  void _handleDropIntoNode(String dataStr, _WidgetNode targetParentNode) {
    setState(() {
      if (dataStr.startsWith('EXISTING:')) {
        final dragId = dataStr.replaceFirst('EXISTING:', '');
        // Find existing node in tree
        final nodeToMove = _findNode(_canvasWidgets, dragId);
        if (nodeToMove != null && dragId != targetParentNode.id) {
          // Remove from old parent
          _removeNode(_canvasWidgets, dragId);
          // Add to new parent children
          targetParentNode.children.add(nodeToMove);
          _selectedWidgetId = dragId;
        }
      } else {
        // Dragged from palette (new widget)
        final newId = DateTime.now().microsecondsSinceEpoch.toString();
        final newNode = _WidgetNode(id: newId, type: dataStr);
        targetParentNode.children.add(newNode);
        _selectedWidgetId = newId;
      }
      _saveToHistory();
    });
    AppNotification.show(
      context,
      title: 'Layout Updated',
      message: 'Placed component inside container.',
      type: NotificationType.success,
    );
  }

  void _removeWidgetNode(String id) {
    setState(() {
      _removeNode(_canvasWidgets, id);
      _widgetProperties.remove(id); // Clean up properties mapping
      if (_selectedWidgetId == id) {
        _selectedWidgetId = null;
      }
      _saveToHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          // Background Aesthetic Ambient Blobs (GPU efficient, non-overlapping)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF003B5C).withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: 150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1E38).withValues(alpha: 0.12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Layout Wrapper
          Row(
            children: [
              // 1. Left Editor Sidebar
              _buildLeftSidebar(),

              // 2. Component Palette / Layer Tree Sidebar
              _buildPaletteSidebar(),

              // 3. Center Emulation Workspace
              Expanded(
                child: Column(
                  children: [
                    // Canvas Top Header Controls
                    _buildCanvasHeader(),

                    // Emulation Canvas Area
                    Expanded(
                      child: _buildCanvasArea(),
                    ),
                  ],
                ),
              ),

              // 4. Right Property Configuration Panel
              _buildPropertiesPanel(),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR COMPONENT =================
  Widget _buildLeftSidebar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Blur Layer (Strictly clipped to sidebar bounds)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          // Content Layer (Clip.none to allow labels to float outside)
          Column(
            children: [
              const SizedBox(height: 32),
              // LOGO
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    context.go('/platform');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Text(
                      'LOGO',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Build section label
              _buildSidebarSectionLabel('Build'),
              const SizedBox(height: 8),

              _buildSidebarItem(
                iconPath: 'assets/icons/widget palatte.svg',
                label: 'Widgets',
                isActive: _activeBuildTab == 'widgets',
                onTap: () => setState(() {
                  _activeBuildTab = 'widgets';
                  _activeConnectTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/page.svg',
                label: 'Layers',
                isActive: _activeBuildTab == 'layers',
                onTap: () => setState(() {
                  _activeBuildTab = 'layers';
                  _activeConnectTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/tree.svg',
                label: 'Routing',
                isActive: _activeBuildTab == 'routing',
                onTap: () => setState(() {
                  _activeBuildTab = 'routing';
                  _activeConnectTab = '';
                }),
              ),

              const SizedBox(height: 24),

              // Connect section label
              _buildSidebarSectionLabel('Connect'),
              const SizedBox(height: 8),

              _buildSidebarItem(
                iconPath: 'assets/icons/api.svg',
                label: 'APIs',
                isActive: _activeConnectTab == 'api',
                onTap: () => setState(() {
                  _activeConnectTab = 'api';
                  _activeBuildTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/media.svg',
                label: 'Assets',
                isActive: _activeConnectTab == 'assets',
                onTap: () => setState(() {
                  _activeConnectTab = 'assets';
                  _activeBuildTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/monitor.svg',
                label: 'Device',
                isActive: _activeConnectTab == 'responsive',
                onTap: () => setState(() {
                  _activeConnectTab = 'responsive';
                  _activeBuildTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/config.svg',
                label: 'Logic',
                isActive: _activeConnectTab == 'logic',
                onTap: () => setState(() {
                  _activeConnectTab = 'logic';
                  _activeBuildTab = '';
                }),
              ),
              _buildSidebarItem(
                iconPath: 'assets/icons/settings.svg',
                label: 'Config',
                isActive: _activeConnectTab == 'settings',
                onTap: () => setState(() {
                  _activeConnectTab = 'settings';
                  _activeBuildTab = '';
                }),
              ),

              const Spacer(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Colors.white.withValues(alpha: 0.3),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSidebarItem({
    required String iconPath,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Active/Hover vertical slider bar indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    left: isActive || isHovered ? -12 : -16,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isActive || isHovered ? 1.0 : 0.0,
                      child: Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Button container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.blackGlassColor
                          : isHovered
                          ? AppTheme.blackGlassColor.withValues(alpha: 0.6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? Colors.white.withValues(alpha: 0.2)
                            : isHovered
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      boxShadow: isActive || isHovered
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: AnimatedRotation(
                      turns: isHovered ? 0.01 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      alignment: Alignment.center,
                      child: AnimatedScale(
                        scale: isHovered ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(0, isHovered ? -1 : 0, 0),
                          child: TweenAnimationBuilder<Color?>(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            tween: ColorTween(
                              begin: Colors.white.withValues(alpha: 0.4),
                              end: isActive
                                  ? Colors.white
                                  : isHovered
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                            builder: (context, color, _) {
                              return SvgPicture.asset(
                                iconPath,
                                width: 36,
                                height: 36,
                                colorFilter: ColorFilter.mode(
                                  color ?? Colors.white,
                                  BlendMode.srcIn,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Premium Floating Hint Label (floating tooltip on hover)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    left: isHovered ? 68 : 50,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isHovered ? 1.0 : 0.0,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
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

  // ================= SECONDARY PALETTE BAR =================
  Widget _buildPaletteSidebar() {
    String title = 'COMPONENTS';
    Widget content = const SizedBox();

    if (_activeBuildTab == 'widgets') {
      title = 'Widgets Palette';
      content = _buildWidgetsPalette();
    } else if (_activeBuildTab == 'layers') {
      title = 'Screen Layers';
      content = _buildLayersTree();
    } else if (_activeBuildTab == 'routing') {
      title = 'Route Mapping';
      content = _buildRoutingMap();
    } else if (_activeConnectTab == 'api') {
      title = 'API Connectors';
      content = _buildPlaceholderList(
        'Database Connectors',
        'Connect your screen properties directly to backend services.',
      );
    } else if (_activeConnectTab == 'assets') {
      title = 'Asset Library';
      content = _buildPlaceholderList('Assets Library', 'Manage SVG, PNG, and interactive vectors for canvas layouts.');
    } else if (_activeConnectTab == 'responsive') {
      title = 'Device Specs';
      content = _buildPlaceholderList('Responsive Grid', 'Set responsive break-points for fluid desktop transitions.');
    } else if (_activeConnectTab == 'logic') {
      title = 'Custom Logic';
      content = _buildPlaceholderList('Custom Handlers', 'Bind micro-scripts and click behaviors to components.');
    } else if (_activeConnectTab == 'settings') {
      title = 'Build Settings';
      content = _buildPlaceholderList('Screen Attributes', 'Configure code-generation presets and metadata.');
    }

    return Container(
      width: 250,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar header title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  Icons.dashboard_customize_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildWidgetsPalette() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 16, color: Colors.white.withValues(alpha: 0.3)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Search Widget...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Category: Commonly Used
          _buildPaletteCategoryLabel('Commonly Used'),
          const SizedBox(height: 10),
          _buildPaletteGrid([
            _PaletteItemData(icon: 'assets/icons/text.svg', label: 'Text', type: 'Text'),
            _PaletteItemData(icon: 'assets/icons/column.svg', label: 'Column', type: 'Column'),
            _PaletteItemData(icon: 'assets/icons/row.svg', label: 'Row', type: 'Row'),
            _PaletteItemData(icon: 'assets/icons/container.svg', label: 'Container', type: 'Container'),
            _PaletteItemData(icon: 'assets/icons/media.svg', label: 'Image', type: 'Image'),
            _PaletteItemData(icon: 'assets/icons/button.svg', label: 'Button', type: 'Button'),
          ]),

          const SizedBox(height: 24),

          // Category: Layout elements
          _buildPaletteCategoryLabel('Layout'),
          const SizedBox(height: 10),
          _buildPaletteGrid([
            _PaletteItemData(icon: 'assets/icons/container.svg', label: 'Container', type: 'Container'),
            _PaletteItemData(icon: 'assets/icons/column.svg', label: 'Column', type: 'Column'),
            _PaletteItemData(icon: 'assets/icons/row.svg', label: 'Row', type: 'Row'),
            _PaletteItemData(icon: 'assets/icons/tree.svg', label: 'Stack', type: 'Stack'),
            _PaletteItemData(icon: 'assets/icons/card.svg', label: 'Card', type: 'Card'),
          ]),
        ],
      ),
    );
  }

  Widget _buildPaletteCategoryLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPaletteGrid(List<_PaletteItemData> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isHovered = false;
        return StatefulBuilder(
          builder: (context, setState) {
            final gridItem = AnimatedScale(
              scale: isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isHovered ? 0.06 : 0.02),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isHovered ? 0.15 : 0.05),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      item.icon,
                      width: 36,
                      height: 36,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withValues(alpha: isHovered ? 0.8 : 0.4),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: isHovered ? 0.9 : 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );

            return Draggable<String>(
              data: item.type,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.25),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item.icon,
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.4,
                child: gridItem,
              ),
              child: MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                cursor: SystemMouseCursors.grab,
                child: GestureDetector(
                  onTap: () => _addWidget(item.type),
                  child: gridItem,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLayersTree() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLayerNode(Icons.smartphone_rounded, 'MobileScaffold', isRoot: true),
        if (_canvasWidgets.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 12),
            child: Text(
              'No elements added yet.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11, fontStyle: FontStyle.italic),
            ),
          )
        else
          ..._canvasWidgets.map((node) => _buildLayersTreeForNode(node, 20.0)),
      ],
    );
  }

  Widget _buildLayersTreeForNode(_WidgetNode node, double indent) {
    final isSelected = _selectedWidgetId == node.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: indent),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _selectedWidgetId = node.id;
              });
            },
            child: _buildLayerNode(
              _getWidgetIcon(node.type),
              node.type,
              isSelected: isSelected,
            ),
          ),
        ),
        if (node.children.isNotEmpty) ...node.children.map((child) => _buildLayersTreeForNode(child, indent + 16.0)),
      ],
    );
  }

  Widget _buildLayerNode(IconData icon, String label, {bool isRoot = false, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? AppTheme.primaryColor
                : (isRoot ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.5)),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : (isRoot ? Colors.white : Colors.white.withValues(alpha: 0.8)),
              fontWeight: (isRoot || isSelected) ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutingMap() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRouteMapNode('/', 'DashboardPage (Published)'),
        _buildRouteMapNode('/login', 'LoginPage (Draft)'),
        _buildRouteMapNode('/editor', 'EditorPage (Active)'),
        _buildRouteMapNode('/profile', 'ProfilePage (Published)'),
        _buildRouteMapNode(_routeController.text, '$_scaffoldName (Active Builder)'),
      ],
    );
  }

  Widget _buildRouteMapNode(String route, String target) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route,
            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            target,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderList(String heading, String desc) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.link_rounded, size: 36, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 12),
          Text(
            heading,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }

  // ================= CANVAS HEADER =================
  Widget _buildCanvasHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Screen Title
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _scaffoldName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Route: ${_routeController.text}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          // Center: Device Emulation Selection
          Row(
            children: [
              _buildCanvasControlIconButton(
                iconPath: 'assets/icons/minus.svg',
                onTap: () {
                  setState(() {
                    if (_zoomLevel == '100%') {
                      _zoomLevel = '75%';
                    } else if (_zoomLevel == '125%') {
                      _zoomLevel = '100%';
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Text(
                  _zoomLevel,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              _buildCanvasControlIconButton(
                iconPath: 'assets/icons/add.svg',
                onTap: () {
                  setState(() {
                    if (_zoomLevel == '100%') {
                      _zoomLevel = '125%';
                    } else if (_zoomLevel == '75%') {
                      _zoomLevel = '100%';
                    }
                  });
                },
              ),

              const SizedBox(width: 24),
              VerticalDivider(color: Colors.white.withValues(alpha: 0.05), width: 1, indent: 20, endIndent: 20),
              const SizedBox(width: 24),

              // Device Selector Icons
              _buildDeviceSelectorButton('phone', Icons.smartphone_rounded),
              const SizedBox(width: 8),
              _buildDeviceSelectorButton('tablet', Icons.tablet_mac_rounded),
              const SizedBox(width: 8),
              _buildDeviceSelectorButton('desktop', Icons.desktop_mac_rounded),

              const SizedBox(width: 12),
              _buildCanvasControlIconButton(
                iconPath: 'assets/icons/reset.svg',
                onTap: () => setState(() => _isPortrait = !_isPortrait),
                label: 'Rotate orientation',
              ),
            ],
          ),

          // Right Actions: Undo, Redo, Run App
          Row(
            children: [
              _buildCanvasActionIcon(Icons.undo_rounded, _historyIndex > 0 ? _undo : null),
              const SizedBox(width: 6),
              _buildCanvasActionIcon(Icons.redo_rounded, _historyIndex < _history.length - 1 ? _redo : null),
              const SizedBox(width: 16),

              // Run App Button
              _buildRunAppButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelectorButton(String device, IconData icon) {
    final isSelected = _selectedDevice == device;
    return GestureDetector(
      onTap: () => setState(() => _selectedDevice = device),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildCanvasControlIconButton({required String iconPath, required VoidCallback onTap, String? label}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.6), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasActionIcon(IconData icon, VoidCallback? onTap) {
    final isEnabled = onTap != null;
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isEnabled ? Colors.white : Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildRunAppButton() {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              AppNotification.show(
                context,
                title: 'Code Generated',
                message: 'Successfully generated and compiled $_scaffoldName production bundle.',
                type: NotificationType.success,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isHovered
                    ? const LinearGradient(colors: [Color(0xFF00E2E2), Color(0xFF0EA5E9)])
                    : const LinearGradient(colors: [Color(0xFF00D2D2), Color(0xFF0284C7)]),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D2D2).withValues(alpha: isHovered ? 0.4 : 0.2),
                    blurRadius: isHovered ? 12 : 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/run app.svg',
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Run App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  // ================= CANVAS WORKSPACE =================
  Widget _buildCanvasArea() {
    // Emulator Sizing based on Device selection & zoom
    double scale = 1.0;
    if (_zoomLevel == '75%') scale = 0.75;
    if (_zoomLevel == '125%') scale = 1.25;

    double emulatorWidth = 360;
    double emulatorHeight = 640;

    if (_selectedDevice == 'tablet') {
      emulatorWidth = 600;
      emulatorHeight = 800;
    } else if (_selectedDevice == 'desktop') {
      emulatorWidth = 900;
      emulatorHeight = 560;
    }

    // Handle orientation swap
    if (!_isPortrait) {
      final temp = emulatorWidth;
      emulatorWidth = emulatorHeight;
      emulatorHeight = temp;
    }

    return Center(
      child: Transform.scale(
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: emulatorWidth,
          height: emulatorHeight,
          decoration: BoxDecoration(
            color: _canvasBgColor,
            borderRadius: BorderRadius.circular(_selectedDevice == 'desktop' ? 12 : 28),
            border: Border.all(color: Color(0xFF003B5C).withValues(alpha: 0.70), width: 8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            children: [
              // Emulator Status Bar Area
              if (_selectedDevice != 'desktop')
                Container(
                  height: 30,
                  color: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '9:41',
                        style: TextStyle(
                          color: _canvasBgColor == Colors.white ? Colors.black : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.signal_cellular_4_bar_rounded,
                            size: 10,
                            color: _canvasBgColor == Colors.white ? Colors.black : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.wifi,
                            size: 10,
                            color: _canvasBgColor == Colors.white ? Colors.black : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.battery_5_bar_rounded,
                            size: 12,
                            color: _canvasBgColor == Colors.white ? Colors.black : Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Mock App Header Bar
              Container(
                height: 52,
                color: const Color(0xFF003B5C),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 16),
                    Text(
                      _scaffoldName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),

              // Main Drop Area (Interactive Canvas widgets)
              Expanded(
                child: DragTarget<String>(
                  onWillAcceptWithDetails: (details) {
                    setState(() => _isDraggingOver = true);
                    return true;
                  },
                  onLeave: (data) {
                    setState(() => _isDraggingOver = false);
                  },
                  onAcceptWithDetails: (details) {
                    setState(() => _isDraggingOver = false);
                    if (_dropProcessed) return;

                    final dataStr = details.data;
                    if (dataStr.startsWith('EXISTING:')) {
                      final dragId = dataStr.replaceFirst('EXISTING:', '');
                      final nodeToMove = _findNode(_canvasWidgets, dragId);
                      if (nodeToMove != null) {
                        setState(() {
                          _removeNode(_canvasWidgets, dragId);
                          _canvasWidgets.add(nodeToMove);
                          _selectedWidgetId = dragId;
                          _saveToHistory();
                        });
                      }
                    } else {
                      _addWidget(dataStr);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isDesktop = _selectedDevice == 'desktop';
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _canvasBgColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(isDesktop ? 4 : 28),
                        ),
                        border: Border.all(
                          color: _isDraggingOver ? AppTheme.primaryColor.withValues(alpha: 0.8) : Colors.transparent,
                          width: 2.0,
                        ),
                        boxShadow: _isDraggingOver
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _selectedWidgetId = null;
                          });
                        },
                        child: _canvasWidgets.isEmpty
                            ? _buildDropHerePlaceholder()
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _canvasWidgets.length,
                                      itemBuilder: (context, index) {
                                        final node = _canvasWidgets[index];
                                        return _buildCanvasWidgetNode(node);
                                      },
                                    ),
                                  ),

                                  // Bottom Clear Actions
                                  TextButton.icon(
                                    onPressed: _clearCanvas,
                                    icon: const Icon(
                                      Icons.cleaning_services_rounded,
                                      size: 14,
                                      color: Colors.redAccent,
                                    ),
                                    label: const Text(
                                      'Clear Canvas',
                                      style: TextStyle(color: Colors.redAccent, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropHerePlaceholder() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (_canvasBgColor == Colors.white ? Colors.black : Colors.white).withValues(alpha: 0.1),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 24,
              color: (_canvasBgColor == Colors.white ? Colors.black : Colors.white).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              'Drop here',
              style: TextStyle(
                color: (_canvasBgColor == Colors.white ? Colors.black : Colors.white).withValues(alpha: 0.4),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasWidgetNode(_WidgetNode node) {
    Color itemColor = Colors.white.withValues(alpha: 0.05);
    Color textColor = Colors.white;
    if (_canvasBgColor == Colors.white) {
      itemColor = Colors.black.withValues(alpha: 0.05);
      textColor = Colors.black;
    }

    final isSelected = _selectedWidgetId == node.id;
    final props = _getWidgetProps(node.id, node.type);

    // Let's decide if this widget is a layout container
    final bool isLayout =
        node.type == 'Column' || node.type == 'Row' || node.type == 'Container' || node.type == 'Card';

    // Build children widgets recursively if they exist
    List<Widget> childrenWidgets = [];
    for (final child in node.children) {
      childrenWidgets.add(_buildCanvasWidgetNode(child));
    }

    Widget content = const SizedBox();
    if (node.type == 'Text') {
      final textVal = props['text'] ?? 'Simulated dynamic text title heading';
      final fontSize = (props['fontSize'] as double?) ?? 13.0;
      final isBold = (props['isBold'] as bool?) ?? true;
      final colorHex = props['colorHex'] ?? (textColor == Colors.black ? '#000000' : '#FFFFFF');
      final color = _parseHexColor(colorHex, textColor);
      content = Text(
        textVal,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      );
    } else if (node.type == 'Column') {
      final spacing = (props['spacing'] as double?) ?? 8.0;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childrenWidgets.isEmpty
            ? [
                Text(
                  'Empty Column Container (Drop items here)',
                  style: TextStyle(color: textColor.withValues(alpha: 0.35), fontSize: 9, fontStyle: FontStyle.italic),
                ),
              ]
            : childrenWidgets
                  .map(
                    (c) => Padding(
                      padding: EdgeInsets.only(bottom: spacing),
                      child: c,
                    ),
                  )
                  .toList(),
      );
    } else if (node.type == 'Row') {
      final spacing = (props['spacing'] as double?) ?? 8.0;
      content = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: childrenWidgets.isEmpty
            ? [
                Text(
                  'Empty Row Container (Drop items here)',
                  style: TextStyle(color: textColor.withValues(alpha: 0.35), fontSize: 9, fontStyle: FontStyle.italic),
                ),
              ]
            : childrenWidgets
                  .map(
                    (c) => Padding(
                      padding: EdgeInsets.only(right: spacing),
                      child: c,
                    ),
                  )
                  .toList(),
      );
    } else if (node.type == 'Container') {
      final height = (props['height'] as double?) ?? 60.0;
      final textVal = props['text'] ?? 'Container Area';
      final colorHex = props['colorHex'] ?? '#00D2D2';
      final baseColor = _parseHexColor(colorHex, AppTheme.primaryColor);
      content = Container(
        constraints: BoxConstraints(minHeight: height),
        width: double.infinity,
        decoration: BoxDecoration(
          color: baseColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: baseColor.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                textVal,
                style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
            if (childrenWidgets.isNotEmpty)
              ...childrenWidgets
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '(Drop items here)',
                  style: TextStyle(color: textColor.withValues(alpha: 0.2), fontSize: 8),
                ),
              ),
          ],
        ),
      );
    } else if (node.type == 'Image') {
      final height = (props['height'] as double?) ?? 60.0;
      final imageUrl = props['url'] ?? '';
      content = Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: textColor.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) {
                      return Icon(Icons.broken_image_rounded, size: 24, color: textColor.withValues(alpha: 0.4));
                    },
                  ),
                )
              : Icon(Icons.image_outlined, size: 24, color: textColor.withValues(alpha: 0.4)),
        ),
      );
    } else if (node.type == 'Button') {
      final textVal = props['text'] ?? 'Click Trigger';
      final colorHex = props['colorHex'] ?? '#00D2D2';
      final btnColor = _parseHexColor(colorHex, AppTheme.primaryColor);
      content = Container(
        height: 36,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: btnColor.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            textVal,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
          ),
        ),
      );
    } else if (node.type == 'Card') {
      final elevation = (props['elevation'] as double?) ?? 2.0;
      final padding = (props['padding'] as double?) ?? 10.0;
      content = Container(
        padding: EdgeInsets.all(padding),
        width: double.infinity,
        decoration: BoxDecoration(
          color: itemColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColor.withValues(alpha: 0.1)),
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08 * elevation),
                    blurRadius: 4 * elevation,
                    offset: Offset(0, 1.5 * elevation),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: childrenWidgets.isEmpty
              ? [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 8, width: 60, color: textColor.withValues(alpha: 0.4)),
                          const SizedBox(height: 4),
                          Container(height: 6, width: 40, color: textColor.withValues(alpha: 0.2)),
                        ],
                      ),
                    ],
                  ),
                ]
              : childrenWidgets,
        ),
      );
    } else {
      content = Text(node.type, style: TextStyle(color: textColor, fontSize: 12));
    }

    // Wrap the visual widget container with standard highlight or layout drop area!
    final Widget baseVisualWidget = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLayout ? Colors.transparent : itemColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          // Normal blue/primary highlight instead of harsh deep red/orange:
          color: isSelected ? AppTheme.primaryColor : textColor.withValues(alpha: 0.05),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: content,
    );

    Widget visualWidget = baseVisualWidget;

    // Make it a DragTarget if it is a layout container!
    if (isLayout) {
      visualWidget = DragTarget<String>(
        onWillAcceptWithDetails: (details) {
          // Prevent dropping a widget inside itself or its descendants!
          if (details.data.startsWith('EXISTING:')) {
            final dragId = details.data.replaceFirst('EXISTING:', '');
            if (dragId == node.id || _isNodeDescendantOfAncestor(dragId, node.id)) {
              return false;
            }
          }
          return true;
        },
        onAcceptWithDetails: (details) {
          if (_dropProcessed) return;
          setState(() {
            _dropProcessed = true;
          });
          Future.microtask(() {
            _dropProcessed = false;
          });
          final dataStr = details.data;
          _handleDropIntoNode(dataStr, node);
        },
        builder: (context, candidateData, rejectedData) {
          final isOver = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isOver ? AppTheme.primaryColor : (isSelected ? AppTheme.primaryColor : Colors.transparent),
                width: isOver || isSelected ? 1.5 : 1.0,
              ),
              color: isOver ? AppTheme.primaryColor.withValues(alpha: 0.05) : Colors.transparent,
            ),
            child: baseVisualWidget,
          );
        },
      );
    }

    // Wrap in Draggable so children can be dragged and dropped into other widgets too!
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Draggable<String>(
            data: 'EXISTING:${node.id}',
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.85,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getWidgetIcon(node.type), size: 14, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        node.type,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.25,
              child: visualWidget,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selectedWidgetId = node.id;
                });
              },
              child: visualWidget,
            ),
          ),

          // Delete overlay button (top right)
          Positioned(
            right: -2,
            top: -2,
            child: GestureDetector(
              onTap: () => _removeWidgetNode(node.id),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, size: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PROPERTIES PANEL =================
  Widget _buildPropertiesPanel() {
    final selectedNode = _selectedWidgetId != null ? _findNode(_canvasWidgets, _selectedWidgetId!) : null;
    final hasSelection = selectedNode != null;
    final title = hasSelection ? 'WIDGET PROPERTIES' : 'SCREEN PROPERTIES';

    return Container(
      width: 320,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel Title Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  children: [
                    Icon(
                      hasSelection ? Icons.widgets_rounded : Icons.tune_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    if (hasSelection) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _selectedWidgetId = null),
                        child: Text(
                          'DESELECT',
                          style: TextStyle(
                            color: AppTheme.primaryColor.withValues(alpha: 0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),

              // Settings Form
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: hasSelection ? _buildWidgetPropertiesList(selectedNode) : _buildScreenPropertiesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertySectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchProperty({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              activeThumbColor: AppTheme.primaryColor,
              activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.white.withValues(alpha: 0.4),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomColorSelector({
    required Color selectedColor,
    required String selectedHex,
    required List<MapEntry<Color, String>> options,
    required void Function(Color color, String hex) onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Color Preview Box
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
          ),
          const SizedBox(width: 12),

          // Hex Label
          Expanded(
            child: Text(
              selectedHex,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Selection options
          ...options.map((entry) {
            final isSelected = selectedHex.toUpperCase() == entry.value.toUpperCase();
            return Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: GestureDetector(
                onTap: () => onSelected(entry.key, entry.value),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: entry.key,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.15),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return _buildCustomColorSelector(
      selectedColor: _canvasBgColor,
      selectedHex: _canvasBgHex,
      options: [
        const MapEntry(Colors.white, '#FFFFFF'),
        const MapEntry(Color(0xFF0F172A), '#0F172A'),
        const MapEntry(Color(0xFF020617), '#020617'),
      ],
      onSelected: (col, hex) {
        setState(() {
          _canvasBgColor = col;
          _canvasBgHex = hex;
        });
      },
    );
  }

  List<Widget> _buildWidgetPropertiesList(_WidgetNode node) {
    final type = node.type;
    final props = _getWidgetProps(node.id, type);

    final List<Widget> items = [];

    items.add(
      Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getWidgetIcon(type),
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type Widget'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Element ID: #${node.id.substring(node.id.length > 6 ? node.id.length - 6 : 0)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (type == 'Text') {
      final controller = TextEditingController(text: props['text'] ?? '');
      items.add(_buildPropertySectionLabel('TEXT CONTENT'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildTextInputField(
          label: 'Value',
          controller: controller,
          icon: Icons.text_fields_rounded,
          onChanged: (val) {
            setState(() {
              props['text'] = val;
              _saveToHistory();
            });
          },
        ),
      );
      items.add(const SizedBox(height: 20));

      final double currentSize = (props['fontSize'] as double?) ?? 13.0;
      items.add(_buildPropertySectionLabel('FONT SIZE ($currentSize)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 10.0,
            max: 30.0,
            value: currentSize,
            onChanged: (val) {
              setState(() {
                props['fontSize'] = double.parse(val.toStringAsFixed(1));
                _saveToHistory();
              });
            },
          ),
        ),
      );
      items.add(const SizedBox(height: 20));

      final bool isBold = (props['isBold'] as bool?) ?? true;
      items.add(
        _buildSwitchProperty(
          title: 'Bold Typography',
          value: isBold,
          onChanged: (val) {
            setState(() {
              props['isBold'] = val;
              _saveToHistory();
            });
          },
        ),
      );
      items.add(const SizedBox(height: 20));

      final String colorHex = props['colorHex'] ?? '#FFFFFF';
      final selectedColor = _parseHexColor(colorHex, Colors.white);
      items.add(_buildPropertySectionLabel('TEXT COLOR'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildCustomColorSelector(
          selectedColor: selectedColor,
          selectedHex: colorHex,
          options: [
            const MapEntry(Colors.white, '#FFFFFF'),
            const MapEntry(Colors.black, '#000000'),
            const MapEntry(AppTheme.primaryColor, '#00D2D2'),
            const MapEntry(Colors.amber, '#FFC107'),
            const MapEntry(Colors.redAccent, '#FF5252'),
          ],
          onSelected: (col, hex) {
            setState(() {
              props['colorHex'] = hex;
              _saveToHistory();
            });
          },
        ),
      );
    } else if (type == 'Button') {
      final controller = TextEditingController(text: props['text'] ?? '');
      items.add(_buildPropertySectionLabel('BUTTON TEXT'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildTextInputField(
          label: 'Label',
          controller: controller,
          icon: Icons.smart_button_rounded,
          onChanged: (val) {
            setState(() {
              props['text'] = val;
              _saveToHistory();
            });
          },
        ),
      );
      items.add(const SizedBox(height: 20));

      final String colorHex = props['colorHex'] ?? '#00D2D2';
      final selectedColor = _parseHexColor(colorHex, AppTheme.primaryColor);
      items.add(_buildPropertySectionLabel('BACKGROUND COLOR'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildCustomColorSelector(
          selectedColor: selectedColor,
          selectedHex: colorHex,
          options: [
            const MapEntry(AppTheme.primaryColor, '#00D2D2'),
            const MapEntry(Color(0xFFEC4899), '#EC4899'),
            const MapEntry(Colors.amber, '#FFC107'),
            const MapEntry(Colors.deepOrange, '#FF5722'),
            const MapEntry(Colors.blueAccent, '#448AFF'),
          ],
          onSelected: (col, hex) {
            setState(() {
              props['colorHex'] = hex;
              _saveToHistory();
            });
          },
        ),
      );
    } else if (type == 'Container') {
      final controller = TextEditingController(text: props['text'] ?? '');
      items.add(_buildPropertySectionLabel('LABEL CONTENT'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildTextInputField(
          label: 'Inner Label',
          controller: controller,
          icon: Icons.title_rounded,
          onChanged: (val) {
            setState(() {
              props['text'] = val;
              _saveToHistory();
            });
          },
        ),
      );
      items.add(const SizedBox(height: 20));

      final double currentHeight = (props['height'] as double?) ?? 40.0;
      items.add(_buildPropertySectionLabel('HEIGHT ($currentHeight px)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 30.0,
            max: 120.0,
            value: currentHeight,
            onChanged: (val) {
              setState(() {
                props['height'] = double.parse(val.toStringAsFixed(0));
                _saveToHistory();
              });
            },
          ),
        ),
      );
      items.add(const SizedBox(height: 20));

      final String colorHex = props['colorHex'] ?? '#00D2D2';
      final selectedColor = _parseHexColor(colorHex, AppTheme.primaryColor);
      items.add(_buildPropertySectionLabel('BORDER COLOR'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildCustomColorSelector(
          selectedColor: selectedColor,
          selectedHex: colorHex,
          options: [
            const MapEntry(AppTheme.primaryColor, '#00D2D2'),
            const MapEntry(Color(0xFFEC4899), '#EC4899'),
            const MapEntry(Colors.amber, '#FFC107'),
            const MapEntry(Colors.deepOrange, '#FF5722'),
            const MapEntry(Colors.blueAccent, '#448AFF'),
          ],
          onSelected: (col, hex) {
            setState(() {
              props['colorHex'] = hex;
              _saveToHistory();
            });
          },
        ),
      );
    } else if (type == 'Image') {
      final controller = TextEditingController(text: props['url'] ?? '');
      items.add(_buildPropertySectionLabel('IMAGE SOURCE PATH'));
      items.add(const SizedBox(height: 8));
      items.add(
        _buildTextInputField(
          label: 'URL or Asset Path',
          controller: controller,
          icon: Icons.link_rounded,
          onChanged: (val) {
            setState(() {
              props['url'] = val;
              _saveToHistory();
            });
          },
        ),
      );
      items.add(const SizedBox(height: 20));

      final double currentHeight = (props['height'] as double?) ?? 60.0;
      items.add(_buildPropertySectionLabel('IMAGE DISPLAY HEIGHT ($currentHeight)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 40.0,
            max: 200.0,
            value: currentHeight,
            onChanged: (val) {
              setState(() {
                props['height'] = double.parse(val.toStringAsFixed(0));
                _saveToHistory();
              });
            },
          ),
        ),
      );
    } else if (type == 'Card') {
      final double currentElevation = (props['elevation'] as double?) ?? 2.0;
      items.add(_buildPropertySectionLabel('ELEVATION / SHADOW ($currentElevation)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 0.0,
            max: 8.0,
            value: currentElevation,
            onChanged: (val) {
              setState(() {
                props['elevation'] = double.parse(val.toStringAsFixed(1));
                _saveToHistory();
              });
            },
          ),
        ),
      );
      items.add(const SizedBox(height: 20));

      final double currentPadding = (props['padding'] as double?) ?? 10.0;
      items.add(_buildPropertySectionLabel('INNER PADDING ($currentPadding px)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 4.0,
            max: 24.0,
            value: currentPadding,
            onChanged: (val) {
              setState(() {
                props['padding'] = double.parse(val.toStringAsFixed(0));
                _saveToHistory();
              });
            },
          ),
        ),
      );
    } else if (type == 'Column' || type == 'Row') {
      final double spacing = (props['spacing'] as double?) ?? 8.0;
      items.add(_buildPropertySectionLabel('ELEMENT GAP ($spacing px)'));
      items.add(const SizedBox(height: 8));
      items.add(
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
          ),
          child: Slider(
            min: 0.0,
            max: 24.0,
            value: spacing,
            onChanged: (val) {
              setState(() {
                props['spacing'] = double.parse(val.toStringAsFixed(0));
                _saveToHistory();
              });
            },
          ),
        ),
      );
    } else {
      items.add(
        Text(
          'Properties are auto-optimized for this layout component.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
        ),
      );
    }

    return items;
  }

  List<Widget> _buildScreenPropertiesList() {
    return [
      _buildPropertySectionLabel('Routing'),
      const SizedBox(height: 10),
      _buildTextInputField(
        label: 'Route Path',
        controller: _routeController,
        icon: Icons.alt_route_rounded,
        onChanged: (val) => setState(() {}),
      ),
      const SizedBox(height: 12),
      _buildSwitchProperty(
        title: 'Requires Authentication',
        value: _requiresAuth,
        onChanged: (val) => setState(() => _requiresAuth = val),
      ),
      const SizedBox(height: 24),
      Divider(color: Colors.white.withValues(alpha: 0.05)),
      const SizedBox(height: 12),
      _buildPropertySectionLabel('Scaffold'),
      const SizedBox(height: 10),
      _buildTextInputField(
        label: 'HomePage Class',
        controller: _scaffoldController,
        icon: Icons.widgets_outlined,
        onChanged: (val) => setState(() => _scaffoldName = val),
      ),
      const SizedBox(height: 24),
      Divider(color: Colors.white.withValues(alpha: 0.05)),
      const SizedBox(height: 12),
      _buildPropertySectionLabel('Background Color'),
      const SizedBox(height: 12),
      _buildColorSelector(),
      const SizedBox(height: 24),
      Divider(color: Colors.white.withValues(alpha: 0.05)),
      const SizedBox(height: 12),
      _buildPropertySectionLabel('Toggles'),
      const SizedBox(height: 12),
      _buildSwitchProperty(
        title: 'Safe Area',
        value: _safeArea,
        onChanged: (v) => setState(() => _safeArea = v),
      ),
      _buildSwitchProperty(
        title: 'Hide Keyboard on Tap',
        value: _hideKeyboard,
        onChanged: (v) => setState(() => _hideKeyboard = v),
      ),
      _buildSwitchProperty(
        title: 'Exclude Background Dismiss',
        value: _excludeDismiss,
        onChanged: (v) => setState(() => _excludeDismiss = v),
      ),
      _buildSwitchProperty(
        title: 'Disable Resize Bottom Inset',
        value: _disableResize,
        onChanged: (v) => setState(() => _disableResize = v),
      ),
    ];
  }

  Map<String, dynamic> _getWidgetProps(String id, String type) {
    if (!_widgetProperties.containsKey(id)) {
      final Map<String, dynamic> defaults = {};
      if (type == 'Text') {
        defaults['text'] = 'Simulated dynamic text title heading';
        defaults['fontSize'] = 13.0;
        defaults['isBold'] = true;
        defaults['colorHex'] = _canvasBgColor == Colors.white ? '#000000' : '#FFFFFF';
      } else if (type == 'Button') {
        defaults['text'] = 'Click Trigger';
        defaults['colorHex'] = '#00D2D2';
      } else if (type == 'Container') {
        defaults['text'] = 'Container Area';
        defaults['height'] = 40.0;
        defaults['colorHex'] = '#00D2D2';
      } else if (type == 'Image') {
        defaults['height'] = 60.0;
        defaults['url'] = '';
      } else if (type == 'Card') {
        defaults['elevation'] = 2.0;
        defaults['padding'] = 10.0;
      } else if (type == 'Column' || type == 'Row') {
        defaults['spacing'] = 8.0;
      }
      _widgetProperties[id] = defaults;
    }
    return _widgetProperties[id]!;
  }

  IconData _getWidgetIcon(String type) {
    if (type == 'Text') return Icons.text_fields_rounded;
    if (type == 'Button') return Icons.smart_button_rounded;
    if (type == 'Container') return Icons.crop_square_rounded;
    if (type == 'Image') return Icons.image_rounded;
    if (type == 'Card') return Icons.card_membership_rounded;
    if (type == 'Column') return Icons.view_week_rounded;
    if (type == 'Row') return Icons.view_headline_rounded;
    return Icons.widgets_rounded;
  }

  Color _parseHexColor(String hex, Color defaultColor) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      } else if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }
    } catch (_) {}
    return defaultColor;
  }
}

class _WidgetNode {
  final String id;
  final String type;
  final List<_WidgetNode> children;

  _WidgetNode({
    required this.id,
    required this.type,
    List<_WidgetNode>? children,
  }) : children = children ?? [];

  _WidgetNode clone() {
    return _WidgetNode(
      id: id,
      type: type,
      children: children.map((c) => c.clone()).toList(),
    );
  }
}

class _CanvasState {
  final List<_WidgetNode> widgets;
  final Map<String, Map<String, dynamic>> properties;

  _CanvasState(List<_WidgetNode> w, Map<String, Map<String, dynamic>> p)
    : widgets = w.map((node) => node.clone()).toList(),
      properties = p.map((key, value) => MapEntry(key, Map.from(value)));
}

class _PaletteItemData {
  final String icon;
  final String label;
  final String type;

  const _PaletteItemData({
    required this.icon,
    required this.label,
    required this.type,
  });
}
