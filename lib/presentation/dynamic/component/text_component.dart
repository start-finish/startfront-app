import 'package:flutter/material.dart';

import '../data/helper.dart';

textComponent({required data}) {
  final property = data.properties;

  return Text(
    property['text'] ?? 'Default Text',
    maxLines: property['maxLines'] ?? 1,
    style: TextStyle(
      fontSize: (property['fontSize'] as num?)?.toDouble() ?? 14.0,
      color: property['color'] ?? Colors.black,
      fontWeight: parseFontWeight(property['fontWeight']),
      overflow: property['overflow'] ?? TextOverflow.ellipsis,
    ),
    softWrap: property['softWrap'] ?? false,
  );
}
