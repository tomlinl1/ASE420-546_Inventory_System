import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';

class CheckStockPage extends StatefulWidget {
  const CheckStockPage({super.key});

  @override
  State<CheckStockPage> createState() => _CheckStockPageState();
}

class _CheckStockPageState extends State<CheckStockPage> {
  List<RecordModel> _stockItems = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  Future<void> _loadStock() async {
    setState(() => _isLoading = true);

    try {
      final records = await pb.collection('inventory').getFullList();
      setState(() => _stockItems = records);
    } catch (e) {
      setState(() => _error = "Failed to load stock.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Stock', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _stockItems.isEmpty
          ? const Center(child: Text("No stock items available."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stockItems.length,
              itemBuilder: (context, index) {
                final item = _stockItems[index];
                return Card(
                  child: ListTile(
                    title: Text(item.data['item_name']),
                    subtitle: Text(
                      "Quantity: ${item.data['quantity']} ${item.data['unit']}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
