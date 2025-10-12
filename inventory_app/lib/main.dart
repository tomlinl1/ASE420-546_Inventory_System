import 'package:flutter/material.dart';
import 'pages/signup_page.dart';
import 'pages/signin_page.dart';
import 'pages/home_page.dart';
import 'pages/check_stock_page.dart';
import 'pages/update_stock_page.dart';

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
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/check-stock': (context) => const CheckStockPage(),
        '/update-stock': (context) => const UpdateStockPage(),
      },
    );
  }
}
