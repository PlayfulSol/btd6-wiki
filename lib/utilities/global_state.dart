import 'package:btd6wiki/models/bloons/basic_bloon.dart';
import 'package:btd6wiki/models/hero.dart';
import 'package:btd6wiki/models/tower.dart';
import 'package:flutter/material.dart';
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
