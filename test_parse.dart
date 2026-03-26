import 'package:flutter/material.dart';
import 'lib/models/ui_component.dart';
import 'lib/ui_data/screens.dart';

void main() {
  try {
    final data = screenRegistry['profile_screen'];
    print(data);
    final comp = WidgetComponent.fromJson(data!);
    print('Parsed: \${comp.type}');
  } catch (e, stack) {
    print('Error: \$e');
    print(stack);
  }
}
