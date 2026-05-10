import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/config/flavors.dart';
import 'src/config/init.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFlavor(Flavor.uat);
  runApp(const ProviderScope(child: StartFrontApp()));
}
