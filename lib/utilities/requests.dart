import 'dart:async';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/models/bloons/boss_bloon.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/basic_bloon.dart';
import '/models/hero.dart';
import '/models/tower.dart';

import '/utilities/constants.dart';

// Bloons
Future<List<BasicBloonModel>> getBloons() async {
  var data = await http.get(Uri.parse("$baseApiUrl/bloons"));

  var jsonData = json.decode(data.body);

  List<BasicBloonModel> bloons = [];

  for (var b in jsonData) {
    BasicBloonModel bloon = BasicBloonModel.fromJson(b);

    bloons.add(bloon);
  }

  return bloons;
}

Future<dynamic> getBloonData(String id) async {
  var data = await http.get(Uri.parse("$baseApiUrl/bloon/$id"));

  var jsonData = json.decode(data.body);

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
Future<List<HeroModel>> getHeroes() async {
  var data = await http.get(Uri.parse("$baseApiUrl/heroes"));

  var jsonData = json.decode(data.body);

  List<HeroModel> heros = [];

  for (var h in jsonData) {
    HeroModel hero = HeroModel.fromJson(h);

    heros.add(hero);
  }

  return heros;
}

Future<HeroModel> getHeroData(towerId) async {
  var data = (await http.get(Uri.parse("$baseApiUrl/hero/$towerId")));

  var jsonData = json.decode(data.body);

  HeroModel heroData = HeroModel.fromJson(jsonData);

  GlobalState.currentTitle = heroData.name;

  return heroData;
}

// Towers
Future<List<TowerModel>> getTowers() async {
  var data = await http.get(Uri.parse("$baseApiUrl/towers"));

  var jsonData = json.decode(data.body);

  List<TowerModel> towers = [];

  for (var t in jsonData) {
    TowerModel tower = TowerModel.fromJson(t);
    towers.add(tower);
  }

  return towers;
}

Future<SingleTowerModel> getTowerData(towerId) async {
  var data = (await http.get(Uri.parse("$baseApiUrl/tower/$towerId")));

  var jsonData = json.decode(data.body);

  SingleTowerModel towerData = SingleTowerModel.fromJson(jsonData);

  GlobalState.currentTitle = towerData.name;

  return towerData;
}
