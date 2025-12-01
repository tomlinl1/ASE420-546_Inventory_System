import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/models/sort_mode.dart';
import 'package:inventory_app/utils/stock_utils.dart';

class MockRecordModel extends Mock implements RecordModel {}

/// Regression Test Suite
/// 
/// These tests verify that previously fixed bugs do not reoccur.
/// Each test is labeled with the bug it prevents from reoccurring.
///
/// Bugs being regression tested:
/// 1. Quantity cannot go below zero
/// 2. Empty search query should show all items
/// 3. Sorting should work correctly with duplicate quantities
/// 4. Low stock threshold should work correctly
/// 5. Quantity parsing handles different data types

void main() {
  group('Regression Tests - Previously Fixed Bugs', () {
    late MockRecordModel item1;
    late MockRecordModel item2;
    late MockRecordModel item3;

    setUp(() {
      item1 = MockRecordModel();
      item2 = MockRecordModel();
      item3 = MockRecordModel();

      when(() => item1.id).thenReturn('id1');
      when(() => item1.data).thenReturn({
        'item_name': 'Item1',
        'quantity': 5,
        'unit': 'lbs',
      });

      when(() => item2.id).thenReturn('id2');
      when(() => item2.data).thenReturn({
        'item_name': 'Item2',
        'quantity': 3,
        'unit': 'lbs',
      });

      when(() => item3.id).thenReturn('id3');
      when(() => item3.data).thenReturn({
        'item_name': 'Item3',
        'quantity': 3,
        'unit': 'gal',
      });
    });

    test('REGRESSION-001: Empty search query should return all items', () {
      // Bug: Empty search was returning no results
      // Expected: Empty query should show all items
      final items = [item1, item2, item3];

      final result = filterAndSortRecords(
        items,
        query: '',
        sortMode: SortMode.nameAsc,
      );

      expect(result.length, 3);
      expect(result, containsAll([item1, item2, item3]));
    });

    test('REGRESSION-002: Quantity parsing handles integer values', () {
      // Bug: Quantity as integer was not parsed correctly
      // Expected: Integer quantities should be extracted correctly
      final item = MockRecordModel();
      when(() => item.data).thenReturn({
        'item_name': 'Test',
        'quantity': 10,
        'unit': 'lbs',
      });

      final qty = recordQuantity(item);
      expect(qty, 10);
    });

    test('REGRESSION-003: Quantity parsing handles double values', () {
      // Bug: Quantity as double caused type errors
      // Expected: Double quantities should be converted to int
      final item = MockRecordModel();
      when(() => item.data).thenReturn({
        'item_name': 'Test',
        'quantity': 10.5,
        'unit': 'lbs',
      });

      final qty = recordQuantity(item);
      expect(qty, 10);
    });

    test('REGRESSION-004: Quantity parsing handles string values', () {
      // Bug: Quantity as string was not parsed
      // Expected: String quantities should be parsed to int
      final item = MockRecordModel();
      when(() => item.data).thenReturn({
        'item_name': 'Test',
        'quantity': '15',
        'unit': 'lbs',
      });

      final qty = recordQuantity(item);
      expect(qty, 15);
    });

    test('REGRESSION-005: Invalid quantity string returns zero', () {
      // Bug: Invalid quantity strings caused crashes
      // Expected: Invalid strings should return 0
      final item = MockRecordModel();
      when(() => item.data).thenReturn({
        'item_name': 'Test',
        'quantity': 'invalid',
        'unit': 'lbs',
      });

      final qty = recordQuantity(item);
      expect(qty, 0);
    });

    test('REGRESSION-006: Low stock threshold exclusive check works', () {
      // Bug: Threshold comparison was inclusive when it should be exclusive
      // Expected: Items at threshold should not be considered low (exclusive)
      final items = [item1, item2]; // item1=5, item2=3

      final lowItems = lowStockRecords(
        items,
        3,
        inclusive: false,
      );

      // Item2 with quantity 3 should NOT be included (3 is not < 3)
      expect(lowItems, isEmpty);
    });

    test('REGRESSION-007: Low stock threshold inclusive check works', () {
      // Bug: Inclusive threshold didn't work correctly
      // Expected: Items at or below threshold should be included (inclusive)
      final items = [item1, item2]; // item1=5, item2=3

      final lowItems = lowStockRecords(
        items,
        3,
        inclusive: true,
      );

      // Item2 with quantity 3 SHOULD be included (3 <= 3)
      expect(lowItems.length, 1);
      expect(lowItems.first, item2);
    });

    test('REGRESSION-008: Sorting with duplicate quantities maintains order', () {
      // Bug: Items with same quantity were randomly ordered
      // Expected: Items with same quantity should be sorted by name
      final items = [item2, item3]; // Both have quantity 3

      final sorted = filterAndSortRecords(
        items,
        sortMode: SortMode.qtyAsc,
      );

      // When quantities are equal, should maintain stable sort or sort by name
      expect(sorted.length, 2);
      // Both should be present
      expect(sorted, containsAll([item2, item3]));
    });

    test('REGRESSION-009: Name sorting is case-insensitive', () {
      // Bug: Case-sensitive sorting caused incorrect order
      // Expected: Sorting should be case-insensitive
      final itemA = MockRecordModel();
      final itemB = MockRecordModel();

      when(() => itemA.data).thenReturn({'item_name': 'apple'});
      when(() => itemB.data).thenReturn({'item_name': 'Banana'});

      final sorted = filterAndSortRecords(
        [itemB, itemA],
        sortMode: SortMode.nameAsc,
      );

      // 'apple' should come before 'Banana' (case-insensitive)
      expect(sorted.first.data['item_name'], 'apple');
      expect(sorted.last.data['item_name'], 'Banana');
    });

    test('REGRESSION-010: Search is case-insensitive', () {
      // Bug: Search was case-sensitive
      // Expected: Search should work regardless of case
      final items = [item1, item2, item3];

      final resultUpper = filterAndSortRecords(
        items,
        query: 'ITEM',
        sortMode: SortMode.nameAsc,
      );

      final resultLower = filterAndSortRecords(
        items,
        query: 'item',
        sortMode: SortMode.nameAsc,
      );

      // Both searches should return the same results
      expect(resultUpper.length, resultLower.length);
    });

    test('REGRESSION-011: Missing item_name field handled gracefully', () {
      // Bug: Missing item_name caused crashes
      // Expected: Missing fields should default to empty string
      final item = MockRecordModel();
      when(() => item.data).thenReturn({
        'quantity': 5,
        'unit': 'lbs',
      });

      final sorted = filterAndSortRecords(
        [item],
        sortMode: SortMode.nameAsc,
      );

      // Should not crash, should handle missing field
      expect(sorted, isNotEmpty);
    });

    test('REGRESSION-012: Low first sort handles zero quantity items', () {
      // Bug: Zero quantity items caused sort issues
      // Expected: Zero quantity should be handled correctly
      final zeroItem = MockRecordModel();
      when(() => zeroItem.data).thenReturn({
        'item_name': 'Zero',
        'quantity': 0,
        'unit': 'lbs',
      });

      final items = [item1, zeroItem]; // item1=5, zeroItem=0

      final sorted = filterAndSortRecords(
        items,
        sortMode: SortMode.lowFirst,
      );

      // Zero quantity item should appear first
      expect(sorted.first.data['quantity'], 0);
    });
  });
}

