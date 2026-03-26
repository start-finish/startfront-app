import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startfront_app/screens/dynamic_screen.dart';
import 'package:startfront_app/models/ui_component.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => DynamicScreen(
            routeName: settings.name ?? '/',
          ),
        );
      },
    )));
    
    // Wait for the DynamicScreen's FutureProvider to load the UI
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    
    // Pump and wait for the ApiService FutureBuilder to finish.
    // We avoid pumpAndSettle here because FutureBuilder + Animations might cause it to timeout
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    
    expect(find.text('StartFront Studio'), findsOneWidget);
    
    // expect(find.text('StartFront Studio'), findsOneWidget);
    expect(find.text('Widget Palette'), findsOneWidget);
    
    // We should see the API Palette items fetched
    expect(find.text('Button'), findsOneWidget);
    expect(find.text('Text Widget'), findsOneWidget);
    
    // Test Drag and Drop from the Palette
    final draggableFinder = find.text('Button');
    
    // Our DragTarget is the only DragTarget on screen, bounded by the Center Canvas
    final targetFinder = find.byType(DragTarget<WidgetComponent>);
    
    expect(draggableFinder, findsOneWidget);
    expect(targetFinder, findsOneWidget);

    await tester.drag(draggableFinder, tester.getCenter(targetFinder) - tester.getCenter(draggableFinder));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    
    // SnackBar appears showing added logic
    expect(find.text('Added ElevatedButton Component to drop zone'), findsOneWidget);
    
    // The Button itself should now appear *twice*: 
    // Once in the left palette, and once inside the drop zone canvas
    expect(find.text('Button'), findsNWidgets(2));
  });
}
