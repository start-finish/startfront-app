import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../config.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  Future<void> connectWebSocket(String endpointPath) async {
    final String baseUrl = ConfigEnvironments.getEnvironments()['wsUrl']!;
    final String fullUrl = '$baseUrl/$endpointPath';

    _channel = WebSocketChannel.connect(Uri.parse(fullUrl));
  }

  Stream<dynamic> get stream => _channel!.stream;

  void sendMessage(Map<String, dynamic> message) {
    final String jsonString = jsonEncode(message);
    _channel?.sink.add(jsonString);
  }

  void closeConnection() {
    _channel?.sink.close();
  }
}
