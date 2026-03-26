import 'package:flutter_test/flutter_test.dart';
import 'package:startfront_app/models/ui_component.dart';
import 'package:startfront_app/ui_data/screens.dart';

void main() {
  test('parsing', () {
    final data = screenRegistry['profile_screen'];
    print(data);
    final comp = WidgetComponent.fromJson(data!);
    print('Parsed: \${comp.type}');
  });
}
