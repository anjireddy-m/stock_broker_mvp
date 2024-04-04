import 'dart:convert';
import 'package:get/get.dart';
import 'package:stock_brocker_mvp/data/symbols.dart';
import 'package:stock_brocker_mvp/services/websockerManager.dart';

class WatchlistController extends GetxController {
  final _webSocketManager = WebSocketManager();
  final RxMap _watchlist = {}.obs;
  final _removedTokens = <String>{}.obs;
  Map<String, dynamic> dataJson = {};

  RxMap get watchlist => _watchlist;

  listenToWebhook() async {
    dataJson = SYMBOL_DATA;
    List<int> tokens = dataJson.keys.map((key) => int.parse(key)).toList();
    print(tokens);
    await _webSocketManager.subscribeToLTP(tokens);

    _webSocketManager.channels.forEach((channel) {
      channel.stream.listen((message) {
        try {
          Map<String, dynamic> data = jsonDecode(message);
          print(data.length);
          data.forEach((token, ltp) {
            if (!_removedTokens.contains(token)) {
              _watchlist[token] = ltp;
            }
          });
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
    });
  }

  @override
  void onInit() {
    listenToWebhook();
    super.onInit();
  }

  void removeFromWatchlist(String token) {
    _webSocketManager.unsubscribeFromLTP([int.parse(token)]);
    _removedTokens.add(token);
    _watchlist.remove(token);
  }

  @override
  void onClose() {
    _webSocketManager.dispose();
    super.onClose();
  }
}
