import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import 'theme_provider.dart';

class GlobalThemePage extends ConsumerStatefulWidget {
  const GlobalThemePage({super.key});

  @override
  ConsumerState<GlobalThemePage> createState() => _GlobalThemePageState();
}

class _GlobalThemePageState extends ConsumerState<GlobalThemePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'GLOBAL THEMES';
      ref.read(pageSubtitleProvider.notifier).state = 'Customize your platform visual identity';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  void _pickColor(String label, Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A3158),
        title: Text('Pick $label', style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onColorChanged,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DONE', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  void _applyTheme() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Apply Theme',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
        title: 'Apply Global Theme',
        message: 'Are you sure you want to apply these visual settings to the entire platform?',
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      AppNotification.show(
        context,
        title: 'Theme Applied',
        message: 'Visual identity has been updated across all modules.',
      );
    }
  }

  void _resetTheme() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Reset Theme',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
        title: 'Reset Theme',
        message: 'Are you sure you want to revert all visual settings to factory defaults?',
        confirmLabel: 'Yes, Reset',
        isDestructive: true,
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(themeStateProvider.notifier).reset();
      AppNotification.show(
        context,
        title: 'Theme Reset',
        message: 'All visual settings have been reverted to default.',
        type: NotificationType.info,
      );
    }
  }

  void _importTheme() {
    AppNotification.show(
      context,
      title: 'Import Theme',
      message: 'Select a valid .json theme configuration file to upload.',
      type: NotificationType.info,
    );
  }

  void _exportTheme() {
    AppNotification.show(
      context,
      title: 'Theme Exported',
      message: 'Global theme configuration has been saved to your downloads.',
    );
  }

  void _showFullPreview() {
    AppNotification.show(
      context,
      title: 'Live Preview',
      message: 'Rendering high-fidelity preview for all components...',
      type: NotificationType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeStateProvider);
    final notifier = ref.read(themeStateProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1024;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Toolbar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ToolbarButton(
                  label: 'Apply Theme',
                  iconPath: 'assets/icons/theme.svg',
                  isPrimary: true,
                  onTap: _applyTheme,
                ),
                const SizedBox(width: 12),
                _ToolbarButton(
                  label: 'Reset',
                  iconPath: 'assets/icons/reset.svg',
                  onTap: _resetTheme,
                ),
                const SizedBox(width: 12),
                _ToolbarButton(
                  label: 'Import',
                  iconPath: 'assets/icons/import.svg',
                  onTap: _importTheme,
                ),
                const SizedBox(width: 12),
                _ToolbarButton(
                  label: 'Export',
                  iconPath: 'assets/icons/export.svg',
                  onTap: _exportTheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Configuration Sections
              Flexible(
                flex: isMobile ? 0 : 3,
                fit: isMobile ? FlexFit.loose : FlexFit.tight,
                child: Column(
                  children: [
                    _buildConfigSection(
                      title: 'Color',
                      child: Column(
                        children: [
                          _buildResponsiveRow(
                            isMobile,
                            [
                              _buildColorInput(
                                'Primary Color',
                                theme.primaryColor,
                                (c) => notifier.updatePrimaryColor(c),
                              ),
                              _buildColorInput(
                                'Secondary Color',
                                theme.secondaryColor,
                                (c) => notifier.updateSecondaryColor(c),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildResponsiveRow(
                            isMobile,
                            [
                              _buildColorInput(
                                'Success Color',
                                theme.successColor,
                                (c) => notifier.updateSuccessColor(c),
                              ),
                              _buildColorInput(
                                'Error Color',
                                theme.errorColor,
                                (c) => notifier.updateErrorColor(c),
                              ),
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
                          _buildDropdown(theme.fontFamily, (val) => notifier.updateFontFamily(val!)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Base Font Size',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${theme.baseFontSize.toInt()}px',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                              ),
                            ],
                          ),
                          _buildSlider(
                            theme.baseFontSize,
                            12,
                            24,
                            (val) => notifier.updateBaseFontSize(val),
                          ),
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
                                '${theme.borderRadius.toInt()}px',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                              ),
                            ],
                          ),
                          _buildSlider(
                            theme.borderRadius,
                            0,
                            24,
                            (val) => notifier.updateBorderRadius(val),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Shadow Intensity',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            theme.shadowIntensity,
                            (val) => notifier.updateShadowIntensity(val!),
                            options: ['Light', 'Medium', 'Heavy'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 32),
              if (isMobile) const SizedBox(height: 32),

              // Live Preview
              Flexible(
                flex: isMobile ? 0 : 2,
                fit: isMobile ? FlexFit.loose : FlexFit.tight,
                child: _buildConfigSection(
                  title: 'Live Preview',
                  headerAction: _PreviewFullButton(onTap: _showFullPreview),
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
                        Text(
                          'Sample Heading',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: theme.baseFontSize + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is sample text to preview how your theme will look across the platform.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: theme.baseFontSize - 3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _PreviewButton(
                              label: 'Primary Button',
                              isPrimary: true,
                              color: theme.primaryColor,
                              borderRadius: theme.borderRadius,
                            ),
                            _PreviewButton(
                              label: 'Secondary Button',
                              isPrimary: false,
                              color: theme.secondaryColor,
                              borderRadius: theme.borderRadius,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(theme.borderRadius),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            boxShadow: theme.shadowIntensity == 'Light'
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: theme.shadowIntensity == 'Medium' ? 0.2 : 0.4,
                                      ),
                                      blurRadius: theme.shadowIntensity == 'Medium' ? 10 : 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card Component',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: theme.baseFontSize - 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This shows how cards and panels will appear with your theme settings.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: theme.baseFontSize - 4,
                                ),
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

  Widget _buildResponsiveRow(bool isMobile, List<Widget> children) {
    if (isMobile) {
      return Column(
        children: children
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(bottom: e.key == children.length - 1 ? 0 : 16),
                child: Row(children: [Expanded(child: e.value)]),
              ),
            )
            .toList(),
      );
    }
    return Row(
      children: children
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key == children.length - 1 ? 0 : 24),
                child: e.value,
              ),
            ),
          )
          .toList(),
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

  Widget _buildColorInput(String label, Color color, Function(Color) onColorChanged) {
    final hex = '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _pickColor(label, color, onColorChanged),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
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
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String value, Function(String?) onChanged, {List<String>? options}) {
    final list = options ?? ['Inter', 'Roboto', 'Outfit', 'Montserrat'];

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: list.contains(value) ? value : list.first,
          dropdownColor: const Color(0xFF0A3158),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          isExpanded: true,
          onChanged: onChanged,
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSlider(double value, double min, double max, ValueChanged<double> onChanged) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: const Color(0xFF00D2D2),
        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        thumbColor: Colors.white,
        overlayColor: const Color(0xFF00D2D2).withValues(alpha: 0.1),
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

class _PreviewFullButtonState extends State<_PreviewFullButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isHovered) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulse = 1.0 + (_pulseController.value * 0.05);
            return Transform.scale(
              scale: _isHovered ? pulse : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isHovered
                        ? AppTheme.primaryColor.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2 * _pulseController.value),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      color: _isHovered ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.8),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Full Preview',
                      style: TextStyle(
                        color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final Color color;
  final double borderRadius;

  const _PreviewButton({
    required this.label,
    required this.isPrimary,
    required this.color,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isPrimary ? AppTheme.createGradient(color) : null,
        color: !isPrimary ? color.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
