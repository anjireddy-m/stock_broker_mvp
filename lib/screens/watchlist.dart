import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_brocker_mvp/controllers/watchlistcontroller.dart';

class WatchlistScreen extends StatelessWidget {
  final WatchlistController controller = Get.put(WatchlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        leading: Obx(() {
          return Center(
            child: Text(controller.watchlist.keys.toList().length.toString()),
          );
        }),
      ),
      body: Obx(() {
        var tokens = controller.watchlist.keys.toList();
        var data = controller.watchlist;
        var c_data = controller.dataJson;
        return ListView.builder(
          itemCount: tokens.length,
          itemBuilder: (context, index) {
            String symbol = '';
            String company = '';
            int ltp = 0;
            if (c_data.containsKey(tokens[index])) {
              symbol = c_data[tokens[index]]['symbol'] ?? '';
              company = c_data[tokens[index]]['company'] ?? '';
            }
            if (data.containsKey(tokens[index])) {
              ltp = data[tokens[index]] ?? 0;
            }
            return Dismissible(
              key: Key(tokens[index]),
              background: Container(
                color: Colors.red, // Background color when swiping
              ),
              onDismissed: (direction) {
                controller.removeFromWatchlist(tokens[index]);
              },
              child: ListTile(
                title: Text(symbol),
                subtitle: Text(company),
                trailing: Text(
                  '₹ ${ltp / 100}',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
