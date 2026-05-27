import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/components/glass_card.dart';

class NewWidgetDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const NewWidgetDialog({super.key, this.initialData});

  @override
  State<NewWidgetDialog> createState() => _NewWidgetDialogState();
}

class _NewWidgetDialogState extends State<NewWidgetDialog> {
  int _activeTabIndex = 0;
  int? _hoveredTabIndex;

  // Tab 1: Basic Info
  late final TextEditingController _nameController;
  late String _selectedCategory;
  late final TextEditingController _descriptionController;

  // Tab 2: Properties
  final List<Map<String, dynamic>> _properties = [];
  final TextEditingController _propertyNameController = TextEditingController();
  String _selectedPropertyType = 'string';
  final TextEditingController _propertyDefaultValueController = TextEditingController();
  bool _propertyRequired = false;

  // Tab 3: Functions
  final List<Map<String, dynamic>> _functions = [];
  final TextEditingController _functionNameController = TextEditingController();
  final TextEditingController _functionCodeController = TextEditingController();

  // Tab 4: Render Code
  late final TextEditingController _renderCodeController;

  final List<String> _categories = ['Control', 'Input', 'Display', 'Layout'];
  final List<String> _propertyTypes = ['string', 'number', 'boolean', 'array', 'object'];

  @override
  void initState() {
    super.initState();

    // Parse incoming values
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    
    final String categoryRaw = widget.initialData?['category'] ?? 'Control';
    _selectedCategory = categoryRaw.isEmpty 
        ? 'Control' 
        : '${categoryRaw[0].toUpperCase()}${categoryRaw.substring(1).toLowerCase()}';
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Control';
    }

    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
    
    if (widget.initialData?['properties'] != null) {
      _properties.addAll(List<Map<String, dynamic>>.from(
        (widget.initialData?['properties'] as List<dynamic>).map((item) => Map<String, dynamic>.from(item))
      ));
    }
    
    if (widget.initialData?['functions'] != null) {
      _functions.addAll(List<Map<String, dynamic>>.from(
        (widget.initialData?['functions'] as List<dynamic>).map((item) => Map<String, dynamic>.from(item))
      ));
    }

    _renderCodeController = TextEditingController(text: widget.initialData?['renderCode'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _propertyNameController.dispose();
    _propertyDefaultValueController.dispose();
    _functionNameController.dispose();
    _functionCodeController.dispose();
    _renderCodeController.dispose();
    super.dispose();
  }

  void _addProperty() {
    final name = _propertyNameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _properties.add({
        'name': name,
        'type': _selectedPropertyType,
        'defaultValue': _propertyDefaultValueController.text.trim(),
        'required': _propertyRequired,
      });

      // Clear input fields
      _propertyNameController.clear();
      _propertyDefaultValueController.clear();
      _propertyRequired = false;
      _selectedPropertyType = 'string';
    });
  }

  void _removeProperty(int index) {
    setState(() {
      _properties.removeAt(index);
    });
  }

  void _addSpreadsheetFunction() {
    final name = _functionNameController.text.trim();
    final code = _functionCodeController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _functions.add({
        'name': name,
        'code': code,
      });

      // Clear input fields
      _functionNameController.clear();
      _functionCodeController.clear();
    });
  }

  void _removeFunction(int index) {
    setState(() {
      _functions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 800,
          height: 600,
          child: GlassCard(
            backgroundOpacity: 0.15,
            borderOpacity: 0.25,
            borderRadius: 24,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialData == null ? 'Create New Widget' : 'Edit Widget',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tabs Navigation Header
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(0, 'Basic Info'),
                      _buildTabButton(1, 'Properties'),
                      _buildTabButton(2, 'Functions'),
                      _buildTabButton(3, 'Render Code'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Content Area
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildActiveTabContent(),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      'Cancel',
                      onTap: () => Navigator.pop(context),
                      isPrimary: false,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      widget.initialData == null ? 'Create Widget' : 'Save Changes',
                      onTap: () {
                        if (_nameController.text.trim().isNotEmpty) {
                          Navigator.pop(context, {
                            'name': _nameController.text.trim(),
                            'category': _selectedCategory,
                            'description': _descriptionController.text.trim(),
                            'properties': _properties,
                            'functions': _functions,
                            'renderCode': _renderCodeController.text.trim(),
                          });
                        }
                      },
                      isPrimary: true,
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

  Widget _buildTabButton(int index, String label) {
    final isActive = _activeTabIndex == index;
    final isHovered = _hoveredTabIndex == index;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredTabIndex = index),
        onExit: (_) => setState(() => _hoveredTabIndex = null),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _activeTabIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isActive 
                  ? const Color(0xFF00B8AC) 
                  : (isHovered ? Colors.white.withValues(alpha: 0.08) : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    Widget activeWidget;
    switch (_activeTabIndex) {
      case 0:
        activeWidget = _buildBasicInfoTab();
        break;
      case 1:
        activeWidget = _buildPropertiesTab();
        break;
      case 2:
        activeWidget = _buildFunctionsTab();
        break;
      case 3:
        activeWidget = _buildRenderCodeTab();
        break;
      default:
        activeWidget = const SizedBox();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_activeTabIndex),
        child: activeWidget,
      ),
    );
  }

  // --- TAB 1: BASIC INFO ---
  Widget _buildBasicInfoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Widget Name'),
        _buildTextField(
          controller: _nameController,
          hint: 'Widget name',
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Type'),
        _buildDropdownField(
          value: _selectedCategory,
          items: _categories,
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedCategory = val);
            }
          },
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Description'),
        _buildTextField(
          controller: _descriptionController,
          hint: 'Widget description',
          maxLines: 4,
        ),
      ],
    );
  }

  // --- TAB 2: PROPERTIES ---
  Widget _buildPropertiesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Property',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('Property Name'),
                  _buildTextField(
                    controller: _propertyNameController,
                    hint: 'Property name',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('Type'),
                  _buildDropdownField(
                    value: _selectedPropertyType,
                    items: _propertyTypes,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedPropertyType = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('Default Value'),
                  _buildTextField(
                    controller: _propertyDefaultValueController,
                    hint: 'Default value',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Row(
              children: [
                Checkbox(
                  value: _propertyRequired,
                  onChanged: (val) {
                    setState(() => _propertyRequired = val ?? false);
                  },
                  side: const BorderSide(color: Colors.white54),
                  activeColor: AppTheme.primaryColor,
                ),
                const Text(
                  'Required',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInlineButton('Add Property', onTap: _addProperty),
        const SizedBox(height: 24),
        const Text(
          'Current Properties',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _properties.isEmpty
            ? Text(
                'No properties added yet.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _properties.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final prop = _properties[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prop['name'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Type: ${prop['type']} | Default: ${prop['defaultValue'].isEmpty ? 'none' : prop['defaultValue']} | Required: ${prop['required']}',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => _removeProperty(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  // --- TAB 3: FUNCTIONS ---
  Widget _buildFunctionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Custom Function',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildSectionLabel('Function Name'),
        _buildTextField(
          controller: _functionNameController,
          hint: 'Function name',
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Function Code'),
        _buildTextField(
          controller: _functionCodeController,
          hint: 'JavaScript function code',
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        _buildInlineButton('Add Function', onTap: _addSpreadsheetFunction),
        const SizedBox(height: 24),
        const Text(
          'Custom Functions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _functions.isEmpty
            ? Text(
                'No custom functions added yet.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _functions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final func = _functions[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                func['name'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                func['code'].isEmpty ? 'Empty code block' : func['code'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => _removeFunction(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  // --- TAB 4: RENDER CODE ---
  Widget _buildRenderCodeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Render Code (JSX)'),
        _buildTextField(
          controller: _renderCodeController,
          hint: 'JSX code for rendering the widget',
          maxLines: 10,
        ),
      ],
    );
  }

  // --- GENERAL WIDGET BUILDERS ---
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return _DialogTextField(
      controller: controller,
      hint: hint,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return _DialogDropdownField(
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildInlineButton(String label, {required VoidCallback onTap}) {
    return _DialogInlineButton(
      label: label,
      onTap: onTap,
    );
  }

  Widget _buildActionButton(String label, {required VoidCallback onTap, required bool isPrimary}) {
    return _DialogActionButton(label: label, onTap: onTap, isPrimary: isPrimary);
  }
}

class _DialogTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _DialogTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  State<_DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<_DialogTextField> {
  bool _isHovered = false;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHighlight = _isFocused || _isHovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _isFocused ? 0.05 : 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasHighlight 
                ? const Color(0xFF00B8AC) 
                : Colors.white.withValues(alpha: 0.1),
            width: hasHighlight ? 1.2 : 1.0,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF00B8AC).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          maxLines: widget.maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _DialogDropdownField extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DialogDropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_DialogDropdownField> createState() => _DialogDropdownFieldState();
}

class _DialogDropdownFieldState extends State<_DialogDropdownField> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered 
                ? const Color(0xFF00B8AC) 
                : Colors.white.withValues(alpha: 0.1),
            width: _isHovered ? 1.2 : 1.0,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: widget.value,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
            isExpanded: true,
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}

class _DialogInlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _DialogInlineButton({required this.label, required this.onTap});

  @override
  State<_DialogInlineButton> createState() => _DialogInlineButtonState();
}

class _DialogInlineButtonState extends State<_DialogInlineButton> {
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
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFF00B8AC).withValues(alpha: 0.08) : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isHovered ? const Color(0xFF00B8AC) : Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: _isHovered ? const Color(0xFF00B8AC) : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DialogActionButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  State<_DialogActionButton> createState() => _DialogActionButtonState();
}

class _DialogActionButtonState extends State<_DialogActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.isPrimary;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isPrimary
                  ? (_isHovered ? const Color(0xFF00ADB5) : const Color(0xFF00B8AC))
                  : (_isHovered ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.03)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPrimary 
                    ? (_isHovered ? Colors.white : const Color(0xFF00B8AC).withValues(alpha: 0.3))
                    : (_isHovered ? Colors.white : Colors.white.withValues(alpha: 0.1)),
              ),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00B8AC).withValues(alpha: _isHovered ? 0.4 : 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
