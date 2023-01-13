import 'package:flutter/material.dart';

import '/models/bloons/basic_bloon.dart';
import '/models/hero.dart';
import '/models/tower.dart';

import '/utilities/themes.dart';

class GlobalState {
  GlobalState._();

  static String currentTitle = '';
  static ThemeData currentTheme = Themes.darkTheme;
  static bool isLoading = false;
  static List<TowerModel> towers = [];
  static List<HeroModel> heroes = [];
  static List<BasicBloonModel> bloons = [];
}
