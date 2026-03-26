import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../builders/dynamic_ui_builder.dart';
import '../providers/ui_provider.dart';

class DynamicScreen extends ConsumerWidget {
  final String routeName;
  
  const DynamicScreen({super.key, required this.routeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lookup the correct UI definition from the Riverpod provider
    final uiAsyncValue = ref.watch(uiForRouteProvider(routeName));

    return uiAsyncValue.when(
      data: (uiJson) {
        if (uiJson == null || uiJson.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(child: Text('Screen not found for route: $routeName')),
          );
        }
        return Scaffold(
          body: DynamicUiBuilder(uiJson: uiJson),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading UI: $error')),
      ),
    );
  }
}
