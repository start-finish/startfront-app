import 'package:flutter/material.dart';

const Map<String, IconData> allMaterialIcons = {
  'face': Icons.face,
  'home': Icons.home,
  'search': Icons.search,
  'settings': Icons.settings,
  'favorite': Icons.favorite,
  'add': Icons.add,
  'delete': Icons.delete,
  'edit': Icons.edit,
  'thumb_up': Icons.thumb_up,
  'star': Icons.star,
  'check_circle': Icons.check_circle,
  'notifications': Icons.notifications,
  'info': Icons.info,
  'mail': Icons.mail,
  'phone': Icons.phone,
  'lock': Icons.lock,
  'visibility': Icons.visibility,
  'help_outline': Icons.help_outline,
};

IconData keyToIconData(String? key) {
  if (key == null || key.isEmpty) return Icons.help_outline;
  return allMaterialIcons[key] ?? Icons.help_outline;
}

String iconDataToKey(IconData data) {
  final entry = allMaterialIcons.entries.firstWhere(
    (e) => e.value == data,
    orElse: () => const MapEntry('help_outline', Icons.help_outline),
  );
  return entry.key;
}