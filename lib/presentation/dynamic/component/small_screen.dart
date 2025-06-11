import 'package:flutter/material.dart';

smallScreen() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth <= 640;

      return Center(child: Text('${constraints.maxWidth}'));
    },
  );
}
