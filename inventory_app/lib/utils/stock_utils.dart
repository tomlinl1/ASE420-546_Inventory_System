import 'package:pocketbase/pocketbase.dart';

import '../models/sort_mode.dart';

int recordQuantity(RecordModel record) {
  final raw = record.data['quantity'];
  if (raw is int) return raw;
  if (raw is double) return raw.toInt();
  if (raw is String) {
    final parsed = int.tryParse(raw);
    if (parsed != null) return parsed;
  }
  return 0;
}

List<RecordModel> filterAndSortRecords(
  List<RecordModel> items, {
  String query = '',
  SortMode sortMode = SortMode.nameAsc,
}) {
  var filtered = items;

  if (query.isNotEmpty) {
    final lowerQuery = query.toLowerCase();
    filtered = items.where((record) {
      final name = (record.data['item_name'] ?? '').toString().toLowerCase();
      return name.contains(lowerQuery);
    }).toList();
  } else {
    filtered = List<RecordModel>.from(items);
  }

  switch (sortMode) {
    case SortMode.nameAsc:
      filtered.sort(
        (a, b) => (a.data['item_name'] ?? '')
            .toString()
            .toLowerCase()
            .compareTo((b.data['item_name'] ?? '').toString().toLowerCase()),
      );
      break;
    case SortMode.nameDesc:
      filtered.sort(
        (a, b) => (b.data['item_name'] ?? '')
            .toString()
            .toLowerCase()
            .compareTo((a.data['item_name'] ?? '').toString().toLowerCase()),
      );
      break;
    case SortMode.qtyAsc:
      filtered.sort((a, b) => recordQuantity(a).compareTo(recordQuantity(b)));
      break;
    case SortMode.qtyDesc:
      filtered.sort((a, b) => recordQuantity(b).compareTo(recordQuantity(a)));
      break;
    case SortMode.lowFirst:
      filtered.sort((a, b) {
        final qa = recordQuantity(a);
        final qb = recordQuantity(b);
        final byQty = qa.compareTo(qb);
        if (byQty != 0) return byQty;
        return (a.data['item_name'] ?? '').toString().toLowerCase().compareTo(
          (b.data['item_name'] ?? '').toString().toLowerCase(),
        );
      });
      break;
  }

  return filtered;
}

List<RecordModel> lowStockRecords(
  List<RecordModel> items,
  int threshold, {
  bool inclusive = false,
}) {
  return items.where((record) {
    final qty = recordQuantity(record);
    return inclusive ? qty <= threshold : qty < threshold;
  }).toList()..sort((a, b) => recordQuantity(a).compareTo(recordQuantity(b)));
}
