import 'package:flutter/material.dart';

import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/tower/towers.dart';

// OLD API
// const baseApiUrl = 'https://statsnite.com/api/btd/v3';
const baseImageUrl = 'https://statsnite.com/images/btd';

// NEW API
const baseApiUrl = 'http://172.28.224.1:3000';

const List<String> titles = [
  'Towers',
  'Heroes',
  'Bloons',
];

List<Widget> pages = [
  const Towers(
    key: PageStorageKey<String>('Towers'),
    towerType: '',
  ),
  const Heroes(key: PageStorageKey<String>('Heroes')),
  const Bloons(key: PageStorageKey<String>('Bloons')),
];

PageController pageController = PageController();
