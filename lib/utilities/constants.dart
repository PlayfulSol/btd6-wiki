import 'package:flutter/material.dart';
import '/presentation/screens/maps/maps.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/tower/towers.dart';

String configDirectory = 'assets/data/config';

const List<String> titles = [
  'Towers',
  'Heroes',
  'Bloons',
  'Maps',
];

const List<String> drawrTitles = [
  'Towers',
  'Heroes',
  'Bloons & Bosses',
  'Maps',
];

List<Widget> pages = [
  const Towers(key: PageStorageKey<String>('Towers'), towerType: ''),
  const Heroes(key: PageStorageKey<String>('Heroes')),
  const Bloons(key: PageStorageKey<String>('Bloons')),
  const Maps(key: PageStorageKey<String>('Maps'), mapDifficulty: ''),
];

const towerDataPath = 'assets/data/towers/';
const heroDataPath = 'assets/data/heroes/';
const bloonsDataPath = 'assets/data/bloons/';
const minionsDataPath = 'assets/data/minions/';
const bossesDataPath = 'assets/data/bosses/';

PageController pageController = PageController(initialPage: 0);

const Map<String, String> statsDictionary = {
  'damage': 'Damage',
  'pierce': 'Pierce',
  'attackSpeed': 'Attack Speed',
  'range': 'Range',
  'statusEffects': 'Status Effects',
  'towerBoosts': 'Tower Boosts',
  'incomeBoosts': 'Income Boosts',
  'camo': 'Camo',
  'levelSpeed': 'Level Speed',
};

const Map<String, String> pathsDictionary = {
  'path1': 'Top Path',
  'path2': 'Middle Path',
  'path3': 'Bottom Path',
  'paragon': 'Paragon',
};

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

const Map<String, dynamic> constraintsNormalPreset = {
  "crossAxisCount": 1,
  "rowsToShow": 2,
  "childAspectRatio": 3.15,
  "titleFontSize": 18.0,
  "subtitleFontSize": 15.0,
};

const Map<String, dynamic> constraintsWidePreset = {
  "crossAxisCount": 2,
  "rowsToShow": 3,
  "childAspectRatio": 2.4,
  "titleFontSize": 20.0,
  "subtitleFontSize": 16.0,
};

const Map<String, dynamic> constraintsUWPreset = {
  "crossAxisCount": 3,
  "rowsToShow": 3,
  "childAspectRatio": 2.0,
  "titleFontSize": 24.0,
  "subtitleFontSize": 15.0,
};

const Map<String, dynamic> constraintsBloonNormalPreset = {
  "crossAxisCount": 2,
  "crossAxisCountBoss": 1,
  "childAspectRatio": 2.1,
  "childAspectRatioBoss": 4.3,
  "subtitleFontSize": 16.0,
};

const Map<String, dynamic> constraintsBloonWidePreset = {
  "crossAxisCount": 3,
  "crossAxisCountBoss": 2,
  "childAspectRatio": 2.2,
  "childAspectRatioBoss": 2.8,
  "titleFontSize": 24.0,
  "subtitleFontSize": 15.0,
};
