import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

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
      DynamicWidgetData data, bool isHover) {
    return DynamicWidgetData(
      type: data.type,
      properties: {
        ...data.properties,
        'isHover': isHover,
      },
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
    final gradientKey = property['gradient'] as String?;
    final gradient = gradientFromKey(gradientKey);

    final isButton = property['isButton'] ?? false;

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
                bottomLeft:
                    Radius.circular(property['radiusBottomLeft'] ?? 0.0),
                bottomRight:
                    Radius.circular(property['radiusBottomRight'] ?? 0.0),
              )
            : BorderRadius.circular(
                (property['radius'] as num?)?.toDouble() ?? 12),
        child: AnimatedContainer(
          width: property['width'],
          height: property['height'],
          duration: const Duration(milliseconds: 150),
          padding: (property['padding'] as num?)?.toDouble() != null
              ? EdgeInsets.all((property['padding'] as num?)?.toDouble() ?? 8.0)
              : (property['verticalPadding'] as num?)?.toDouble() != null ||
                      (property['horizontalPadding'] as num?)?.toDouble() !=
                          null
                  ? EdgeInsets.symmetric(
                      vertical:
                          (property['verticalPadding'] as num?)?.toDouble() ??
                              0.0,
                      horizontal:
                          (property['horizontalPadding'] as num?)?.toDouble() ??
                              0.0,
                    )
                  : EdgeInsets.only(
                      top: (property['topPadding'] as num?)?.toDouble() ?? 0.0,
                      bottom: (property['bottomPadding'] as num?)?.toDouble() ??
                          0.0,
                      left:
                          (property['leftPadding'] as num?)?.toDouble() ?? 0.0,
                      right:
                          (property['rightPadding'] as num?)?.toDouble() ?? 0.0,
                    ),
          decoration: BoxDecoration(
            color: gradient == null
                ? isHovered
                    ? (property['hoverColor'] ?? AppTheme.secondary)
                    : property['color'] ?? Colors.transparent
                : null,
            gradient: gradient,
            borderRadius: property['radius'] == null
                ? BorderRadius.only(
                    topLeft: Radius.circular(property['radiusTopLeft'] ?? 0.0),
                    topRight:
                        Radius.circular(property['radiusTopRight'] ?? 0.0),
                    bottomLeft:
                        Radius.circular(property['radiusBottomLeft'] ?? 0.0),
                    bottomRight:
                        Radius.circular(property['radiusBottomRight'] ?? 0.0),
                  )
                : BorderRadius.circular(
                    (property['radius'] as num?)?.toDouble() ?? 12),
            border: Border.all(
              color: property['borderColor'] ?? Colors.transparent,
              width: (property['borderWidth'] as num?)?.toDouble() ?? 0,
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
                                18
                            : (property['svgIconSize'] as num?)?.toDouble() ??
                                18,
                        height: isHovered
                            ? (property['hoverSvgIconSize'] as num?)
                                    ?.toDouble() ??
                                18
                            : (property['svgIconSize'] as num?)?.toDouble() ??
                                18,
                        color: isHovered
                            ? property['hoverSvgIconColor'] ??
                                property['svgIconColor'] ??
                                AppTheme.onPrimary
                            : property['svgIconColor'] ?? AppTheme.onPrimary,
                      ),
                    if (property['icon'] != null)
                      Icon(
                        property['icon'] ?? Icons.settings,
                        color: isHovered
                            ? property['hoverIconColor'] ??
                                property['iconColor'] ??
                                AppTheme.onPrimary
                            : property['iconColor'] ?? AppTheme.onPrimary,
                        size: property['iconSize'] ?? 24.0,
                      ),
                    if (!isButton)
                      if (property['svgIcon'] != null) const SizedBox(width: 8),
                    if (!isButton)
                      Text(
                        property['title'] ?? 'Button',
                        style: TextStyle(
                          color: isHovered
                              ? property['hoverTextColor'] ??
                                  property['textColor'] ??
                                  AppTheme.onPrimary
                              : property['textColor'] ?? AppTheme.onPrimary,
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
