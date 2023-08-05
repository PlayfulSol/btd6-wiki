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
const heroDataPath = 'assets/data/heroes/';

PageController pageController = PageController();
