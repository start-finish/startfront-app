import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../../app/helpers/icon_list.dart';
import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart'; // Import your DynamicWidgetData

class HoverRippleButton extends StatefulWidget {
  final DynamicWidgetData data;

  const HoverRippleButton({super.key, required this.data});

  @override
  State<HoverRippleButton> createState() => _HoverRippleButtonState();
}

class _HoverRippleButtonState extends State<HoverRippleButton> {
  bool isHovered = false;

  DynamicWidgetData injectIsHoverRecursively(
    DynamicWidgetData data,
    bool isHover,
  ) {
    return DynamicWidgetData(
      type: data.type,
      properties: {...data.properties, 'isHover': isHover},
      child: data.child != null
          ? injectIsHoverRecursively(data.child!, isHover)
          : null,
      children: data.children
          .map((child) => injectIsHoverRecursively(child, isHover))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.data.properties;

    // --- ICON KEY READING AND CONVERSION ---
    final defaultIconKey = property['iconKey'] as String?;
    final hoverIconKey = property['hoverIconKey'] as String?;

    // Convert keys to IconData. Note: keyToIconData returns a default if null/invalid.
    final defaultIconDataFromKey = keyToIconData(defaultIconKey);
    final hoverIconDataFromKey = keyToIconData(hoverIconKey);

    // --- OLD ICON PROPERTY READING (Direct IconData Object) ---
    final defaultIconDataOld = property['icon'] as IconData?;
    final hoverIconDataOld = property['hoverIcon'] as IconData?;

    // --- FALLBACK LOGIC ---
    // 1. Get the current IconData to display (based on hover state)
    IconData? currentIconData;

    if (isHovered) {
      // Preference: 1. New key -> 2. Old property -> 3. Default fallback
      if (defaultIconKey != null) {
        currentIconData = hoverIconDataFromKey;
      } else {
        currentIconData = hoverIconDataOld;
      }
    } else {
      // Preference: 1. New key -> 2. Old property -> 3. Default fallback
      if (defaultIconKey != null) {
        currentIconData = defaultIconDataFromKey;
      } else {
        currentIconData = defaultIconDataOld;
      }
    }

    // Fallback to a guaranteed default if all properties are null
    currentIconData ??= Icons.settings;
    // ----------------------------------------------

    final gradientKey = property['gradient'] as String?;
    final gradient = gradientFromKey(gradientKey);

    final isButton = property['isButton'] ?? false;
    final isExpanded = property['isExpanded'] ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TouchRippleEffect(
        onTap: property['action'],
        rippleColor: property['rippleColor'] ?? Colors.white24,
        borderRadius: property['radius'] == null
            ? BorderRadius.only(
                topLeft: Radius.circular(property['radiusTopLeft'] ?? 0.0),
                topRight: Radius.circular(property['radiusTopRight'] ?? 0.0),
                bottomLeft: Radius.circular(
                  property['radiusBottomLeft'] ?? 0.0,
                ),
                bottomRight: Radius.circular(
                  property['radiusBottomRight'] ?? 0.0,
                ),
              )
            : BorderRadius.circular(
                (property['radius'] as num?)?.toDouble() ?? 12,
              ),
        child: AnimatedContainer(
          width: isExpanded ? double.infinity : property['width'],
          height: property['height'],
          duration: const Duration(milliseconds: 150),
          padding: (property['padding'] as num?)?.toDouble() != null
              ? EdgeInsets.all((property['padding'] as num?)?.toDouble() ?? 8.0)
              : (property['verticalPadding'] as num?)?.toDouble() != null ||
                    (property['horizontalPadding'] as num?)?.toDouble() != null
              ? EdgeInsets.symmetric(
                  vertical:
                      (property['verticalPadding'] as num?)?.toDouble() ?? 0.0,
                  horizontal:
                      (property['horizontalPadding'] as num?)?.toDouble() ??
                      0.0,
                )
              : EdgeInsets.only(
                  top: (property['topPadding'] as num?)?.toDouble() ?? 0.0,
                  bottom:
                      (property['bottomPadding'] as num?)?.toDouble() ?? 0.0,
                  left: (property['leftPadding'] as num?)?.toDouble() ?? 0.0,
                  right: (property['rightPadding'] as num?)?.toDouble() ?? 0.0,
                ),
          decoration: BoxDecoration(
            color: gradient == null
                ? isHovered
                      ? property['hoverColor'] ??
                            (property['color'] ?? AppTheme.secondary)
                                .withOpacity(0.8)
                      : property['color'] ?? Colors.transparent
                : null,
            gradient: gradient,
            borderRadius: property['radius'] == null
                ? BorderRadius.only(
                    topLeft: Radius.circular(property['radiusTopLeft'] ?? 0.0),
                    topRight: Radius.circular(
                      property['radiusTopRight'] ?? 0.0,
                    ),
                    bottomLeft: Radius.circular(
                      property['radiusBottomLeft'] ?? 0.0,
                    ),
                    bottomRight: Radius.circular(
                      property['radiusBottomRight'] ?? 0.0,
                    ),
                  )
                : BorderRadius.circular(
                    (property['radius'] as num?)?.toDouble() ?? 12,
                  ),
            border: Border.all(
              color: isHovered
                  ? property['hoverBorderColor'] ??
                        property['color'] ??
                        Colors.transparent
                  : property['borderColor'] ?? Colors.transparent,
              width: isHovered
                  ? (property['hoverBorderWidth'] as num?)?.toDouble() ?? 1
                  : (property['borderWidth'] as num?)?.toDouble() ?? 0,
            ),
          ),
          child: widget.data.child != null
              ? DynamicWidgetFactory.createWidget(widget.data.child!)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (property['svgIcon'] != null)
                      SvgPicture.asset(
                        property['svgIcon'],
                        width: isHovered
                            ? (property['hoverSvgIconSize'] as num?)
                                      ?.toDouble() ??
                                  20
                            : (property['svgIconSize'] as num?)?.toDouble() ??
                                  20,
                        height: isHovered
                            ? (property['hoverSvgIconSize'] as num?)
                                      ?.toDouble() ??
                                  20
                            : (property['svgIconSize'] as num?)?.toDouble() ??
                                  20,
                        color: isHovered
                            ? property['hoverSvgIconColor'] ??
                                  property['svgIconColor'] ??
                                  AppTheme.onPrimary
                            : property['svgIconColor'] ?? AppTheme.onPrimary,
                      ),

                    // --- COMBINED ICON WIDGET USAGE ---
                    // Render the Icon if EITHER the new key OR the old property exists
                    if (defaultIconKey != null || defaultIconDataOld != null)
                      Icon(
                        currentIconData, // Use the resolved icon
                        color: isHovered
                            ? property['hoverIconColor'] ??
                                  property['iconColor'] ??
                                  AppTheme.onPrimary
                            : property['iconColor'] ?? AppTheme.onPrimary,
                        size: property['iconSize'] ?? 24.0,
                      ),

                    if (property['icon'] != null)
                      Icon(
                        isHovered
                            ? property['hoverIcon'] ?? Icons.settings
                            : property['icon'] ?? Icons.settings,
                        color: isHovered
                            ? property['hoverIconColor'] ??
                                  property['iconColor'] ??
                                  AppTheme.onPrimary
                            : property['iconColor'] ?? AppTheme.onPrimary,
                        size: property['iconSize'] ?? 24.0,
                      ),
                    if (!isButton)
                      if (property['svgIcon'] != null ||
                          property['icon'] != null)
                        const SizedBox(width: 8),
                    if (!isButton)
                      Text(
                        property['title'] ?? 'Button',
                        style: TextStyle(
                          color: isHovered
                              ? property['hoverTextColor'] ??
                                    property['textColor'] ??
                                    AppTheme.onPrimary
                              : property['textColor'] ?? AppTheme.onBackground,
                          fontSize: isHovered
                              ? (property['hoverFontSize'] ??
                                            property['fontSize'] as num?)
                                        ?.toDouble() ??
                                    14
                              : (property['fontSize'] as num?)?.toDouble() ??
                                    14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
