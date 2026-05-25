import 'package:flutter_test/flutter_test.dart';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:btd6wiki/utilities/constants.dart';

void main() {
  group('GlobalState', () {
    late GlobalState state;

    setUp(() => state = GlobalState());

    // ── Initial values ────────────────────────────────────────────────────────

    group('initial values', () {
      test('starts on towers page', () {
        expect(state.currentPageIndex, kTowersIndex);
        expect(state.activeCategory, kTowers);
      });

      test('isSearchEnabled defaults to false', () {
        expect(state.isSearchEnabled, isFalse);
      });

      test('currentOption defaults to All', () {
        expect(state.currentOption, 'All');
      });

      test('optionForCategory defaults to All for any category', () {
        expect(state.optionForCategory(kTowers), 'All');
        expect(state.optionForCategory(kHeroes), 'All');
        expect(state.optionForCategory(kBloons), 'All');
        expect(state.optionForCategory(kMaps), 'All');
      });

      test('currentQuery defaults to empty string', () {
        expect(state.currentQuery, '');
      });
    });

    // ── updateCurrentPage ─────────────────────────────────────────────────────

    group('updateCurrentPage', () {
      test('updates page index, category and title', () {
        state.updateCurrentPage('heroes', kHeroesIndex);
        expect(state.currentPageIndex, kHeroesIndex);
        expect(state.activeCategory, 'heroes');
      });

      test('displayTitle capitalises the page name when no filter', () {
        state.updateCurrentPage('towers', kTowersIndex);
        expect(state.displayTitle, 'Towers');
      });

      test('notifies listeners', () {
        int count = 0;
        state.addListener(() => count++);
        state.updateCurrentPage('maps', kMapsIndex);
        expect(count, 1);
      });
    });

    // ── optionForCategory ─────────────────────────────────────────────────────

    group('optionForCategory', () {
      test('is independent of activeCategory', () {
        state.updateCurrentPage('heroes', kHeroesIndex);
        state.updateCurrentOptionSelected(category: kTowers, option: 'Primary');

        expect(state.optionForCategory(kTowers), 'Primary');
        expect(state.optionForCategory(kHeroes), 'All');
      });

      test('each category tracks its own value', () {
        state.updateCurrentOptionSelected(category: kTowers, option: 'Magic');
        state.updateCurrentOptionSelected(category: kHeroes, option: 'Hard');
        state.updateCurrentOptionSelected(category: kBloons, option: 'MOAB');
        state.updateCurrentOptionSelected(category: kMaps, option: 'Expert');

        expect(state.optionForCategory(kTowers), 'Magic');
        expect(state.optionForCategory(kHeroes), 'Hard');
        expect(state.optionForCategory(kBloons), 'MOAB');
        expect(state.optionForCategory(kMaps), 'Expert');
      });
    });

    // ── updateCurrentOptionSelected ───────────────────────────────────────────

    group('updateCurrentOptionSelected', () {
      test('explicit category overrides activeCategory', () {
        state.updateCurrentPage('heroes', kHeroesIndex); // active = heroes
        state.updateCurrentOptionSelected(category: kTowers, option: 'Military');

        expect(state.optionForCategory(kTowers), 'Military');
        expect(state.optionForCategory(kHeroes), 'All'); // unchanged
      });

      test('no category falls back to activeCategory', () {
        state.updateCurrentPage('maps', kMapsIndex);
        state.updateCurrentOptionSelected(option: 'Expert');
        expect(state.optionForCategory(kMaps), 'Expert');
      });

      test('notifies listeners', () {
        int count = 0;
        state.addListener(() => count++);
        state.updateCurrentOptionSelected(category: kTowers, option: 'Primary');
        expect(count, 1);
      });
    });

    // ── displayTitle ──────────────────────────────────────────────────────────

    group('displayTitle', () {
      test('plain title when option is All', () {
        state.updateCurrentPage('towers', kTowersIndex);
        expect(state.displayTitle, 'Towers');
      });

      test('appends filter name for non-hero categories', () {
        state.updateCurrentPage('towers', kTowersIndex);
        state.updateCurrentOptionSelected(option: 'Magic');
        expect(state.displayTitle, 'Towers — Magic');
      });

      test('appends Start suffix for heroes', () {
        state.updateCurrentPage('heroes', kHeroesIndex);
        state.updateCurrentOptionSelected(option: 'Hard');
        expect(state.displayTitle, 'Heroes — Hard Start');
      });

      test('reflects active category option, not a different category', () {
        state.updateCurrentOptionSelected(category: kTowers, option: 'Primary');
        state.updateCurrentPage('heroes', kHeroesIndex); // switch page
        // displayTitle should use heroes option (All), not towers option
        expect(state.displayTitle, 'Heroes');
      });
    });

    // ── search ────────────────────────────────────────────────────────────────

    group('search', () {
      test('switchSearch toggles isSearchEnabled', () {
        expect(state.isSearchEnabled, isFalse);
        state.switchSearch();
        expect(state.isSearchEnabled, isTrue);
        state.switchSearch();
        expect(state.isSearchEnabled, isFalse);
      });

      test('search enabled state is per-category', () {
        state.updateCurrentPage('towers', kTowersIndex);
        state.switchSearch();

        state.updateCurrentPage('heroes', kHeroesIndex);
        expect(state.isSearchEnabled, isFalse);

        state.updateCurrentPage('towers', kTowersIndex);
        expect(state.isSearchEnabled, isTrue);
      });

      test('updateCurrentQuery stores per category', () {
        state.updateCurrentPage('towers', kTowersIndex);
        state.updateCurrentQuery('dart');

        state.updateCurrentPage('heroes', kHeroesIndex);
        state.updateCurrentQuery('quincy');

        state.updateCurrentPage('towers', kTowersIndex);
        expect(state.currentQuery, 'dart');

        state.updateCurrentPage('heroes', kHeroesIndex);
        expect(state.currentQuery, 'quincy');
      });

      test('clearing query sets empty string', () {
        state.updateCurrentQuery('dart');
        state.updateCurrentQuery('');
        expect(state.currentQuery, '');
      });
    });
  });
}
