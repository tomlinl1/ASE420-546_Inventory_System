import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../main.dart';

class UpdateStockPage extends StatefulWidget {
  const UpdateStockPage({super.key});

  @override
  State<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  List<RecordModel> _stockItems = [];
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();

  RecordModel? _editingItem; // null if adding new

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  // Load all stock items from PocketBase
  Future<void> _loadStock() async {
    setState(() => _isLoading = true);
    try {
      final records = await pb.collection('inventory').getFullList();
      setState(() => _stockItems = records);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load stock.")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Create or update stock item
  Future<void> _saveStock() async {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final unit = _unitController.text.trim();

    if (name.isEmpty || unit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_editingItem == null) {
        // Create new item
        await pb
            .collection('inventory')
            .create(
              body: {"item_name": name, "quantity": quantity, "unit": unit},
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully added $name to inventory!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Update existing item
        await pb
            .collection('inventory')
            .update(
              _editingItem!.id,
              body: {"item_name": name, "quantity": quantity, "unit": unit},
            );
        setState(() {
          _editingItem = null; // reset
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully updated $name!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      _nameController.clear();
      _quantityController.clear();
      _unitController.clear();
      await _loadStock();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save stock.")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete stock item
  Future<void> _deleteStock(RecordModel item) async {
    setState(() => _isLoading = true);
    try {
      await pb.collection('inventory').delete(item.id);
      await _loadStock();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete stock.")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fill form for editing
  void _editStock(RecordModel item) {
    setState(() {
      _nameController.text = (item.data['item_name'] ?? '').toString();
      _quantityController.text = (item.data['quantity'] ?? 0).toString();
      _unitController.text = (item.data['unit'] ?? '').toString();
      _editingItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Stock',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Form
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unit'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveStock,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text(
                      _editingItem == null ? "Add Stock" : "Update Stock",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stock List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _stockItems.length,
                      itemBuilder: (context, index) {
                        final item = _stockItems[index];
                        return Card(
                          child: ListTile(
                            title: Text("${item.data['item_name']}"),
                            subtitle: Text(
                              "Qty: ${item.data['quantity']} ${item.data['unit']}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _editStock(item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteStock(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
