import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/config/flavors.dart';
import 'src/config/init.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const flavorStr = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  final flavor = Flavor.values.firstWhere(
    (f) => f.name == flavorStr,
    orElse: () => Flavor.dev,
  );
  initializeFlavor(flavor);

  runApp(const ProviderScope(child: StartFrontApp()));
}
