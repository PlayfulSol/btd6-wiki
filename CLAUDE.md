# BTD6 Wiki — Claude Project Rules

## Project Overview

Flutter wiki app for Bloons Tower Defense 6. Targets Android, iOS, and web.
Version: 0.9.0. Min SDK: 21, Target: 35.

## Key Dependencies

| Package | Purpose |
|---|---|
| `go_router ^14` | Navigation |
| `provider ^6` | State management |
| `adaptive_theme ^3` | System light/dark switching |
| `carousel_slider ^5` | Image carousels on detail pages |
| `smooth_page_indicator ^1` | Dot indicators for carousels |
| `auto_size_text ^3` | Grid card name labels |
| `firebase_analytics ^10` | Analytics events |
| `shared_preferences ^2` | Favorites persistence |

No `json_serializable` — all models use hand-written `fromJson` constructors.

## Architecture

### Data loading
- **Startup**: `requests.dart` loads index files (`assets/data/index/*.json`) into `BaseModel` lists. These are passed to `MyHomePage` via `baseEntities` map.
- **Detail pages**: load their own full JSON from `assets/data/<category>/<id>.json` inside `initState` using `rootBundle.loadString`.
- Data paths are constants in `constants.dart`: `towerDataPath`, `heroDataPath`, `bloonsDataPath`, `bossesDataPath`, `mapDataPath`, `minionsDataPath`.

### State
- `GlobalState` (Provider): current page index, search query, filter option.
- `FavoriteState` (Provider): favorites list backed by `SharedPreferences` + Hive.
- Both consumed via `Consumer<T>` or `context.read/watch`.

### Navigation (go_router)
Routes are defined in `utilities/router.dart`:
```
/towers          → MyHomePage (index 0)
/towers/:id      → SingleTower
/heroes          → MyHomePage (index 1)
/heroes/:id      → SingleHero
/bloons          → MyHomePage (index 2)
/bloons/:id      → SingleBloon
/bosses/:id      → BossBloon
/maps            → MyHomePage (index 3)
/maps/:id        → SingleMap
/favorites       → FavoriteScreen
/minions/:id     → MinionBloonPage
```

**Navigation rules:**
- Use `context.push()` when drilling from a list into a detail page.
- Use `context.go()` when navigating *laterally* between same-type pages (e.g., bloon → related bloon). This resets the stack so back always returns to the list.
- Use `context.go()` for bottom nav tab switches.

## UI Conventions

### Detail page structure
All detail pages follow the same pattern:

```dart
// 1. Loading guard — always include AppBar so back button is available
if (loading) {
  return Scaffold(
    appBar: AppBar(),
    body: const Center(child: CircularProgressIndicator()),
  );
}

// 2. Main body — SliverAppBar with image/carousel header
// Title goes on SliverAppBar.title (NOT FlexibleSpaceBar.title — image area stays clean)
// expandedHeight is always 300
// bgAlpha adapts to dark/light mode: 0.28 dark, 0.15 light
final bgAlpha = Theme.of(context).brightness == Brightness.dark ? 0.28 : 0.15;

return Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 300,
        pinned: true,
        stretch: true,
        title: Text(name, style: sliverTitleStyle),  // ← title here, not in FlexibleSpaceBar
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(fit: StackFit.expand, children: [
            ColoredBox(color: accentColor.withValues(alpha: bgAlpha)),
            // image or carousel
            // bottom fade: accentColor(alpha:0) → colorScheme.surface
          ]),
        ),
      ),
      SliverToBoxAdapter(child: Padding(..., child: Column(...))),
    ],
  ),
);
```

### Uniformity rules — two levels

**Component-level** (applies to every page — non-negotiable):
- All labeled content sections → `PropertyCard` (`lib/presentation/widgets/common/property_card.dart`)
- All label/value pairs → `StatRow` (`lib/presentation/widgets/common/stat_row.dart`)
- Section spacing: **12px** between every card/section, **4px** between `StatRow` items inside a card. Never use 16px as a section separator — 16px is only acceptable as trailing bottom padding at the end of a scrollable column.
- Any `ListView.builder` used inside a `Column` (e.g. for paths or levels) must set `padding: EdgeInsets.zero` — without it Flutter adds implicit top/bottom padding that breaks the 12px section rhythm.
- Badge chip below the header for the entity's category (difficulty, class, etc.)
- `sliverTitleStyle` for all AppBar titles (20px bold, no shadow)

**Layout-level** (applies only to pages with analogous content):
- **Tower and Hero** share the same layout template:
  `Description card → Stats card → Cost card → Changes → rest`
  - Targeting (hero) is a `StatRow` inside the Stats card, same as Camo (tower)
- **Bloon, Boss, Minion, Map** each have their own content structure — use the same *components* but don't force the tower/hero column arrangement onto them

### Shared detail-page widgets
| Widget | File | Purpose |
|---|---|---|
| `PropertyCard` | `widgets/common/property_card.dart` | Card with tinted header strip (primary title, `surfaceContainerHighest` bg) + content area `fromLTRB(14,10,14,12)`; requires `clipBehavior: Clip.antiAlias` |
| `StatRow` | `widgets/common/stat_row.dart` | Flex 2:3 bold-label / value row |
| `CarouselWithIndicator` | `widgets/common/carousel_with_indicator.dart` | Carousel + dots; used inside level cards |

For pages with a carousel header (boss, minion, hero_skins): the dot indicator goes in a `SliverToBoxAdapter` immediately below the `SliverAppBar`, not inside the image area. Exception: hero main page puts the indicator `Positioned(bottom: 12)` inside the header Stack so it overlays the image.

### Accent colors by section
Each page uses an accent color for the header background and badge chip. Apply it with adaptive alpha (`bgAlpha = brightness == dark ? 0.28 : 0.15`), never a hardcoded `0.18`.

| Section | Accent |
|---|---|
| Towers | `GameColors.forClass(tower.classType)` (Primary=blue, Military=olive, Magic=purple, Support=orange) |
| Heroes | `GameColors.hero` (`#9C6634` monkey brown) |
| Bloons | `colorScheme.tertiaryContainer` (or `GameColors.moab` for MOAB-class) |
| Bosses & Minions | `GameColors.danger` (`#E53935` red) |
| Maps (difficulty) | `difficultyColor()` from `map_card.dart` |

### GameColors semantic palette (`constants.dart`)
```dart
GameColors.primary   // #1E88E5 — Primary Monkeys
GameColors.military  // #6B8E23 — Military Monkeys
GameColors.magic     // #8E24AA — Magic Monkeys
GameColors.support   // #FB8C00 — Support Monkeys
GameColors.upgrade   // #F4BE1A — XP/upgrade gold
GameColors.hero      // #9C6634 — Hero accent
GameColors.danger    // #E53935 — Red Bloon / boss danger
GameColors.moab      // #0D47A1 — MOAB-class bloons
GameColors.forClass(classType) // returns the right color for a tower class
```

### Theme
- `AdaptiveTheme` with `Themes.lightTheme` / `Themes.darkTheme` in `themes/themes.dart`.
- Color schemes in `themes/color_schemes.g.dart` — dark: deep navy + orange-gold; light: warm parchment + deep amber.
- Never use `Colors.teal` — always use `Theme.of(context).colorScheme.primary`.

### Card layout for grid items (towers, heroes, maps)
MapCard-style: image fills the top (Expanded), separate bottom row with a 4px colored left-border bar + `AutoSizeText` name + subtitle + star icon. Do **not** use gradient overlays on PNG sprites (transparent backgrounds look bad).

### Text styles (all in `constants.dart`)
`subtitleStyle` (13px) · `normalStyle` (16px) · `bolderNormalStyle` (16px w600) · `smallTitleStyle` (19px bold) · `titleStyle` (21px bold) · `bigTitleStyle` (25px bold)

## Models

### Tower models
Two generations exist — use `towers_v2/` for all active code:
- `TowerModelV2` (`models/towers_v2/tower/tower.dart`) — `unlock` field uses `?? ''` fallback
- `HeroModelV2` (`models/towers_v2/hero/hero.dart`)
- `HeroLevelData.image` is `String?` — only present on levels with a portrait change

Old `models/towers/` are legacy; do not add new features there.

### Bloon models
JSON format (new, from fandom dump):
- `rbe` is an `int` — model wraps it as `[rbe.toString()]` for display
- `speed` and `speedRelative` are flat floats — `Speed` is constructed directly, not via `Speed.fromJson`
- `rounds` uses `{normal: {"roundNum": count}, alternate: {...}}` — `Rounds._parseRounds()` converts to `["Round N: count"]` strings
- `children`/`parents` have `{id, count, image}` — no `name` field, derived from `id`
- `variants` have `{id, image, firstAppearance, isCamo, ...}` — `name` and `appearances` are derived

### Map model
`MapModel` fields are all nullable — new JSONs omit fields they don't have. `single_map.dart` guards every section with `if (field != null && field!.isNotEmpty)`.

## Analytics
Use `AnalyticsHelper` (wraps Firebase). Log screen views in `initState`, log widget interactions (`widgetEngagement` event) in callbacks. Constants in `analytics/analytics_constants.dart`.

## Asset structure
```
assets/data/index/       ← startup index JSONs (id, name, type, image only)
assets/data/towers/      ← full tower JSONs
assets/data/heroes/      ← full hero JSONs
assets/data/bloons/      ← full bloon JSONs
assets/data/bosses/      ← full boss JSONs
assets/data/maps/        ← full map JSONs
assets/images/towers/    ← .webp tower portraits
assets/images/heroes/    ← .webp hero portraits
assets/images/bloons/    ← .webp bloon images
assets/images/bosses/    ← .webp boss images
assets/images/maps/      ← .webp map images
assets/images/minions/   ← .webp minion images
```
Image path helpers are in `utilities/images_url.dart` (`towerImage()`, `heroImage()`, `bloonImage()`, `bossImage()`, `minionImage()`, `mapImage()`).
