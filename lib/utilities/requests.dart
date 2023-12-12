import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:async';
import '/models/base/base_tower.dart';
import '/models/base/base_hero.dart';
import '/models/base/base_map.dart';
import '/models/base_model.dart';
import 'constants.dart';

// ---- Towers ----
Future<List<BaseTower>> loadBaseTowers() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/towers.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);

  return parsedConfig.map((e) => BaseTower.fromJson(e)).toList();
}

// ---- Heroes ----
Future<List<BaseHero>> loadBaseHeroes() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/heroes.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);

  return parsedConfig.map((e) => BaseHero.fromJson(e)).toList();
}

// ---- Maps ----
Future<List<BaseMap>> loadBaseMaps() async {
  final jsonConfig = await rootBundle.loadString('$configDirectory/maps.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);

  return parsedConfig.map((e) => BaseMap.fromJson(e)).toList();
}

// ---- Bloons ----
Future<List<BaseModel>> loadBaseBloons() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/bloons.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);

  return parsedConfig.map((e) => BaseModel.fromJson(e)).toList();
}

// ---- Bosses ----
Future<List<BaseModel>> loadBaseBosses() async {
  final jsonConfig =
      await rootBundle.loadString('$configDirectory/bosses.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);

  return parsedConfig.map((e) => BaseModel.fromJson(e)).toList();
}
