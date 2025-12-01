import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:inventory_app/main.dart' as app;

/// Integration test for full app flow
/// 
/// This test verifies the complete user journey through the inventory app:
/// 1. App launches and displays home page
/// 2. Navigation to different pages works correctly
/// 3. User interactions are handled properly
/// 
/// Note: 
/// - This test requires a running PocketBase instance at http://127.0.0.1:8090
/// - Integration tests are not supported on web platform
/// - To run on mobile/desktop: flutter test integration_test/app_flow_integration_test.dart
/// - Or: flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_flow_integration_test.dart

void main() {
  // Skip integration tests on web platform as they are not supported
  if (kIsWeb) {
    print('Integration tests are skipped on web platform.');
    return;
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Integration Tests', () {
    testWidgets('Complete app navigation flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify home page is displayed
      expect(find.text("Antonio's Pizza Pub Inventory"), findsOneWidget);
      expect(find.text('Welcome to the Inventory System!'), findsOneWidget);

      // Verify navigation buttons are present
      expect(find.text('Check Stock'), findsOneWidget);
      expect(find.text('Update Stock'), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);

      // Navigate to Check Stock page
      await tester.tap(find.text('Check Stock'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify Check Stock page is displayed
      expect(find.text('Check Stock'), findsOneWidget);
      expect(find.text('Search items...'), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify we're back on home page
      expect(find.text("Antonio's Pizza Pub Inventory"), findsOneWidget);

      // Navigate to Update Stock page
      await tester.tap(find.text('Update Stock'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify Update Stock page is displayed
      expect(find.text('Update Stock'), findsOneWidget);
      expect(find.text('Item Name'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('Unit'), findsOneWidget);
    });

    testWidgets('Home page refresh functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Perform pull-to-refresh gesture
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify page still renders correctly after refresh
      expect(find.text("Antonio's Pizza Pub Inventory"), findsOneWidget);
    });

    testWidgets('Low stock warning display', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check if low stock warning appears (if there are low stock items)
      // The warning may or may not appear depending on actual data
      final lowStockWarning = find.textContaining('item(s) are low on stock');
      if (lowStockWarning.evaluate().isNotEmpty) {
        // If warning is present, verify it's clickable
        expect(find.text('View'), findsWidgets);
      }
    });
  });
}

