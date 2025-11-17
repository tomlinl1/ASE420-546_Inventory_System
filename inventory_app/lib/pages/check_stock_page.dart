import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';
import '../models/sort_mode.dart';
import '../utils/stock_utils.dart';

class CheckStockPage extends StatefulWidget {
  const CheckStockPage({super.key});

  @override
  State<CheckStockPage> createState() => _CheckStockPageState();
}

class _CheckStockPageState extends State<CheckStockPage> {
  List<RecordModel> _stockItems = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _query = '';

  SortMode _sortMode = SortMode.nameAsc;
  final Set<String> _updatingIds = <String>{};

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

  List<RecordModel> get _filteredSortedItems {
    return filterAndSortRecords(
      _stockItems,
      query: _query,
      sortMode: _sortMode,
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _query = value.trim();
      });
    });
  }

  void _setSort(SortMode mode) {
    if (_sortMode == mode) return;
    setState(() {
      _sortMode = mode;
    });
  }

  Future<void> _updateQuantity(RecordModel item, int delta) async {
    if (_updatingIds.contains(item.id)) return;

    final currentQty = recordQuantity(item);
    var newQty = currentQty + delta;
    if (newQty < 0) newQty = 0;
    if (newQty == currentQty) return;

    setState(() {
      _updatingIds.add(item.id);
      item.data['quantity'] = newQty;
    });

    try {
      await pb
          .collection('inventory')
          .update(
            item.id,
            body: {
              "item_name": item.data['item_name'],
              "quantity": newQty,
              "unit": item.data['unit'],
            },
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.data['item_name']} quantity ${delta > 0 ? 'increased' : 'decreased'} to $newQty',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        item.data['quantity'] = currentQty;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update quantity.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _updatingIds.remove(item.id);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Stock', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: _setSort,
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: SortMode.nameAsc,
                checked: _sortMode == SortMode.nameAsc,
                child: const Text('Name A–Z'),
              ),
              CheckedPopupMenuItem(
                value: SortMode.nameDesc,
                checked: _sortMode == SortMode.nameDesc,
                child: const Text('Name Z–A'),
              ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem(
                value: SortMode.qtyAsc,
                checked: _sortMode == SortMode.qtyAsc,
                child: const Text('Quantity Low → High'),
              ),
              CheckedPopupMenuItem(
                value: SortMode.qtyDesc,
                checked: _sortMode == SortMode.qtyDesc,
                child: const Text('Quantity High → Low'),
              ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem(
                value: SortMode.lowFirst,
                checked: _sortMode == SortMode.lowFirst,
                child: const Text('Low Stock First'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search items...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _stockItems.isEmpty
          ? const Center(child: Text("No stock items available."))
          : Builder(
              builder: (context) {
                final visibleItems = _filteredSortedItems;
                if (visibleItems.isEmpty) {
                  return const Center(child: Text("No matching items."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: visibleItems.length,
                  itemBuilder: (context, index) {
                    final item = visibleItems[index];
                    final quantity = recordQuantity(item);
                    final isUpdating = _updatingIds.contains(item.id);
                    return Card(
                      child: ListTile(
                        title: Text(item.data['item_name']),
                        subtitle: Text(
                          "Quantity: $quantity ${item.data['unit']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: isUpdating || quantity <= 0
                                  ? null
                                  : () => _updateQuantity(item, -1),
                            ),
                            SizedBox(
                              width: 36,
                              child: Center(
                                child: isUpdating
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: isUpdating
                                  ? null
                                  : () => _updateQuantity(item, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
