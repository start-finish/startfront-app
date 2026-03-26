import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startfront_app/ui_data/home_screen_data.dart';
import 'package:startfront_app/components/dynamic_ui.dart';
import 'package:startfront_app/models/ui_component.dart';

void main() {
  testWidgets('Dump layout error', (tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      print('\n\n==== FLUTTER ERROR CAUGHT ====');
      print(details.exceptionAsString());
      print('==============================\n\n');
    };
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final comp = WidgetComponent.fromJson(homeScreenData);
              return buildWidgetFromJson(comp, context);
            }
          )
        )
      )
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    
    expect(find.text('StartFront Studio'), findsOneWidget);
  });
}
