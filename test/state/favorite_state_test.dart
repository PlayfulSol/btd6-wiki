import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btd6wiki/utilities/favorite_state.dart';

class _Item {
  final String id;
  final String name;
  final String image;
  final String type;
  const _Item({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });
}

void main() {
  group('FavoriteState', () {
    late FavoriteState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      state = FavoriteState(prefs);
    });

    // ── Initial state ─────────────────────────────────────────────────────────

    test('all lists empty initially', () {
      expect(state.getListOfType('towers'), isEmpty);
      expect(state.getListOfType('heroes'), isEmpty);
      expect(state.getActiveCategories(), isEmpty);
    });

    test('isFavorite returns false for unknown item', () {
      expect(state.isFavorite('towers', 'dart_monkey'), isFalse);
    });

    // ── toggleFavorite ────────────────────────────────────────────────────────

    group('toggleFavorite', () {
      test('adds item and returns added message', () {
        const item = _Item(
            id: 'dart_monkey',
            name: 'Dart Monkey',
            image: 'dart.webp',
            type: 'towers');
        final msg = state.toggleFavorite(item);
        expect(msg, 'Added to favorites!');
        expect(state.isFavorite('towers', 'dart_monkey'), isTrue);
      });

      test('removes item on second toggle and returns removed message', () {
        const item = _Item(
            id: 'dart_monkey',
            name: 'Dart Monkey',
            image: 'dart.webp',
            type: 'towers');
        state.toggleFavorite(item);
        final msg = state.toggleFavorite(item);
        expect(msg, 'Removed from favorites.');
        expect(state.isFavorite('towers', 'dart_monkey'), isFalse);
      });

      test('toggling one type does not affect another type', () {
        const tower = _Item(
            id: 'dart_monkey',
            name: 'Dart Monkey',
            image: 'dart.webp',
            type: 'towers');
        const hero = _Item(
            id: 'quincy',
            name: 'Quincy',
            image: 'quincy.webp',
            type: 'heroes');

        state.toggleFavorite(tower);
        expect(state.isFavorite('towers', 'dart_monkey'), isTrue);
        expect(state.isFavorite('heroes', 'quincy'), isFalse);

        state.toggleFavorite(hero);
        expect(state.isFavorite('towers', 'dart_monkey'), isTrue);
        expect(state.isFavorite('heroes', 'quincy'), isTrue);
      });

      test('notifies listeners on add', () {
        int count = 0;
        state.addListener(() => count++);
        const item = _Item(
            id: 'x', name: 'X', image: 'x.webp', type: 'towers');
        state.toggleFavorite(item);
        expect(count, 1);
      });
    });

    // ── getListOfType ─────────────────────────────────────────────────────────

    group('getListOfType', () {
      test('returns all items for that type only', () {
        const t1 = _Item(
            id: 'dart', name: 'Dart Monkey', image: 'd.webp', type: 'towers');
        const t2 = _Item(
            id: 'boom', name: 'Boomerang', image: 'b.webp', type: 'towers');
        const h = _Item(
            id: 'quincy', name: 'Quincy', image: 'q.webp', type: 'heroes');

        state.toggleFavorite(t1);
        state.toggleFavorite(t2);
        state.toggleFavorite(h);

        expect(state.getListOfType('towers'), hasLength(2));
        expect(state.getListOfType('heroes'), hasLength(1));
        expect(state.getListOfType('bloons'), isEmpty);
      });
    });

    // ── getActiveCategories ───────────────────────────────────────────────────

    group('getActiveCategories', () {
      test('returns only categories with items', () {
        expect(state.getActiveCategories(), isEmpty);

        const item = _Item(
            id: 'dart', name: 'Dart Monkey', image: 'd.webp', type: 'towers');
        state.toggleFavorite(item);

        final cats = state.getActiveCategories();
        expect(cats, contains('towers'));
        expect(cats, isNot(contains('heroes')));
      });

      test('category disappears after removing last item', () {
        const item = _Item(
            id: 'dart', name: 'Dart Monkey', image: 'd.webp', type: 'towers');
        state.toggleFavorite(item); // add
        state.toggleFavorite(item); // remove
        expect(state.getActiveCategories(), isEmpty);
      });
    });

    // ── persistence ───────────────────────────────────────────────────────────

    test('favorites persist across FavoriteState instances with same prefs', () async {
      const item = _Item(
          id: 'dart', name: 'Dart Monkey', image: 'd.webp', type: 'towers');
      state.toggleFavorite(item);

      final prefs = await SharedPreferences.getInstance();
      final state2 = FavoriteState(prefs);
      expect(state2.isFavorite('towers', 'dart'), isTrue);
    });
  });
}
