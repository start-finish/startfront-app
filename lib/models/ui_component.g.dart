// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetComponent _$WidgetComponentFromJson(Map<String, dynamic> json) =>
    WidgetComponent(
      type: json['type'] as String?,
      text: json['text'] as String?,
      label: json['label'] as String?,
      hint: json['hint'] as String?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => WidgetComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      route: json['route'] as String?,
      color: json['color'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: json['fontWeight'] as String?,
      padding: (json['padding'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      alignment: json['alignment'] as String?,
      mainAxisAlignment: json['mainAxisAlignment'] as String?,
      crossAxisAlignment: json['crossAxisAlignment'] as String?,
      url: json['url'] as String?,
      icon: json['icon'] as String?,
      child: json['child'] == null
          ? null
          : WidgetComponent.fromJson(json['child'] as Map<String, dynamic>),
      dragData: json['dragData'] as String?,
    );

Map<String, dynamic> _$WidgetComponentToJson(WidgetComponent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'label': instance.label,
      'hint': instance.hint,
      'children': instance.children,
      'route': instance.route,
      'color': instance.color,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'padding': instance.padding,
      'width': instance.width,
      'height': instance.height,
      'alignment': instance.alignment,
      'mainAxisAlignment': instance.mainAxisAlignment,
      'crossAxisAlignment': instance.crossAxisAlignment,
      'url': instance.url,
      'icon': instance.icon,
      'child': instance.child,
      'dragData': instance.dragData,
    };
