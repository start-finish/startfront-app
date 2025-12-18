import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

Widget dropdownComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  final items = List<String>.from(property['items'] ?? []);
  final hint = property['hintText'] ?? 'Select';
  final controllerKey = property['controllerKey'];
  final onChanged = property['onChanged'];
  var initialValue = property['initialValue'] as String?;
  final enableSearch = property['enableSearch'] ?? true;

  if (!items.contains(initialValue)) {
    initialValue = items.isNotEmpty ? items[0] : null;
  }

  // Get or create controller
  final controller = controllerKey != null
      ? (Get.isRegistered<SingleSelectController<String>>(tag: controllerKey)
            ? Get.find<SingleSelectController<String>>(tag: controllerKey)
            : Get.put(
                SingleSelectController<String>(initialValue),
                tag: controllerKey,
              ))
      : SingleSelectController<String>(initialValue);

  final bgColor = property['backgroundColor'] ?? Colors.white;
  final borderColor = property['borderColor'] ?? Colors.grey.shade400;
  final borderWidth = (property['borderWidth'] ?? 1.0).toDouble();
  final radius = (property['radius'] ?? 6.0).toDouble();

  final dropdownDecoration = CustomDropdownDecoration(
    closedFillColor: bgColor,
    expandedBorder: Border.all(color: borderColor, width: borderWidth),
    expandedBorderRadius: BorderRadius.circular(radius),
    closedBorder: Border.all(color: borderColor, width: borderWidth),
    closedBorderRadius: BorderRadius.circular(radius),
  );

  return enableSearch
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.properties['label'] != null)
              Obx(() {
                return Text(
                  data.properties['label'],
                  style: TextStyle(
                    color: data.properties['showError'].value == true
                        ? AppTheme.error
                        : data.properties['labelColor'] ?? AppTheme.primary,
                    fontSize: 13,
                    fontWeight: data.properties['showError'].value == true
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }),
            if (data.properties['label'] != null) const SizedBox(height: 4),
            IntrinsicWidth(
              stepWidth: (property['width'] as num?)?.toDouble(),
              child: CustomDropdown<String>.search(
                hintText: hint,
                items: items,
                controller: controller,
                onChanged: (value) {
                  if (onChanged is Function) onChanged(value);
                },
                decoration: dropdownDecoration,
              ),
            ),
          ],
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.properties['label'] != null)
              Obx(() {
                return Text(
                  data.properties['label'],
                  style: TextStyle(
                    color: data.properties['showError'].value == true
                        ? AppTheme.error
                        : data.properties['labelColor'] ?? AppTheme.primary,
                    fontSize: 13,
                    fontWeight: data.properties['showError'].value == true
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }),
            if (data.properties['label'] != null) const SizedBox(height: 4),
            IntrinsicWidth(
              stepWidth: (property['width'] as num?)?.toDouble(),
              child: CustomDropdown<String>(
                closedHeaderPadding: EdgeInsets.all(13),
                hintText: hint,
                items: items,
                controller: controller,
                onChanged: (value) {
                  if (onChanged is Function) onChanged(value);
                },
                decoration: dropdownDecoration,
                headerBuilder: (context, selectedItem, isExpanded) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (property['svgIcon'] != null)
                        SvgPicture.asset(
                          property['svgIcon'],
                          color: property['color'] ?? AppTheme.onBackground,
                          width: property['width'] ?? 16,
                          height: property['height'] ?? 16,
                        ),
                      if (property['svgIcon'] != null) SizedBox(width: 8),
                      Text(
                        selectedItem,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
                listItemBuilder: (context, item, isSelected, onItemSelect) {
                  return Text(item, style: TextStyle(fontSize: 13));
                },
              ),
            ),
          ],
        );
}
