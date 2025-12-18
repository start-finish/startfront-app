import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../editor/controllers/editor.controller.dart';
import '../data/data.dart';
import '../data/factory.dart';

Widget dropComponent({
  required DynamicWidgetData data,
  void Function(DynamicWidgetData accepted)? onAccept,
}) {
  return _DropArea(data: data, onAccept: onAccept);
}

class _DropArea extends StatefulWidget {
  const _DropArea({
    required this.data,
    this.onAccept,
  });

  final DynamicWidgetData data;
  final void Function(DynamicWidgetData accepted)? onAccept;

  @override
  State<_DropArea> createState() => _DropAreaState();
}

class _DropAreaState extends State<_DropArea> {
  final RxBool _highlight = false.obs; // Use RxBool for GetX reactive state
  final editor = Get.find<EditorController>(); // shared store

  @override
  Widget build(BuildContext context) {
    final props = widget.data.properties;
    final placeholderText = (props['placeholder'] as String?) ?? 'Drop here';
    final padding = (props['padding'] as num?)?.toDouble() ?? 12.0;
    final radius = (props['radius'] as num?)?.toDouble() ?? 12.0;
    final Color bg =
        (props['color'] is Color) ? props['color'] as Color : Colors.white;
    final Color borderColor = (props['borderColor'] is Color)
        ? props['borderColor'] as Color
        : Colors.grey.withOpacity(0.6);
    final double borderWidth =
        (props['borderWidth'] as num?)?.toDouble() ?? 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: _highlight.value
            ? bg.withOpacity(0.96)
            : bg, // Use .value to access RxBool
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: _highlight.value
              ? Theme.of(context).colorScheme.primary
              : borderColor,
          width: _highlight.value ? (borderWidth + 0.5) : borderWidth,
        ),
      ),
      child: DragTarget<DynamicWidgetData>(
        onWillAccept: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _highlight.value = true; // Update using GetX after the build phase
          });
          return true;
        },
        onLeave: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _highlight.value = false; // Update using GetX after the build phase
          });
        },
        onAccept: (accepted) {
          // Call the onAccept callback and pass the accepted widget
          widget.onAccept?.call(accepted);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _highlight.value = false; // Update using GetX after the build phase
          });
        },
        builder: (context, candidate, rejected) {
          return Obx(() {
            final items = editor.droppedWidgets;
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    placeholderText,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            }
            return Obx(() {
              return SingleChildScrollView(
                child: SizedBox(
                  height: Get.height,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: editor.droppedWidgets
                        .map((e) => DynamicWidgetFactory.createWidget(e))
                        .toList(),
                  ),
                ),
              );
            });
          });
        },
      ),
    );
  }
}
