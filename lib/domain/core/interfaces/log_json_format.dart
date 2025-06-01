import 'dart:convert';
import 'dart:developer';

void logJson(dynamic data, {String name = 'Response'}) {
  try {
    // Convert data to Map or List if possible
    final jsonData = data is String ? jsonDecode(data) : data;

    final prettyString = const JsonEncoder.withIndent('  ').convert(jsonData);
    log(prettyString, name: name);
  } catch (e) {
    log('Failed to pretty print JSON: $e', name: name);
    // Fallback to just printing data as string
    log(data.toString(), name: name);
  }
}
