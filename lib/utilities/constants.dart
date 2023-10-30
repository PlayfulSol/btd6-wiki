import 'package:flutter/material.dart';

import '/presentation/screens/maps/maps.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/tower/towers.dart';

const baseApiUrl = 'https://statsnite.com/api/btd/v3';

const baseImageUrl = 'https://statsnite.com/images/btd';

const List<String> titles = [
  'Towers',
  'Heroes',
  'Bloons',
  'Maps',
];

List<Widget> pages = [
  const Towers(key: PageStorageKey<String>('Towers'), towerType: ''),
  const Heroes(key: PageStorageKey<String>('Heroes')),
  const Bloons(key: PageStorageKey<String>('Bloons')),
  const Maps(key: PageStorageKey<String>('Maps'), mapDifficulty: ''),
];

const towerDataPath = 'assets/data/towers/';
const bloonsDataPath = 'assets/data/bloons/';
const heroDataPath = 'assets/data/heroes/';

PageController pageController = PageController(initialPage: 0);

Map<String, String> statsDictionary = {
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

Map<String, String> pathsDictionary = {
  'path1': 'Top Path',
  'path2': 'Middle Path',
  'path3': 'Bottom Path',
  'paragon': 'Paragon',
};
