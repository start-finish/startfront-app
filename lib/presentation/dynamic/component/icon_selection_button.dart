// Path: lib/dynamic_widgets/component/icon_selection_button.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/helpers/icon_list.dart'; // Icon helpers
import '../data/data.dart'; // DynamicWidgetData
import 'icon_selection_component.dart'; // The selector screen

/// A button used in the property editor to launch the Icon Selection Screen.
/// It updates the target DynamicWidgetData object directly.
class IconSelectionButton extends StatelessWidget {
  final DynamicWidgetData targetData;
  final String propertyKey;
  final String label;

  const IconSelectionButton({
    super.key,
    required this.targetData,
    required this.propertyKey,
    required this.label,
  });

  String get _currentIconKey => targetData.properties[propertyKey] as String? ?? 'help_outline';
  IconData get _currentIconData => keyToIconData(_currentIconKey);

  void _openIconSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IconSelectionComponent(
          onIconSelected: (iconKey) {
            // Use the target widget's own updater method to change its property
            targetData.updateProperty(
              propertyKey, 
              iconKey, // This serializable string is saved
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obx reacts to changes in targetData.properties[propertyKey]
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: () => _openIconSelector(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            alignment: Alignment.centerLeft,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          icon: Icon(_currentIconData, color: Theme.of(context).colorScheme.onSurfaceVariant),
          label: Text(
            '$label: ${StringExtension(_currentIconKey).capitalizeFirst}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    });
  }
}

extension StringExtension on String {
  String get capitalizeFirst =>
      this.isEmpty ? this : this[0].toUpperCase() + this.substring(1);
}