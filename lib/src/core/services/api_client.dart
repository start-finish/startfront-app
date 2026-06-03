import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../config/env.dart';

class ApiClient {
  final String _baseUrl;
  final bool _enableLogging;

  ApiClient({required String baseUrl, required bool enableLogging})
    : _baseUrl = baseUrl,
      _enableLogging = enableLogging;

  /// Performs a POST request to `/api/startProcess` with the given [msgId] and [data].
  Future<dynamic> post(String msgId, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/api/startProcess');
    final payload = {
      'msgId': msgId,
      'data': data,
    };
    const encoder = JsonEncoder.withIndent('  ');

    if (_enableLogging) {
      final prettyPayload = encoder.convert(payload);
      developer.log('API Request -> $msgId to $url\nPayload:\n$prettyPayload');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (_enableLogging) {
        String prettyBody = response.body;
        try {
          final decoded = jsonDecode(response.body);
          prettyBody = encoder.convert(decoded);
        } catch (_) {}
        developer.log('API Response -> $msgId\nStatus: ${response.statusCode}\nBody:\n$prettyBody');
      }

      if (response.statusCode >= 400) {
        Map<String, dynamic>? errorJson;
        try {
          errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        final errorMessage = errorJson?['error'] ?? 'Server error occurred (status ${response.statusCode})';
        throw Exception(errorMessage);
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      // Check response structure for success or error keys
      if (responseBody['status'] == 'error' || responseBody['code'] != '0') {
        throw Exception(responseBody['error'] ?? 'API transaction failed');
      }

      return responseBody['data'];
    } catch (e) {
      if (_enableLogging) {
        developer.log('API Exception -> $msgId: $e');
      }
      rethrow;
    }
  }

  /// Performs a POST request and returns the full response (including metadata).
  Future<Map<String, dynamic>> postFull(String msgId, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/api/startProcess');
    final payload = {
      'msgId': msgId,
      'data': data,
    };
    const encoder = JsonEncoder.withIndent('  ');

    if (_enableLogging) {
      final prettyPayload = encoder.convert(payload);
      developer.log('API Request (Full) -> $msgId to $url\nPayload:\n$prettyPayload');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (_enableLogging) {
        String prettyBody = response.body;
        try {
          final decoded = jsonDecode(response.body);
          prettyBody = encoder.convert(decoded);
        } catch (_) {}
        developer.log('API Response (Full) -> $msgId\nStatus: ${response.statusCode}\nBody:\n$prettyBody');
      }

      if (response.statusCode >= 400) {
        Map<String, dynamic>? errorJson;
        try {
          errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        final errorMessage = errorJson?['error'] ?? 'Server error occurred (status ${response.statusCode})';
        throw Exception(errorMessage);
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseBody['status'] == 'error' || responseBody['code'] != '0') {
        throw Exception(responseBody['error'] ?? 'API transaction failed');
      }

      return responseBody;
    } catch (e) {
      if (_enableLogging) {
        developer.log('API Exception -> $msgId: $e');
      }
      rethrow;
    }
  }
}


/// Provider to expose the ApiClient instance to Riverpod consumers.
final apiClientProvider = Provider<ApiClient>((ref) {
  final env = ref.watch(envConfigProvider);
  return ApiClient(
    baseUrl: env.apiBaseUrl,
    enableLogging: env.enableLogging,
  );
});
