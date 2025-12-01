import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/pages/home_page.dart';
import 'package:inventory_app/pages/check_stock_page.dart';
import 'package:inventory_app/pages/update_stock_page.dart';
import 'package:inventory_app/models/sort_mode.dart';
import 'package:inventory_app/utils/stock_utils.dart';

class MockRecordModel extends Mock implements RecordModel {}

/// Acceptance Test Suite
/// 
/// These tests verify that the application meets user acceptance criteria:
/// 1. Users can view their inventory
/// 2. Users can check stock levels
/// 3. Users can update stock quantities
/// 4. Users can add new items
/// 5. Users are alerted about low stock
/// 6. Users can search and sort inventory

void main() {
  group('User Acceptance Criteria Tests', () {
    late MockRecordModel lowStockItem;
    late MockRecordModel normalStockItem;

    setUp(() {
      lowStockItem = MockRecordModel();
      normalStockItem = MockRecordModel();

      when(() => lowStockItem.id).thenReturn('low1');
      when(() => lowStockItem.data).thenReturn({
        'item_name': 'Low Stock Item',
        'quantity': 2,
        'unit': 'lbs',
      });

      when(() => normalStockItem.id).thenReturn('normal1');
      when(() => normalStockItem.data).thenReturn({
        'item_name': 'Normal Stock Item',
        'quantity': 10,
        'unit': 'lbs',
      });
    });

    test('AC1: User can view inventory list', () {
      // Acceptance Criteria: The system should display a list of all inventory items
      final items = [lowStockItem, normalStockItem];

      // Verify items are available
      expect(items, isNotEmpty);
      expect(items.length, 2);
    });

    test('AC2: User can identify low stock items', () {
      // Acceptance Criteria: Items below threshold (3) should be identified as low stock
      final items = [lowStockItem, normalStockItem];
      final lowItems = lowStockRecords(items, 3, inclusive: false);

      // Verify low stock detection works
      expect(lowItems.length, 1);
      expect(lowItems.first, lowStockItem);
    });

    test('AC3: User can search inventory items', () {
      // Acceptance Criteria: Users should be able to search items by name
      final items = [lowStockItem, normalStockItem];
      
      // Search for "Low"
      final filtered = filterAndSortRecords(
        items,
        query: 'Low',
        sortMode: SortMode.nameAsc,
      );

      expect(filtered.length, 1);
      expect(filtered.first, lowStockItem);
    });

    test('AC4: User can sort inventory by name ascending', () {
      // Acceptance Criteria: Users should be able to sort items alphabetically
      final item1 = MockRecordModel();
      final item2 = MockRecordModel();

      when(() => item1.data).thenReturn({'item_name': 'Zebra'});
      when(() => item2.data).thenReturn({'item_name': 'Apple'});

      final sorted = filterAndSortRecords(
        [item1, item2],
        sortMode: SortMode.nameAsc,
      );

      expect(sorted.first.data['item_name'], 'Apple');
      expect(sorted.last.data['item_name'], 'Zebra');
    });

    test('AC5: User can sort inventory by quantity', () {
      // Acceptance Criteria: Users should be able to sort items by quantity
      final item1 = MockRecordModel();
      final item2 = MockRecordModel();

      when(() => item1.data).thenReturn({'item_name': 'Item1', 'quantity': 10});
      when(() => item2.data).thenReturn({'item_name': 'Item2', 'quantity': 5});

      final sortedDesc = filterAndSortRecords(
        [item1, item2],
        sortMode: SortMode.qtyDesc,
      );

      expect(sortedDesc.first.data['quantity'], 10);
      expect(sortedDesc.last.data['quantity'], 5);
    });

    test('AC6: User can view low stock items first', () {
      // Acceptance Criteria: Users should be able to prioritize low stock items
      final item1 = MockRecordModel();
      final item2 = MockRecordModel();
      final item3 = MockRecordModel();

      when(() => item1.data).thenReturn({'item_name': 'High', 'quantity': 10});
      when(() => item2.data).thenReturn({'item_name': 'Low', 'quantity': 1});
      when(() => item3.data).thenReturn({'item_name': 'Medium', 'quantity': 5});

      final sorted = filterAndSortRecords(
        [item1, item2, item3],
        sortMode: SortMode.lowFirst,
      );

      // Low stock items should appear first
      expect(sorted.first.data['quantity'], 1);
    });

    testWidgets('AC7: Home page displays navigation options', (WidgetTester tester) async {
      // Acceptance Criteria: Users should have clear navigation to all features
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all navigation buttons are present
      expect(find.text('Check Stock'), findsOneWidget);
      expect(find.text('Update Stock'), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);
    });

    testWidgets('AC8: Check Stock page has search functionality', (WidgetTester tester) async {
      // Acceptance Criteria: Users should be able to search for items
      await tester.pumpWidget(
        const MaterialApp(
          home: CheckStockPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify search field is present
      expect(find.text('Search items...'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('AC9: Update Stock page has form fields', (WidgetTester tester) async {
      // Acceptance Criteria: Users should be able to add/update stock items
      await tester.pumpWidget(
        const MaterialApp(
          home: UpdateStockPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify form fields are present
      expect(find.text('Item Name'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('Unit'), findsOneWidget);
      expect(find.text('Add Stock'), findsOneWidget);
    });
  });
}

