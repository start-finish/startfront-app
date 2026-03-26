import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadJsonFromAsset(String filePath) async {
  final jsonString = await rootBundle.loadString(filePath);
  return json.decode(jsonString);
}
