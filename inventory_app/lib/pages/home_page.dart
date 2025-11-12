import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';
import '../utils/stock_utils.dart';

const int kLowThreshold = 3;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecordModel> _stockItems = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  int _getQuantity(RecordModel r) {
    final raw = r.data['quantity'];
    if (raw is int) return raw;
    if (raw is double) return raw.toInt();
    if (raw is String) {
      final v = int.tryParse(raw);
      return v ?? 0;
    }
    return 0;
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
    final lowItems = lowStockRecords(
      _stockItems,
      kLowThreshold,
      inclusive: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Antonio's Pizza Pub Inventory",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : RefreshIndicator(
              onRefresh: _loadStock,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (lowItems.isNotEmpty)
                        Card(
                          color: Colors.red.shade50,
                          child: ListTile(
                            leading: const Icon(
                              Icons.warning_amber,
                              color: Colors.red,
                            ),
                            title: Text(
                              '${lowItems.length} item(s) are low on stock (< $kLowThreshold)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            subtitle: const Text(
                              'Review low inventory to avoid stockouts.',
                            ),
                            trailing: TextButton(
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/check-stock',
                                );
                                if (!mounted) return;
                                await _loadStock();
                              },
                              child: const Text(
                                'View',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      const Text(
                        "Welcome to the Inventory System!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/check-stock',
                              );
                              if (!mounted) return;
                              await _loadStock();
                            },
                            icon: const Icon(Icons.inventory),
                            label: const Text("Check Stock"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(160, 48),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/update-stock',
                              );
                              if (!mounted) return;
                              await _loadStock();
                            },
                            icon: const Icon(Icons.update),
                            label: const Text("Update Stock"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(160, 48),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (lowItems.isNotEmpty) ...[
                        const Text(
                          'Low Stock Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lowItems.length.clamp(0, 5),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final item = lowItems[index];
                            final qty = _getQuantity(item);
                            return Card(
                              child: ListTile(
                                title: Text(item.data['item_name']),
                                subtitle: Text(
                                  'Quantity: $qty ${item.data['unit']}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'LOW',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        if (lowItems.length > 5)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/check-stock'),
                              child: Text('View all (${lowItems.length})'),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
