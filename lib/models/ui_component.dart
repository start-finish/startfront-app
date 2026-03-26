import 'package:json_annotation/json_annotation.dart';

part 'ui_component.g.dart';

@JsonSerializable()
class WidgetComponent {
  final String? type; // Type of widget like Text, Button, Column, etc.
  final String? text; // For Text widget
  final String? label; // For Button widget
  final String? hint; // For TextField widget
  final List<WidgetComponent>? children; // Children for Column, Row, etc.
  final String? route; // Route for navigation
  
  // New styling & layout properties
  final String? color;
  final double? fontSize;
  final String? fontWeight;
  final double? padding;
  final double? width;
  final double? height;
  final String? alignment;
  final String? mainAxisAlignment;
  final String? crossAxisAlignment;
  final String? url; // For Image widget
  final String? icon; // For Icon widget
  final WidgetComponent? child; // For single-child widgets like Container, Center, Padding
  final String? dragData; // For Draggable widget

  WidgetComponent({
    required this.type,
    this.text,
    this.label,
    this.hint,
    this.children,
    this.route,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.url,
    this.icon,
    this.child,
    this.dragData,
  });

  factory WidgetComponent.fromJson(Map<String, dynamic> json) =>
      _$WidgetComponentFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetComponentToJson(this);
}
