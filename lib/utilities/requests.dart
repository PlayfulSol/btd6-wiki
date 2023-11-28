import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/models/maps/map.dart';
import '/models/towers/hero.dart';
import '/models/towers/tower.dart';
import '../models/base/basic_bloon.dart';
import '/utilities/global_state.dart';
import 'constants.dart';

// Towers
Future<void> getTowers() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/towers.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.towers = parsedConfig.map((e) => TowerModel.fromJson(e)).toList();
  GlobalState.towerTypes =
      GlobalState.towers.map((e) => e.type).toSet().toList();
}

// Heroes
Future<void> getHeroes() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/heroes.json');
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
  final jsonConfig = await rootBundle.loadString('$configDirectory/maps.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.maps = parsedConfig.map((e) => MapModel.fromJson(e)).toList();
}

Future<void> getBloons() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/bloons.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.bloons =
      parsedConfig.map((e) => BaseBloonModel.fromJson(e)).toList();
}

Future<void> getBosses() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/bosses.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.bosses =
      parsedConfig.map((e) => BaseBloonModel.fromJson(e)).toList();
}
