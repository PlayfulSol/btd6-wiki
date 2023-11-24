import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '/models/bloons/basic_bloon.dart';
import '/models/hero.dart';
import '/models/tower.dart';
import '/models/map.dart';

import '/utilities/global_state.dart';

// Towers
Future<void> getTowers() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/towers.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.towers = parsedConfig.map((e) => TowerModel.fromJson(e)).toList();
  GlobalState.towerTypes =
      GlobalState.towers.map((e) => e.type).toSet().toList();
}

// Heroes
Future<void> getHeroes() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/heroes.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.menuHeroes =
      parsedConfig.map((e) => MenuHeroModel.fromJson(e)).toList();
}

// Bloons
Future<void> getBloonsData() async {
  getBosses();
  getBloons();
}

// Maps
Future<void> getMaps() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/maps.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.maps = parsedConfig.map((e) => MapModel.fromJson(e)).toList();
}

Future<void> getBloons() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/bloons.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.bloons =
      parsedConfig.map((e) => BasicBloonModel.fromJson(e)).toList();
}

Future<void> getBosses() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/bosses.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.bosses =
      parsedConfig.map((e) => BasicBossModel.fromJson(e)).toList();
}
