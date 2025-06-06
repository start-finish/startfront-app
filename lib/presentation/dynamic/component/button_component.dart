import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../data/data.dart'; // Import your DynamicWidgetData

class HoverRippleButton extends StatefulWidget {
  final DynamicWidgetData data;

  const HoverRippleButton({super.key, required this.data});

  @override
  State<HoverRippleButton> createState() => _HoverRippleButtonState();
}

class _HoverRippleButtonState extends State<HoverRippleButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final property = widget.data.properties;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TouchRippleEffect(
        onTap: property['action'],
        rippleColor: property['rippleColor'] ?? Colors.black26,
        borderRadius: BorderRadius.circular(
          (property['radius'] as num?)?.toDouble() ?? 8.0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal:
                (property['horizontalPadding'] as num?)?.toDouble() ?? 16,
            vertical: (property['verticalPadding'] as num?)?.toDouble() ?? 8,
          ),
          decoration: BoxDecoration(
            color: isHovered
                ? property['hoverColor'] ?? property['color'] ?? Colors.white
                : property['color'] ?? Colors.white,
            borderRadius: BorderRadius.circular(
              (property['radius'] as num?)?.toDouble() ?? 8,
            ),
            border: Border.all(
              color: property['borderColor'] ?? Colors.black12,
              width: (property['borderWidth'] as num?)?.toDouble() ?? 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (property['svgIcon'] != null)
                SvgPicture.asset(
                  property['svgIcon'],
                  width: (property['iconSize'] as num?)?.toDouble() ?? 18,
                  height: (property['iconSize'] as num?)?.toDouble() ?? 18,
                  color: isHovered
                      ? property['hoverTextColor'] ??
                          property['textColor'] ??
                          Colors.red
                      : property['textColor'] ?? Colors.black,
                ),
              if (property['leadingIcon'] != null)
                Icon(
                  property['leadingIcon'] ?? Icons.settings,
                  color: property['leadingIconColor'],
                  size: property['leadingIconSize'] ?? 24.0,
                ),
              if (property['svgIcon'] != null) const SizedBox(width: 8),
              Text(
                property['title'] ?? 'Button',
                style: TextStyle(
                  color: isHovered
                      ? property['hoverTextColor'] ?? Colors.red
                      : property['textColor'] ?? Colors.black,
                  fontSize: (property['fontSize'] as num?)?.toDouble() ?? 14,
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

buttonComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  final gradientKey = property['gradient'] as String?;
  final gradient = gradientFromKey(gradientKey);

  return StatefulBuilder(builder: (context, setState) {
    final isHovered = false.obs;

    return Obx(() {
      return MouseRegion(
        onEnter: (_) {
          property['onHover'] = true;
          isHovered.value = true;
          print(isHovered);
        },
        onExit: (_) {
          property['onHover'] = false;
          isHovered.value = false;
          print(isHovered);
        },
        child: TouchRippleEffect(
          onTap: () async {
            property['action']?.call();
          },
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
          child: data.child != null
              ? DynamicWidgetFactory.createWidget(data.child!)
              : Container(
                  padding: (property['padding'] as num?)?.toDouble() != null
                      ? EdgeInsets.all(
                          (property['padding'] as num?)?.toDouble() ?? 8.0)
                      : (property['verticalPadding'] as num?)?.toDouble() !=
                                  null ||
                              (property['horizontalPadding'] as num?)
                                      ?.toDouble() !=
                                  null
                          ? EdgeInsets.symmetric(
                              vertical: (property['verticalPadding'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                              horizontal:
                                  (property['horizontalPadding'] as num?)
                                          ?.toDouble() ??
                                      0.0,
                            )
                          : EdgeInsets.only(
                              top: (property['topPadding'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                              bottom: (property['bottomPadding'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                              left: (property['leftPadding'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                              right: (property['rightPadding'] as num?)
                                      ?.toDouble() ??
                                  0.0,
                            ),
                  decoration: BoxDecoration(
                    color: gradient == null
                        ? (isHovered.value
                            ? property['hoverColor'] ?? property['color']
                            : property['color'] ?? Colors.white)
                        : null,
                    gradient: gradient,
                    border: Border.all(
                      color: property['borderColor'] ?? Colors.transparent,
                      width:
                          (property['borderWidth'] as num?)?.toDouble() ?? 0.0,
                    ),
                    borderRadius:
                        (property['radius'] as num?)?.toDouble() != null
                            ? BorderRadius.circular(
                                (property['radius'] as num?)?.toDouble() ?? 12)
                            : BorderRadius.only(
                                topLeft: Radius.circular(
                                    (property['radiusTopLeft'] as num?)
                                            ?.toDouble() ??
                                        0.0),
                                topRight: Radius.circular(
                                    (property['radiusTopRight'] as num?)
                                            ?.toDouble() ??
                                        0.0),
                                bottomLeft: Radius.circular(
                                    (property['radiusBottomLeft'] as num?)
                                            ?.toDouble() ??
                                        0.0),
                                bottomRight: Radius.circular(
                                    (property['radiusBottomRight'] as num?)
                                            ?.toDouble() ??
                                        0.0),
                              ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (property['svgIcon'] != null)
                        SvgPicture.asset(
                          property['svgIcon'],
                          color: property['svgColor'] ?? Colors.black,
                          width: property['svgSize'] ?? 18,
                          height: property['svgSize'] ?? 18,
                        ),
                      if (property['leadingIcon'] != null)
                        Icon(
                          property['leadingIcon'] ?? Icons.settings,
                          color: property['leadingIconColor'],
                          size: property['leadingIconSize'] ?? 24.0,
                        ),
                      if (property['leadingIcon'] != null ||
                          property['svgIcon'] != null)
                        SizedBox(width: 8),
                      Text(
                        property['title'] ?? 'data',
                        style: TextStyle(
                          color: isHovered.value
                              ? property['hoverTitleColor'] ?? Colors.red
                              : property['titleColor'] ?? Colors.black,
                          fontSize: property['titleSize'] ?? 14.0,
                        ),
                      ),
                      if (property['trailingIcon'] != null)
                        property['trailingIcon'] ?? SizedBox(width: 8),
                      if (property['trailingIcon'] != null)
                        property['trailingIcon'] ??
                            Icon(
                              Icons.settings,
                              color: property['trailingIconColor'],
                              size: property['trailingIconSize'] ?? 24.0,
                            ),
                    ],
                  ),
                ),
        ),
      );
    });
  });
}
