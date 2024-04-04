import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  List<WebSocketChannel> channels = [];
  final MAX_TOKENS = 16;

  /// Subscribes to the LTP (Last Trade Price) for the given tokens.
  Future<void> subscribeToLTP(List<int> tokens) async {
    int channel_count = (tokens.length / MAX_TOKENS).ceil();
    try{
      for (int i = 0; i < channel_count; i++) {
      final c = WebSocketChannel.connect(
          Uri.parse('ws://122.179.143.201:8089/websocket?sessionID=test&userID=test&apiToken=test'));
      channels.add(c);
      await c.ready; // Wait for the connection to be established
      print(tokens.sublist(
          MAX_TOKENS * i, min(MAX_TOKENS * (i + 1) + 1, tokens.length)));
      c.sink.add(jsonEncode({
        "Task": "subscribe",
        "Mode": "ltp",
        "Tokens": tokens.sublist(
            MAX_TOKENS * i, min(MAX_TOKENS * (i + 1) + 1, tokens.length))
      }));
    }
    }catch(e) {
      print("Error : while connecting to webhook : $e");
    }
    
  }

  void unsubscribeFromLTP(List<int> tokens) { 
    channels.forEach((c) {
      c.sink.add(
          jsonEncode({"Task": "unsubscribe", "Mode": "ltp", "Tokens": tokens}));
    });
  }

  void dispose() {
    channels.forEach((c) {
      c.sink.close();
    });
  }
}
