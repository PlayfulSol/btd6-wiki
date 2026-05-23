import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btd6wiki/main.dart';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:btd6wiki/utilities/favorite_state.dart';
import 'package:btd6wiki/utilities/constants.dart';
import 'package:btd6wiki/models/base/base_tower.dart';
import 'package:btd6wiki/models/base/base_hero.dart';
import 'package:btd6wiki/models/base/base_map.dart';
import 'package:btd6wiki/models/base/base_bloon.dart';
import 'package:btd6wiki/models/base_model.dart';
import '../helpers/fake_analytics.dart';

// Minimal entity map — empty lists so no image loading occurs.
Map<String, dynamic> _emptyEntities() => {
      kTowers: <BaseTower>[],
      kHeroes: <BaseHero>[],
      kMaps: <BaseMap>[],
      kBloons: <BaseBloon>[],
      kBosses: <BaseModel>[],
    };

Widget _buildApp(GlobalState globalState, FavoriteState favoriteState) {
  final analytics = FakeAnalyticsHelper();
  final entities = _emptyEntities();

  final router = GoRouter(
    initialLocation: '/towers',
    routes: [
      GoRoute(
        path: '/towers',
        builder: (_, __) => MyHomePage(
          analyticsHelper: analytics,
          baseEntities: entities,
          initialPageIndex: kTowersIndex,
        ),
      ),
      GoRoute(
        path: '/heroes',
        builder: (_, __) => MyHomePage(
          analyticsHelper: analytics,
          baseEntities: entities,
          initialPageIndex: kHeroesIndex,
        ),
      ),
      GoRoute(
        path: '/bloons',
        builder: (_, __) => MyHomePage(
          analyticsHelper: analytics,
          baseEntities: entities,
          initialPageIndex: kBloonsIndex,
        ),
      ),
      GoRoute(
        path: '/maps',
        builder: (_, __) => MyHomePage(
          analyticsHelper: analytics,
          baseEntities: entities,
          initialPageIndex: kMapsIndex,
        ),
      ),
      GoRoute(path: '/favorites', builder: (_, __) => const Scaffold()),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: globalState),
      ChangeNotifierProvider.value(value: favoriteState),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late GlobalState globalState;
  late FavoriteState favoriteState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    globalState = GlobalState();
    favoriteState = FavoriteState(prefs);
  });

  // ── No crash on mount ─────────────────────────────────────────────────────

  testWidgets(
      'mounts without setState-during-build error (post-frame callback fix)',
      (tester) async {
    await tester.pumpWidget(_buildApp(globalState, favoriteState));
    // First pump builds the tree; post-frame callback is scheduled.
    await tester.pump();
    // Second pump executes the callback → updateCurrentPage → notifyListeners.
    // If the old bug were present this would throw.
    await tester.pump();
  });

  // ── Bottom nav shows correct tabs ─────────────────────────────────────────

  testWidgets('bottom nav shows all four tabs', (tester) async {
    await tester.pumpWidget(_buildApp(globalState, favoriteState));
    await tester.pumpAndSettle();

    expect(find.text('Towers'), findsWidgets);
    expect(find.text('Heroes'), findsWidgets);
    expect(find.text('Bloons'), findsWidgets);
    expect(find.text('Maps'), findsWidgets);
  });

  // ── Filter chips use explicit category (not activeCategory) ───────────────

  testWidgets(
      'tapping a filter chip on Heroes page updates kHeroes not kTowers',
      (tester) async {
    await tester.pumpWidget(_buildApp(globalState, favoriteState));
    await tester.pumpAndSettle();

    // Navigate to Heroes via bottom nav
    await tester.tap(find.text('Heroes'));
    await tester.pumpAndSettle();

    // Tap the 'Hard' chip (heroes price filter)
    await tester.tap(find.text('Hard'));
    await tester.pumpAndSettle();

    expect(globalState.optionForCategory(kHeroes), 'Hard');
    expect(globalState.optionForCategory(kTowers), 'All'); // towers unchanged
  });

  testWidgets('swiping to Heroes page then tapping chip updates kHeroes',
      (tester) async {
    await tester.pumpWidget(_buildApp(globalState, favoriteState));
    await tester.pumpAndSettle();

    // Swipe left to Heroes
    await tester.fling(
        find.byType(PageView), const Offset(-400, 0), 800);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Medium'));
    await tester.pumpAndSettle();

    expect(globalState.optionForCategory(kHeroes), 'Medium');
    expect(globalState.optionForCategory(kTowers), 'All');
  });

  testWidgets('each page tracks its own filter independently', (tester) async {
    await tester.pumpWidget(_buildApp(globalState, favoriteState));
    await tester.pumpAndSettle();

    // Set towers filter
    await tester.tap(find.text('Primary'));
    await tester.pumpAndSettle();

    // Switch to Heroes
    await tester.tap(find.text('Heroes'));
    await tester.pumpAndSettle();

    // Towers filter should be unchanged, heroes should still be All
    expect(globalState.optionForCategory(kTowers), 'Primary');
    expect(globalState.optionForCategory(kHeroes), 'All');
  });
}
