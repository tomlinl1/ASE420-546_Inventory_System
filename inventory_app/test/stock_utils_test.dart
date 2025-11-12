import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/models/sort_mode.dart';
import 'package:inventory_app/utils/stock_utils.dart';

class MockRecordModel extends Mock implements RecordModel {}

void main() {
  late MockRecordModel cheese;
  late MockRecordModel dough;
  late MockRecordModel sauce;

  setUp(() {
    cheese = MockRecordModel();
    dough = MockRecordModel();
    sauce = MockRecordModel();

    when(
      () => cheese.data,
    ).thenReturn({'item_name': 'Cheese', 'quantity': 4, 'unit': 'lbs'});

    when(
      () => dough.data,
    ).thenReturn({'item_name': 'Dough', 'quantity': 10, 'unit': 'lbs'});

    when(
      () => sauce.data,
    ).thenReturn({'item_name': 'Sauce', 'quantity': 2, 'unit': 'gal'});
  });

  group('filterAndSortRecords', () {
    test('filters by query and sorts by name ascending', () {
      final result = filterAndSortRecords(
        [cheese, dough, sauce],
        query: 'che',
        sortMode: SortMode.nameAsc,
      );

      expect(result, [cheese]);
    });

    test('sorts by quantity descending when no query provided', () {
      final result = filterAndSortRecords([
        cheese,
        dough,
        sauce,
      ], sortMode: SortMode.qtyDesc);

      expect(result, [dough, cheese, sauce]);
    });

    test('prioritises low stock first sort', () {
      final result = filterAndSortRecords([
        cheese,
        dough,
        sauce,
      ], sortMode: SortMode.lowFirst);

      expect(result.first, sauce);
      expect(result.last, dough);
    });
  });

  group('lowStockRecords', () {
    test('returns items below threshold (exclusive)', () {
      final result = lowStockRecords(
        [cheese, dough, sauce],
        3,
        inclusive: false,
      );

      expect(result, [sauce]);
    });

    test('returns items at or below threshold when inclusive', () {
      final result = lowStockRecords(
        [cheese, dough, sauce],
        4,
        inclusive: true,
      );

      expect(result, [sauce, cheese]);
    });
  });
}
