import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../ui_data/home_screen_data.dart';
import '../ui_data/profile_screen_data.dart';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Generic internal method to handle all API calls with standard error handling
  Future<ApiResponse<T>> _callApi<T>(
    String msgId, {
    Map<String, dynamic>? params,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      // Create the common request body with msgId
      final requestBody = {
        'msgId': msgId,
        'data': params ?? {},
      };

      // In a real scenario, this would be a POST call to a single endpoint
      // For this mock, we'll demonstrate the structure
      final response = await http.post(
        Uri.parse(_baseUrl), // Using baseUrl as the single entry point
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final apiResponse = ApiResponse<T>.fromJson(
          decoded,
          fromJsonT ?? (data) => data as T,
        );

        if (!apiResponse.isSuccess) {
          // Centralized business logic error handling
          print('API Error [$msgId]: ${apiResponse.errorMessage}');
          // You could throw a specialized exception here or handle it based on errorCode
        }

        return apiResponse;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Centralized technical error handling (network, timeout, etc.)
      print('Network/Technical Error [$msgId]: $error');
      return ApiResponse<T>(
        msgId: msgId,
        errorCode: 'CONNECT_ERROR',
        errorMessage: error.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> fetchScreenUi(String routeName) async {
    // In a real system, we would use _callApi('GET_SCREEN_UI', params: {'route': routeName})
    // For now, we simulate the async call and return the existing mock data
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Fallback to the registry for now while we transition
    final registry = {
      '/': homeScreenData,
      'profile_screen': profileScreenData,
    };
    
    return registry[routeName] ?? {};
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    // Legacy support or updated to use the new system
    final response = await _callApi<Map<String, dynamic>>(
      'FETCH_USER_DATA',
      params: {'id': 1},
    );
    
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.errorMessage ?? 'Failed to load user data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPaletteWidgets() async {
    // Current palette fetching logic
    // In a real system, this would call _callApi('GET_WIDGET_PALETTE')
    await Future.delayed(const Duration(milliseconds: 0));

    return [
      {
        "type": "Button",
        "label": "Button",
        "icon": "smart_button",
        "dragData": "ElevatedButton Component"
      },
      {
        "type": "Text",
        "text": "Text Widget",
        "icon": "text_fields",
        "dragData": "Text Component"
      },
      {
        "type": "Column",
        "text": "Column Layout",
        "icon": "view_column",
        "dragData": "Column Component"
      },
      {
        "type": "Row",
        "text": "Row Layout",
        "icon": "table_rows",
        "dragData": "Row Component"
      },
      {
        "type": "Image",
        "text": "Image",
        "icon": "image",
        "dragData": "Image Component"
      },
      {
        "type": "TextField",
        "hint": "Text Field",
        "icon": "input",
        "dragData": "TextField Component"
      }
    ];
  }
}
