import 'package:flutter_test/flutter_test.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:btd6wiki/models/base/base_tower.dart';
import 'package:btd6wiki/models/base/base_hero.dart';
import 'package:btd6wiki/models/base/base_bloon.dart';
import 'package:btd6wiki/models/base/base_map.dart';

void main() {
  // ── BaseModel ──────────────────────────────────────────────────────────────

  group('BaseModel.fromJson', () {
    test('parses all required fields', () {
      final m = BaseModel.fromJson({
        'id': 'dart_monkey',
        'name': 'Dart Monkey',
        'image': 'dart_monkey.webp',
        'type': 'towers',
      });
      expect(m.id, 'dart_monkey');
      expect(m.name, 'Dart Monkey');
      expect(m.image, 'dart_monkey.webp');
      expect(m.type, 'towers');
    });

    test('throws on missing required field', () {
      expect(
        () => BaseModel.fromJson({'name': 'X', 'image': 'x.webp', 'type': 'towers'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  // ── BaseTower ──────────────────────────────────────────────────────────────

  group('BaseTower.fromJson', () {
    final json = {
      'id': 'dart_monkey',
      'name': 'Dart Monkey',
      'image': 'dart_monkey.webp',
      'type': 'towers',
      'classType': 'Primary',
      'inGameDesc': 'Shoots darts.',
    };

    test('parses all fields', () {
      final t = BaseTower.fromJson(json);
      expect(t.classType, 'Primary');
      expect(t.inGameDesc, 'Shoots darts.');
    });

    test('throws on missing classType', () {
      final bad = Map<String, dynamic>.from(json)..remove('classType');
      expect(() => BaseTower.fromJson(bad), throwsA(isA<TypeError>()));
    });
  });

  // ── BaseHero ───────────────────────────────────────────────────────────────

  group('BaseHero.fromJson', () {
    Map<String, dynamic> heroJson({dynamic easy = 500, dynamic medium = 600}) => {
          'id': 'quincy',
          'name': 'Quincy',
          'image': 'quincy.webp',
          'type': 'heroes',
          'inGameDesc': 'Bow hero.',
          'cost': {
            'easy': easy,
            'medium': medium,
            'hard': 650,
            'impoppable': 720,
          },
        };

    test('parses numeric costs', () {
      final h = BaseHero.fromJson(heroJson(easy: 460, medium: 540));
      expect(h.easyCost, 460);
      expect(h.mediumCost, 540);
    });

    test('parses string costs — the format in the actual JSON files', () {
      final h = BaseHero.fromJson(heroJson(easy: '460', medium: '540'));
      expect(h.easyCost, 460);
      expect(h.mediumCost, 540);
    });

    test('parses comma-formatted string costs like "1,020"', () {
      final h = BaseHero.fromJson(heroJson(easy: '1,020', medium: '1,200'));
      expect(h.easyCost, 1020);
      expect(h.mediumCost, 1200);
    });

    test('falls back to 0 when cost field is missing', () {
      final json = {
        'id': 'quincy',
        'name': 'Quincy',
        'image': 'quincy.webp',
        'type': 'heroes',
        'inGameDesc': 'Bow hero.',
      };
      final h = BaseHero.fromJson(json);
      expect(h.easyCost, 0);
      expect(h.hardCost, 0);
    });

    test('falls back to 0 for individual missing difficulty keys', () {
      final json = {
        'id': 'quincy',
        'name': 'Quincy',
        'image': 'quincy.webp',
        'type': 'heroes',
        'inGameDesc': 'Bow hero.',
        'cost': {'easy': '460'},
      };
      final h = BaseHero.fromJson(json);
      expect(h.easyCost, 460);
      expect(h.mediumCost, 0);
      expect(h.hardCost, 0);
      expect(h.impoppableCost, 0);
    });
  });

  // ── BaseBloon ──────────────────────────────────────────────────────────────

  group('BaseBloon.fromJson', () {
    Map<String, dynamic> bloonJson({bool? isMoab}) => {
          'id': 'red',
          'name': 'Red Bloon',
          'image': 'red.webp',
          'type': 'bloons',
          if (isMoab != null) 'isMoab': isMoab,
        };

    test('parses isMoab true', () {
      expect(BaseBloon.fromJson(bloonJson(isMoab: true)).isMoab, isTrue);
    });

    test('parses isMoab false', () {
      expect(BaseBloon.fromJson(bloonJson(isMoab: false)).isMoab, isFalse);
    });

    test('defaults isMoab to false when field is absent', () {
      expect(BaseBloon.fromJson(bloonJson()).isMoab, isFalse);
    });
  });

  // ── BaseMap ────────────────────────────────────────────────────────────────

  group('BaseMap.fromJson', () {
    test('parses difficulty', () {
      final m = BaseMap.fromJson({
        'id': 'monkey_meadow',
        'name': 'Monkey Meadow',
        'image': 'monkey_meadow.webp',
        'type': 'maps',
        'difficulty': 'Beginner',
      });
      expect(m.difficulty, 'Beginner');
    });

    test('throws on missing difficulty', () {
      expect(
        () => BaseMap.fromJson({
          'id': 'x',
          'name': 'X',
          'image': 'x.webp',
          'type': 'maps',
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
