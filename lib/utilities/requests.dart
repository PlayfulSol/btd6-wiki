import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '/models/bloons/boss_bloon.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/basic_bloon.dart';
import '/models/hero.dart';
import '/models/tower.dart';
import '/models/map.dart';

import '/utilities/global_state.dart';
import '/utilities/constants.dart';

// Bloons
Future<void> getBloonsData() async {
  getBosses();
  getBloons();
}

Future<dynamic> getBloonData(String id) async {
  GlobalState.isLoading = true;
  var data = await http.get(Uri.parse("$baseApiUrl/bloon/$id"));

  var jsonData = json.decode(data.body);

  GlobalState.isLoading = false;
  if (jsonData['type'] == 'boss') {
    var bossData = BossBloonModel.fromJson(jsonData);
    GlobalState.currentTitle = bossData.name;
    return bossData;
  } else {
    var bloonData = SingleBloonModel.fromJson(jsonData);
    GlobalState.currentTitle = bloonData.name;
    return bloonData;
  }
}

// Heroes
Future<void> getHeroes() async {
  var data = await http.get(Uri.parse("$baseApiUrl/heroes"));

  var jsonData = json.decode(data.body);

  List<HeroModel> heroes = [];

  for (var h in jsonData) {
    HeroModel hero = HeroModel.fromJson(h);

    heroes.add(hero);
  }

  GlobalState.heroes = heroes;
}

Future<HeroModel> getHeroData(towerId) async {
  GlobalState.isLoading = true;

  var data = (await http.get(Uri.parse("$baseApiUrl/hero/$towerId")));

  var jsonData = json.decode(data.body);

  HeroModel heroData = HeroModel.fromJson(jsonData);

  GlobalState.currentTitle = heroData.name;

  GlobalState.isLoading = false;

  return heroData;
}

Future<void> getMaps() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/maps.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.maps = parsedConfig.map((e) => MapModel.fromJson(e)).toList();
}

Future<void> getTowers() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/towers.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.towers = parsedConfig.map((e) => TowerModel.fromJson(e)).toList();
  GlobalState.towerTypes =
      GlobalState.towers.map((e) => e.type).toSet().toList();
}

Future<void> getBloons() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/bloons.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.bloons =
      parsedConfig.map((e) => BasicBloonModel.fromJson(e)).toList();
}

Future<void> getBosses() async {
  var data = await http.get(Uri.parse("$baseApiUrl/bloons"));

  var jsonData = json.decode(data.body);

  List<BasicBossModel> bosses = [];

  for (var b in jsonData) {
    if (b['type'] == 'boss') {
      BasicBossModel boss = BasicBossModel.fromJson(b);

      bosses.add(boss);
    }
  }

  GlobalState.bosses = bosses;
}
