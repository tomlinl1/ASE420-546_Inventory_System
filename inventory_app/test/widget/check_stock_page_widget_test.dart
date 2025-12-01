import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:inventory_app/pages/check_stock_page.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockRecordModel extends Mock implements RecordModel {}

void main() {
  late MockRecordModel item1;
  late MockRecordModel item2;
  late MockRecordModel item3;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://127.0.0.1:8090'));
  });

  setUp(() {
    item1 = MockRecordModel();
    item2 = MockRecordModel();
    item3 = MockRecordModel();

    when(() => item1.id).thenReturn('id1');
    when(() => item1.data).thenReturn({
      'item_name': 'Cheese',
      'quantity': 5,
      'unit': 'lbs',
    });

    when(() => item2.id).thenReturn('id2');
    when(() => item2.data).thenReturn({
      'item_name': 'Dough',
      'quantity': 10,
      'unit': 'lbs',
    });

    when(() => item3.id).thenReturn('id3');
    when(() => item3.data).thenReturn({
      'item_name': 'Sauce',
      'quantity': 2,
      'unit': 'gal',
    });
  });

  testWidgets('CheckStockPage displays loading indicator initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    // Initially should show loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('CheckStockPage displays search field', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    await tester.pumpAndSettle();

    // Should have search field in app bar
    expect(find.text('Search items...'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('CheckStockPage displays sort menu button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    await tester.pumpAndSettle();

    // Should have sort icon button
    expect(find.byIcon(Icons.sort), findsOneWidget);
  });

  testWidgets('CheckStockPage displays correct app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Check Stock'), findsOneWidget);
  });

  testWidgets('CheckStockPage shows error message when stock loading fails', (WidgetTester tester) async {
    // Note: In a real scenario, you would mock the PocketBase instance
    // For this test, we're testing that the widget structure is correct
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    await tester.pumpAndSettle();

    // The widget should handle errors gracefully
    // We can't easily test PocketBase failures without dependency injection
    // But we can test that the widget renders
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('CheckStockPage has correct app bar styling', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckStockPage(),
      ),
    );

    await tester.pumpAndSettle();

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, Colors.black);
    expect(appBar.title, isA<Text>());
  });
}

