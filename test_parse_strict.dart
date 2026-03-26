import 'package:startfront_app/models/ui_component.dart';
import 'package:startfront_app/ui_data/screens.dart';

void main() {
  try {
    for (var key in screenRegistry.keys) {
      final data = screenRegistry[key];
      final comp = WidgetComponent.fromJson(data!);
      print('Parsed \${key}: \${comp.type}');
      comp.children?.forEach((child) {
        print('  - \${child.type}');
      });
    }
    print("All success!");
  } catch (e, stack) {
    print('Error: \$e');
    print(stack);
  }
}
