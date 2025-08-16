import 'package:flutter/material.dart';
import '../data/data.dart';

Widget dragComponent({required DynamicWidgetData data}) {
  final props = data.properties;
  final List<dynamic> raw = (props['dragList'] as List?) ?? const [];
  // Ensure they are DynamicWidgetData
  final List<DynamicWidgetData> items = raw.cast<DynamicWidgetData>();

  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items.map((d) {
      // What you drag onto the canvas:
      final dragData = d;

      // Visuals for the palette tile:
      final tile = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
        ),
        child: Text(
          d.properties['title'] ?? d.type,
          style: const TextStyle(fontSize: 13),
        ),
      );

      return Draggable<DynamicWidgetData>(
        data: dragData, // <- this is what your DragTarget receives
        feedback: Material(
          color: Colors.transparent,
          child: tile,
        ),
        childWhenDragging: Opacity(opacity: 0.5, child: tile),
        child: tile,
      );
    }).toList(),
  );
}
