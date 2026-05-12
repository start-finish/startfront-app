import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';

class GlobalThemePage extends ConsumerStatefulWidget {
  const GlobalThemePage({super.key});

  @override
  ConsumerState<GlobalThemePage> createState() => _GlobalThemePageState();
}

class _GlobalThemePageState extends ConsumerState<GlobalThemePage> {
  double _baseFontSize = 16.0;
  double _borderRadius = 8.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'GLOBAL THEMES';
      ref.read(pageSubtitleProvider.notifier).state = 'Customize your platform visual identity';
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
          // Top Toolbar
          Row(
            children: [
              _ToolbarButton(
                label: 'Apply Theme',
                iconPath: 'assets/icons/theme.svg',
                isPrimary: true,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ToolbarButton(
                label: 'Reset',
                iconPath: 'assets/icons/reset.svg',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ToolbarButton(
                label: 'Import',
                iconPath: 'assets/icons/import.svg',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ToolbarButton(
                label: 'Export',
                iconPath: 'assets/icons/export.svg',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Configuration Sections
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildConfigSection(
                      title: 'Color',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildColorInput('Primary Color', '#00D2D2', AppTheme.primaryColor),
                              const SizedBox(width: 24),
                              _buildColorInput('Secondary Color', '#6366F1', const Color(0xFF6366F1)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              _buildColorInput('Success Color', '#10B981', const Color(0xFF10B981)),
                              const SizedBox(width: 24),
                              _buildColorInput('Error Color', '#EF4444', const Color(0xFFEF4444)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildConfigSection(
                      title: 'Typography',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Font Family',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown('Inter'),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Base Font Size',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${_baseFontSize.toInt()}px',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                              ),
                            ],
                          ),
                          _buildSlider(_baseFontSize, 12, 24, (val) => setState(() => _baseFontSize = val)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildConfigSection(
                      title: 'Layout',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Border Radius',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${_borderRadius.toInt()}px',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                              ),
                            ],
                          ),
                          _buildSlider(_borderRadius, 0, 24, (val) => setState(() => _borderRadius = val)),
                          const SizedBox(height: 24),
                          const Text(
                            'Shadow Intensity',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown('Light'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),

              // Live Preview
              Expanded(
                flex: 2,
                child: _buildConfigSection(
                  title: 'Live Preview',
                  headerAction: _PreviewFullButton(onTap: () {}),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sample Heading',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is sample text to preview how your theme will look across the platform.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _PreviewButton(label: 'Primary Button', isPrimary: true),
                            const SizedBox(width: 12),
                            _PreviewButton(label: 'Secondary Button', isPrimary: false),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(_borderRadius),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Card Component',
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This shows how cards and panels will appear with your theme settings.',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigSection({required String title, required Widget child, Widget? headerAction}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (headerAction != null) headerAction,
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildColorInput(String label, String hex, Color previewColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    hex,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
        ],
      ),
    );
  }

  Widget _buildSlider(double value, double min, double max, ValueChanged<double> onChanged) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: AppTheme.primaryColor,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        thumbColor: Colors.white,
        overlayColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  final String label;
  final String iconPath;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.label,
    required this.iconPath,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: widget.isPrimary ? AppTheme.primaryGradient : null,
              color: widget.isPrimary ? null : Colors.white.withValues(alpha: _isHovered ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isPrimary
                    ? Colors.white.withValues(alpha: 0.4)
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
                SvgPicture.asset(
                  widget.iconPath,
                  width: 32,
                  height: 32,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
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

class _PreviewFullButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PreviewFullButton({required this.onTap});

  @override
  State<_PreviewFullButton> createState() => _PreviewFullButtonState();
}

class _PreviewFullButtonState extends State<_PreviewFullButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _isHovered ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.remove_red_eye_outlined, color: Colors.white.withValues(alpha: 0.8), size: 14),
              const SizedBox(width: 6),
              const Text(
                'Full Preview',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const _PreviewButton({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isPrimary ? AppTheme.primaryGradient : null,
        color: !isPrimary ? Colors.white.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(6),
        border: !isPrimary ? Border.all(color: Colors.white.withValues(alpha: 0.2)) : null,
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
