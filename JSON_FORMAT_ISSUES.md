# JSON Format Issues & Model Inconsistencies

Issues found in code that still references old JSON formats or has unclear/broken model logic
following the v2 model refactor and bloon JSON migration.

---

## 1. `MinionBloon` uses `Speed.fromJson` — expects old `{absolute, relative}` map format

**File:** `lib/models/bloons/boss/minion_bloon.dart:28`

```dart
speed = Speed.fromJson(json["speed"] as Map<String, dynamic>),
```

`Speed.fromJson` reads `json['absolute']` and `json['relative']` from a map. But the new bloon
JSON format uses flat floats (`speed`, `speedRelative`) at the top level — and `BloonModel` already
constructs `Speed` directly without `fromJson`. If minion JSONs have migrated to the same flat format,
this cast will throw a runtime error.

**Expected fix:** Check actual minion JSON structure. If flat, change to:
```dart
speed = Speed(
  absolute: (json['speed'] as num?)?.toString() ?? 'N/A',
  relative: (json['speedRelative'] as num?)?.toString() ?? 'N/A',
),
```

---

## 2. `Relative.fromJson` retains old `value` key fallback alongside new `count`

**File:** `lib/models/bloons/common/relative_class.dart:18`

```dart
final rawValue = json['value'] ?? json['count'] ?? 1;
```

The comment in the file says "New JSON uses `count` (int); old format used `value` (string)". If all
bloon JSONs have been migrated to the new format, the `json['value']` check is dead code and should
be removed.

---

## 3. `Rounds.fromJson` accepts both old list format and new map format

**File:** `lib/models/bloons/bloon/rounds_class.dart:9, 14`

```dart
abr = _parseRounds(json['alternate'] ?? json['abr']);
// ...
if (data is List) return List<String>.from(data);   // old format
if (data is Map) { ... }                            // new format
```

Two shims remain:
- Key fallback: old JSONs used key `abr`, new ones use `alternate`
- Data fallback: old value was `List<String>`, new format is `Map<roundNum, count>`

If all bloon JSONs are migrated, both the `json['abr']` key and the `is List` branch are dead code.

---

## 4. `HeroLevelData.fromJson` has `body` fallback for `description`

**File:** `lib/models/towers_v2/common/hero_level_class.dart:15`

```dart
description = json['description'] ?? json['body'] ?? '',
```

`body` was the old key. If all hero JSONs have been updated to use `description`, this fallback
is dead code and should be cleaned up.

---

## 5. `TowerUpgrade.fromJson` has `body` fallback for `upgradeBody`

**File:** `lib/models/towers_v2/common/upgrade_class.dart:17`

```dart
upgradeBody = json['upgradeBody'] ?? json['body'] ?? '',
```

Same pattern as above. `body` was the old field name. Dead fallback if all tower JSONs use
`upgradeBody`.

---

## 6. Old v1 tower/hero models are unreferenced dead code

The entire `lib/models/towers/` directory (except `cost_class.dart`) is dead. None of these classes
are imported by any screen or widget:

| File | Dead class |
|---|---|
| `lib/models/towers/tower/tower.dart` | `TowerModel` |
| `lib/models/towers/hero/hero.dart` | `HeroModel` |
| `lib/models/towers/tower/monkey_paths.dart` | `MonkeyPathsModel` |
| `lib/models/towers/common/stats_class.dart` | `Stats` (v1), `HeroStats` |
| `lib/models/towers/common/upgrade_info_class.dart` | `UpgradeInfo` |
| `lib/models/towers/hero/hero_skins.dart` | `Skins` |

`cost_class.dart` is still actively shared by v2 models and `utils.dart`, so it should stay.
Everything else in `models/towers/` can be deleted.

---

## 7. `Cost.fromJson` silently corrupts data on error

**File:** `lib/models/towers/common/cost_class.dart:14–26`

```dart
Cost.fromJson(dynamic json) {
  try {
    easy = json['easy'];
    ...
  } catch (e) {
    easy = json;    // sets all fields to the raw json value
    medium = json;
    hard = json;
    impoppable = json;
  }
}
```

The catch was a fallback for old flat-cost JSONs (`"cost": "$500"` instead of a map). It silently
sets all four cost fields to whatever the raw value is. Any real parsing error (null map, missing key)
will produce garbage cost values with no warning. The catch should be removed; the flat-cost format
should no longer exist.

---

## 8. `BloonModel.rbe` is typed `List<dynamic>` but always contains one `String`

**File:** `lib/models/bloons/bloon/bloon.dart:15, 51`

```dart
late final List<dynamic> rbe;
// fromJson:
rbe = [(json['rbe'] ?? 0).toString()],
```

The new bloon JSON has `rbe` as a plain `int`. The model wraps it in a list to satisfy
`BloonAidWidget` which accepts `dynamic data` and dispatches on `List<String>`. The type should
be `List<String>` (not `List<dynamic>`), and a short comment explaining the wrapping would
prevent future confusion.

---

## 9. `navigateToPage` in `utils.dart` has no route for `kMinions`

**File:** `lib/utilities/utils.dart:28–36`

```dart
Map<String, String> routes = {
  kTowers: '/towers/${item.id}',
  kHeroes: '/heroes/${item.id}',
  kBloons: '/bloons/${item.id}',
  kBlimps: '/bloons/${item.id}',
  kBosses: '/bosses/${item.id}',
  kMaps: '/maps/${item.id}',
  // kMinions is missing
};
context.push(routes[item.type]!);  // throws on null if type == kMinions
```

Minions are currently not reachable through `navigateToPage`, so this doesn't crash today. But
if minion items are ever passed here (e.g. from favorites), it throws a null assertion error.
Add `kMinions: '/minions/${item.id}'`.

---

## 10. `costToString` and `statsToString` in `utils.dart` are never called

**File:** `lib/utilities/utils.dart:66–72`

```dart
String costToString(Cost cost) { ... }
String statsToString(Stats stats) { ... }
```

These functions are defined but have zero callers anywhere in the codebase. They're dead utility
functions left over from before the UI used `StatRow`/`PropertyCard`. Can be deleted.

---

## 11. Minion page logs analytics under `kBossPagesClass` — no minion-specific constant exists

**File:** `lib/presentation/screens/bloon/minion_bloon.dart:54`

```dart
widget.analyticsHelper.logScreenView(
  screenClass: kBossPagesClass,   // ← should be kMinionPagesClass
  screenName: widget.minionId,
);
```

There is no `kMinionPagesClass` constant in `analytics_constants.dart`. Minion page views are
attributed to boss pages in analytics, making it impossible to distinguish them. Add
`const String kMinionPagesClass = 'minion_pages';` and use it here.

---

## 12. `BloonModel.fullName` silently falls back to `json['name']`

**File:** `lib/models/bloons/bloon/bloon.dart:43`

```dart
fullName = json['fullName'] as String? ?? json['name'] as String,
```

It's not documented whether `fullName` is guaranteed to exist in all new bloon JSONs. If it is,
the fallback to `name` is dead. If it isn't (some bloons don't have a full name field), this
should have a comment explaining which bloons lack the field and why.

---

## 13. Legacy `UpgradeInfo` constructor signature doesn't match its fields

**File:** `lib/models/towers/common/upgrade_info_class.dart:9–14`

```dart
UpgradeInfo(name, description, cost, effects);  // constructor params
// but the class fields are: name, image, upgradeBody, cost
```

The positional constructor parameters (`description`, `effects`) don't correspond to the stored
fields (`image`, `upgradeBody`). This class is dead code (part of issue #6), but signals it was
abandoned mid-refactor.

---

## Summary

| # | Severity | Category | File |
|---|---|---|---|
| 1 | High | Runtime crash risk | `minion_bloon.dart` model |
| 7 | High | Silent data corruption | `cost_class.dart` |
| 9 | Medium | Runtime null crash | `utils.dart` |
| 2 | Low | Dead shim code | `relative_class.dart` |
| 3 | Low | Dead shim code | `rounds_class.dart` |
| 4 | Low | Dead shim code | `hero_level_class.dart` |
| 5 | Low | Dead shim code | `upgrade_class.dart` |
| 6 | Low | Dead code | `models/towers/` (v1) |
| 8 | Low | Type confusion | `bloon.dart` |
| 10 | Low | Dead code | `utils.dart` |
| 11 | Low | Analytics gap | `minion_bloon.dart` screen |
| 12 | Low | Undocumented behavior | `bloon.dart` |
| 13 | Low | Dead code | `upgrade_info_class.dart` |
