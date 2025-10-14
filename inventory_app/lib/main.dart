import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'pages/home_page.dart';
import 'pages/check_stock_page.dart';
import 'pages/update_stock_page.dart';

final pb = PocketBase('http://127.0.0.1:8090');

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Antonio's Pizza Pub Inventory",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/check-stock': (context) => const CheckStockPage(),
        '/update-stock': (context) => const UpdateStockPage(),
      },
    );
  }
}
