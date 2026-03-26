import 'package:flutter/material.dart';
import '../components/dynamic_ui.dart';
import '../models/ui_component.dart';

class DynamicUiBuilder extends StatelessWidget {
  final dynamic uiJson;

  const DynamicUiBuilder({
    super.key,
    required this.uiJson,
  });

  @override
  Widget build(BuildContext context) {
    if (uiJson == null) {
      return const Center(
        child: Text('UI Data not found for this screen.'),
      );
    }

    try {
      if (uiJson is List) {
        final components = uiJson
            .map(
              (json) => WidgetComponent.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return ListView(
          children: components
              .map((component) => buildWidgetFromJson(component, context))
              .toList(),
        );
      } else {
        // If it's a single object, just build it directly to avoid unbounded layout errors
        final component = WidgetComponent.fromJson(uiJson as Map<String, dynamic>);
        return buildWidgetFromJson(component, context);
      }
    } catch (e) {
      // This catches the "Null is not a subtype of String" error gracefully
      return Center(child: Text('Data Parsing Error: $e'));
    }
  }
}
