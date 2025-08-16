import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/data.dart';

/// Usage:
/// dropComponent(
///   data: DynamicWidgetData(
///     type: 'DropArea',
///     properties: {
///       'placeholder': 'Drop widgets here',
///       'padding': 12.0,
///       'radius': 12.0,
///       'color': Colors.white,
///       'borderColor': Colors.grey,
///       'borderWidth': 1.0,
///     },
///   ),
///   onAccept: (widgetData) => print('Accepted: ${widgetData.type}'),
/// )
Widget dropComponent({
  required DynamicWidgetData data,
  void Function(DynamicWidgetData accepted)? onAccept,
}) {
  return _DropArea(data: data, onAccept: onAccept);
}

class _DropArea extends StatefulWidget {
  const _DropArea({
    Key? key,
    required this.data,
    this.onAccept,
  }) : super(key: key);

  final DynamicWidgetData data;
  final void Function(DynamicWidgetData accepted)? onAccept;

  @override
  State<_DropArea> createState() => _DropAreaState();
}

class _DropAreaState extends State<_DropArea> {
  final List<DynamicWidgetData> _dropped = [];
  bool _highlight = false;

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
        color: _highlight ? bg.withOpacity(0.96) : bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color:
              _highlight ? Theme.of(context).colorScheme.primary : borderColor,
          width: _highlight ? (borderWidth + 0.5) : borderWidth,
        ),
      ),
      child: DragTarget<DynamicWidgetData>(
        onWillAccept: (data) {
          setState(() => _highlight = true);
          return true; // accept any DynamicWidgetData
        },
        onLeave: (data) {
          setState(() => _highlight = false);
        },
        onAccept: (accepted) {
          setState(() {
            _dropped.add(accepted);
            _highlight = false;
          });
          widget.onAccept?.call(accepted);
          print(_dropped);
        },
        builder: (context, candidate, rejected) {
          if (_dropped.isEmpty) {
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

          // Render dropped dynamic widgets
          return Container(
            height: Get.height,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dropped.map((e) {
                // If you use a factory: DynamicWidgetFactory.createWidget(e)
                // If your model has a helper: e.toWidget()
                return e.toWidget();
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
