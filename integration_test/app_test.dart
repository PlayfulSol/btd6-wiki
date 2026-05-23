// Integration tests — run against a real device or emulator:
//   flutter test integration_test/app_test.dart -d <device_id>
//
// Firebase initialises normally because the real google-services.json is
// bundled with the app.  Do NOT run with `flutter test` alone (no device).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:btd6wiki/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Shared helper — starts the app and waits for the loading screen to finish.
  Future<void> launchApp(WidgetTester tester) async {
    app.main();
    // pumpAndSettle waits until no more frames are scheduled, covering both
    // Firebase init and the async JSON loading in _loadBaseData.
    await tester.pumpAndSettle(const Duration(seconds: 30));
  }

  // ── Loading screen ────────────────────────────────────────────────────────

  testWidgets('app loads past the loading screen', (tester) async {
    await launchApp(tester);

    // The spinner from Loader should be gone.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // The main bottom navigation bar should be visible.
    expect(find.byType(NavigationBar), findsOneWidget);

    // All four tab labels should appear.
    expect(find.text('Towers'), findsWidgets);
    expect(find.text('Heroes'), findsWidgets);
    expect(find.text('Bloons'), findsWidgets);
    expect(find.text('Maps'), findsWidgets);
  });

  // ── Filter chips ──────────────────────────────────────────────────────────

  testWidgets('filter chips work after swiping to Heroes page', (tester) async {
    await launchApp(tester);

    // Swipe left to Heroes.
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 800);
    await tester.pumpAndSettle();

    // All heroes should be visible before filtering.
    final beforeCount =
        tester.widgetList(find.byType(Card)).length;
    expect(beforeCount, greaterThan(0));

    // Tap the 'Hard' chip — only heroes affordable on Hard (≤ $650) appear.
    await tester.tap(find.text('Hard'));
    await tester.pumpAndSettle();

    final afterCount = tester.widgetList(find.byType(Card)).length;
    // Filtering should reduce the visible count (at least one hero is not
    // affordable on Hard — e.g. Captain Churchill costs $2,160).
    expect(afterCount, lessThan(beforeCount));

    // Reset back to All.
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(tester.widgetList(find.byType(Card)).length, beforeCount);
  });

  testWidgets('filter chips on Towers page work after bottom-nav navigation',
      (tester) async {
    await launchApp(tester);

    // Navigate away then back to Towers via bottom nav.
    await tester.tap(find.text('Heroes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Towers'));
    await tester.pumpAndSettle();

    final beforeCount = tester.widgetList(find.byType(Card)).length;

    await tester.tap(find.text('Primary'));
    await tester.pumpAndSettle();

    final afterCount = tester.widgetList(find.byType(Card)).length;
    expect(afterCount, lessThan(beforeCount));
  });

  // ── Navigation to detail page ─────────────────────────────────────────────

  testWidgets('tapping a tower card opens the detail page and back returns to list',
      (tester) async {
    await launchApp(tester);

    // Tap the first tower card.
    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    // Detail page uses a SliverAppBar with a back button.
    expect(find.byType(BackButton), findsOneWidget);

    // Go back.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Main navigation should be visible again.
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  // ── Favorites ─────────────────────────────────────────────────────────────

  testWidgets('long-pressing a card adds to favorites and it appears in favorites screen',
      (tester) async {
    await launchApp(tester);

    // Long-press the first tower card to toggle favorite.
    await tester.longPress(find.byType(Card).first);
    await tester.pumpAndSettle();

    // Navigate to favorites via the star icon in the app bar.
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpAndSettle();

    // The favorites screen should show at least one card.
    expect(find.byType(Card), findsWidgets);
  });

  // ── Search ────────────────────────────────────────────────────────────────

  testWidgets('searching for Quincy shows only Quincy on Heroes page',
      (tester) async {
    await launchApp(tester);

    // Navigate to Heroes.
    await tester.tap(find.text('Heroes'));
    await tester.pumpAndSettle();

    // Enable search.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Type the search query.
    await tester.enterText(find.byType(TextField), 'Quincy');
    await tester.pumpAndSettle();

    expect(find.text('Quincy'), findsWidgets);

    // No other hero names should be visible in the grid.
    // (We check a known other hero is gone.)
    expect(find.text('Gwendolin'), findsNothing);

    // Clear search.
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Gwendolin'), findsWidgets);
  });
}
