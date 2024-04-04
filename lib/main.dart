import 'package:flutter/material.dart';
import 'package:stock_brocker_mvp/screens/watchlist.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Broker MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primaryColor: Colors.deepPurple
      ),
      debugShowCheckedModeBanner: false,
      home: WatchlistScreen(),
    );
  }
}