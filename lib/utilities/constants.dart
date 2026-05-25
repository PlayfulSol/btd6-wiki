import 'package:flutter/material.dart';

const String kTowers = 'towers';
const String kHeroes = 'heroes';
const String kBloons = 'bloons';
const String kBlimps = 'blimps';
const String kBosses = 'bosses';
const String kMaps = 'maps';

const int gameVersion = 54;

const int kTowersIndex = 0;
const int kHeroesIndex = 1;
const int kBloonsIndex = 2;
const int kMapsIndex = 3;

const Duration snackBarDuration = Duration(seconds: 2);

const List<String> capTitles = [
  'Towers',
  'Heroes',
  'Bloons & Bosses',
  'Maps',
];

const List<String> simpleTitles = [
  'towers',
  'heroes',
  'bloons',
  'maps',
];


const configDirectory = 'assets/data/index';
const towerDataPath = 'assets/data/towers/';
const heroDataPath = 'assets/data/heroes/';
const mapDataPath = 'assets/data/maps/';
const bloonsDataPath = 'assets/data/bloons/';
const bossesDataPath = 'assets/data/bosses/';


const Map<String, String> pathsDictionary = {
  'path1': 'Top Path',
  'path2': 'Middle Path',
  'path3': 'Bottom Path',
  'paragon': 'Paragon',
};

const List<String> mapDifficulties = [
  'All',
  'Beginner',
  'Intermediate',
  'Advanced',
  'Expert'
];

const List<String> towerTypes = [
  'All',
  'Primary',
  'Military',
  'Magic',
  'Support',
];

const List<String> bloonTypes = [
  'All',
  'Bloons',
  'MOAB',
  'Bosses',
];

// All thresholds use $650 — the round 1 starting cash for each difficulty.
// Hard and CHIMPS share prices so "CHIMPS Ready" covers both.
const List<String> heroPriceRanges = [
  'All',
  'Easy',    // easy ≤ $650
  'Medium',  // medium ≤ $650
  'Hard',    // hard ≤ $650
  'Impop',   // impoppable ≤ $650
];

const Map<String, Map<String, String>> mapDifficultyToReward = {
  'Beginner': {
    'easy': '75\$',
    'medium': '125\$',
    'hard': '200\$',
    'impoppable': '300\$',
  },
  'Intermediate': {
    'easy': '150\$',
    'medium': '250\$',
    'hard': '400\$',
    'impoppable': '600\$',
  },
  'Advanced': {
    'easy': '225\$',
    'medium': '375\$',
    'hard': '600\$',
    'impoppable': '900\$',
  },
  'Expert': {
    'easy': '300\$',
    'medium': '500\$',
    'hard': '800\$',
    'impoppable': '1200\$',
  },
};

const Map<String, String> bossImageLabels = {
  'normal': 'Normal',
  'defeated': 'Defeated',
  'elite': 'Elite',
  'eliteDefeated': 'Elite Defeated',
};

// ── BTD6 semantic game colors ────────────────────────────────────────────────
class GameColors {
  GameColors._();

  /// Primary Monkeys (blue)
  static const primary = Color(0xFF1E88E5);

  /// Military Monkeys (olive green)
  static const military = Color(0xFF6B8E23);

  /// Magic Monkeys (purple)
  static const magic = Color(0xFF8E24AA);

  /// Support Monkeys (orange)
  static const support = Color(0xFFFB8C00);

  /// Upgrade / XP gold
  static const upgrade = Color(0xFFF4BE1A);

  /// Hero accent (monkey brown)
  static const hero = Color(0xFF9C6634);

  /// Red Bloon / danger
  static const danger = Color(0xFFE53935);

  /// MOAB-class bloons (dark navy)
  static const moab = Color(0xFF0D47A1);

  /// Favourite star
  static const favourite = Colors.amber;

  static Color forClass(String classType) {
    switch (classType) {
      case 'Primary':
        return primary;
      case 'Military':
        return military;
      case 'Magic':
        return magic;
      case 'Support':
        return support;
      default:
        return const Color(0xFF757575); // grey for unknown
    }
  }
}

/// Shared title style for all SliverAppBar titles.
const TextStyle sliverTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

// ── Text styles ───────────────────────────────────────────────────────────────
const TextStyle subtitleStyle = TextStyle(
  fontSize: 13,
);

const TextStyle normalStyle = TextStyle(
  fontSize: 16,
);

const TextStyle bolderNormalStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle smallTitleStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
);

const TextStyle titleStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
);

const TextStyle bigTitleStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

const String googleLink =
    'https://play.google.com/store/apps/details?id=playfulsolutions.uobtd6wiki';

const String playfulEmail = 'Playfulsols@gamil.com';
const String playfulGitRepo = 'https://github.com/PlayfulSol/flutter-btd6-wiki';

const String name = 'name';
const String email = 'email';
const String gitRepo = 'git_repo';
const String git = 'git';
const String linkedin = 'linkedin';

const Map<String, String> asaf = {
  name: 'Asaf Hadad',
  email: 'asaf147369@gmail.com',
  git: 'https://github.com/asaf147369',
  linkedin: 'https://www.linkedin.com/in/asaf-hadad/',
};

const Map<String, String> shai = {
  name: 'Shai Holczer',
  email: 'shaitnto@gmail.com',
  git: 'https://github.com/namelessto',
  linkedin: 'https://www.linkedin.com/in/shai-holczer/',
};

const String skinCrossCount = 'skinCrossAxisCount';
const String skinAspectRatio = 'skinChildAspectRatio';

const String favItemCrossCount = 'favItemCrossCount';
const String favItemAspectRatio = 'favItemAspectRatio';
const String favItemSubtitleStyle = 'favItemSubtitleStyle';
const String favItemImageFlex = 'favItemImageFlex';
const String favItemTextFlex = 'favItemTextFlex';
