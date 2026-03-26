import 'package:flutter/material.dart';
import 'package:startfront_app/ui_data/home_screen_data.dart';
import 'package:startfront_app/components/dynamic_ui.dart';
import 'package:startfront_app/models/ui_component.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          try {
            final comp = WidgetComponent.fromJson(homeScreenData);
            return buildWidgetFromJson(comp, context);
          } catch (e, stack) {
            print('ERROR CAUGHT: $e\n$stack');
            return Text('ERROR: $e');
          }
        }
      )
    )
  ));
}
