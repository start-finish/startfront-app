import 'package:flutter/material.dart';
import '../models/ui_component.dart';
import '../services/api_service.dart';

Color? _parseColor(String? colorStr) {
  if (colorStr == null) return null;
  if (colorStr.startsWith('#')) {
    final hex = colorStr.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
  }

  switch (colorStr.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'grey':
    case 'gray':
      return Colors.grey;
    case 'transparent':
      return Colors.transparent;
    default:
      return null;
  }
}

FontWeight? _parseFontWeight(String? weightStr) {
  switch (weightStr?.toLowerCase()) {
    case 'bold':
      return FontWeight.bold;
    case 'normal':
      return FontWeight.normal;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      return null;
  }
}

MainAxisAlignment _parseMainAxisAlignment(String? alignStr) {
  switch (alignStr?.toLowerCase()) {
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'center':
      return MainAxisAlignment.center;
    case 'spacebetween':
      return MainAxisAlignment.spaceBetween;
    case 'spacearound':
      return MainAxisAlignment.spaceAround;
    case 'spaceevenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

CrossAxisAlignment _parseCrossAxisAlignment(String? alignStr) {
  switch (alignStr?.toLowerCase()) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'center':
      return CrossAxisAlignment.center;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
    default:
      return CrossAxisAlignment.center;
  }
}

AlignmentGeometry? _parseAlignment(String? alignStr) {
  switch (alignStr?.toLowerCase()) {
    case 'topleft':
      return Alignment.topLeft;
    case 'topcenter':
      return Alignment.topCenter;
    case 'topright':
      return Alignment.topRight;
    case 'centerleft':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'centerright':
      return Alignment.centerRight;
    case 'bottomleft':
      return Alignment.bottomLeft;
    case 'bottomcenter':
      return Alignment.bottomCenter;
    case 'bottomright':
      return Alignment.bottomRight;
    default:
      return null;
  }
}

IconData _parseIcon(String? iconStr) {
  switch (iconStr?.toLowerCase()) {
    case 'home':
      return Icons.home;
    case 'star':
      return Icons.star;
    case 'settings':
      return Icons.settings;
    case 'person':
      return Icons.person;
    case 'search':
      return Icons.search;
    case 'add':
      return Icons.add;
    default:
      return Icons.help_outline; // Default
  }
}

Widget buildWidgetFromJson(WidgetComponent component, BuildContext context) {
  switch (component.type) {
    case 'Column':
      return Column(
        mainAxisAlignment: _parseMainAxisAlignment(component.mainAxisAlignment),
        crossAxisAlignment:
            _parseCrossAxisAlignment(component.crossAxisAlignment),
        children: (component.children ?? [])
            .map((child) => buildWidgetFromJson(child, context))
            .toList(),
      );
    case 'Row':
      return Row(
        mainAxisAlignment: _parseMainAxisAlignment(component.mainAxisAlignment),
        crossAxisAlignment:
            _parseCrossAxisAlignment(component.crossAxisAlignment),
        children: (component.children ?? [])
            .map((child) => buildWidgetFromJson(child, context))
            .toList(),
      );
    case 'Text':
      return Text(
        component.text ?? '',
        style: TextStyle(
          color: _parseColor(component.color),
          fontSize: component.fontSize,
          fontWeight: _parseFontWeight(component.fontWeight),
        ),
      );
    case 'TextField':
      return TextField(
        decoration: InputDecoration(
          hintText: component.hint,
        ),
      );
    case 'Button':
      return ElevatedButton(
        onPressed: () {
          if (component.route != null) {
            Navigator.pushNamed(context, component.route!);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _parseColor(component.color),
        ),
        child: Text(
          component.label ?? 'Button',
          style: TextStyle(
            fontSize: component.fontSize,
            fontWeight: _parseFontWeight(component.fontWeight),
          ),
        ),
      );
    case 'Container':
      return Container(
        width: component.width,
        height: component.height,
        padding: component.padding != null
            ? EdgeInsets.all(component.padding!)
            : null,
        alignment: _parseAlignment(component.alignment),
        color: _parseColor(component.color),
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : null,
      );
    case 'SizedBox':
      return SizedBox(
        width: component.width,
        height: component.height,
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : null,
      );
    case 'Padding':
      return Padding(
        padding: EdgeInsets.all(component.padding ?? 0.0),
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : null,
      );
    case 'Center':
      return Center(
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : null,
      );
    case 'Expanded':
      return Expanded(
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : const SizedBox.shrink(),
      );
    case 'Icon':
      return Icon(
        _parseIcon(component.icon),
        color: _parseColor(component.color),
        size: component
            .fontSize, // Using fontSize property for icon size generically
      );
    case 'Image':
      if (component.url != null) {
        return Image.network(
          component.url!,
          width: component.width,
          height: component.height,
          fit: BoxFit.cover,
        );
      }
      return const SizedBox.shrink();
    case 'Draggable':
      return Draggable<WidgetComponent>(
        data: component,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.7,
            child: component.child != null
                ? buildWidgetFromJson(component.child!, context)
                : const Icon(Icons.drag_indicator),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: component.child != null
              ? buildWidgetFromJson(component.child!, context)
              : const Icon(Icons.drag_indicator),
        ),
        child: component.child != null
            ? buildWidgetFromJson(component.child!, context)
            : const Icon(Icons.drag_indicator),
      );
    case 'ApiPalette':
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService().fetchPaletteWidgets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No widgets available'));
          }

          final widgets = snapshot.data!
              .map((json) => WidgetComponent.fromJson(json))
              .toList();

          return ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              final widgetComponent = widgets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Draggable<WidgetComponent>(
                  data: widgetComponent,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_parseIcon(widgetComponent.icon), color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(widgetComponent.text ?? widgetComponent.label ?? widgetComponent.type ?? '', style: const TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 200, // Fixed width here prevents unbounded layout errors during tests
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B323F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Make row size exactly as needed
                      children: [
                        Icon(_parseIcon(widgetComponent.icon), color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(child: Text(
                          widgetComponent.text ?? widgetComponent.label ?? widgetComponent.type ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    case 'ListView':
      return ListView(
        children: (component.children ?? [])
            .map((child) => buildWidgetFromJson(child, context))
            .toList(),
      );
    case 'DragTarget':
      return DynamicDragTarget(component: component);
    default:
      return const SizedBox.shrink(); // Default fallback
  }
}

class DynamicDragTarget extends StatefulWidget {
  final WidgetComponent component;
  const DynamicDragTarget({super.key, required this.component});

  @override
  State<DynamicDragTarget> createState() => _DynamicDragTargetState();
}

class _DynamicDragTargetState extends State<DynamicDragTarget> {
  final List<WidgetComponent> _droppedChildren = [];

  @override
  void initState() {
    super.initState();
    if (widget.component.child != null) {
      _droppedChildren.add(widget.component.child!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<WidgetComponent>(
      onAcceptWithDetails: (details) {
        setState(() {
          _droppedChildren.add(details.data);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Added ${details.data.dragData} to drop zone')),
        );
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  candidateData.isNotEmpty ? Colors.green : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: _droppedChildren.isEmpty
              ? const SizedBox(width: 50, height: 50)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _droppedChildren
                      .map((child) => buildWidgetFromJson(child, context))
                      .toList(),
                ),
        );
      },
    );
  }
}
