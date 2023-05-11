import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/models/bloons/boss_bloon.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/basic_bloon.dart';
import '/models/hero.dart';
import '/models/tower.dart';

import '/utilities/global_state.dart';
import '/utilities/constants.dart';

// Bloons
Future<void> getBosses() async {
  var data = await http.get(Uri.parse("$baseApiUrl/bosses"));
  var jsonData = json.decode(data.body);

  List<BasicBloonModel> bosses = [];
  for (var b in jsonData) {
    BasicBloonModel boss = BasicBloonModel.fromJson(b);
    bosses.add(boss);
  }

  GlobalState.bosses = bosses;
}

Future<void> getBloons() async {
  var data = await http.get(Uri.parse("$baseApiUrl/bloons"));
  var jsonData = json.decode(data.body);

  List<BasicBloonModel> bloons = [];

  for (var b in jsonData) {
    BasicBloonModel bloon = BasicBloonModel.fromJson(b);
    bloons.add(bloon);
  }

  GlobalState.bloons = bloons;
}

// Future<dynamic> getBloonData(String id) async {
//   GlobalState.isLoading = true;
//   var data = await http.get(Uri.parse("$baseApiUrl/bloon/$id"));
//
//   var jsonData = json.decode(data.body);
//
//   GlobalState.isLoading = false;
//
//   var bloonData = SingleBloonModel.fromJson(jsonData);
//   GlobalState.currentTitle = bloonData.name;
//   return bloonData;
// }

Future<dynamic> getBloonData(String id) async {
  GlobalState.isLoading = true;
  try {
    var data = await http.get(Uri.parse("$baseApiUrl/bloon/$id"));
    var jsonData = json.decode(data.body);
    GlobalState.isLoading = false;
    var bloonData = SingleBloonModel.fromJson(jsonData);
    GlobalState.currentTitle = bloonData.name;
    return bloonData;
  } catch (e) {
    print("Error getting bloon data: $e");
    return null;
  }
}

Future<dynamic> getBossData(String id) async {
  GlobalState.isLoading = true;
  var data = await http.get(Uri.parse("$baseApiUrl/boss/$id"));

  var jsonData = json.decode(data.body);

  GlobalState.isLoading = false;

  var bossData = BossBloonModel.fromJson(jsonData);
  GlobalState.currentTitle = bossData.name;
  return bossData;
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

Future<SingleHeroModel> getHeroData(towerId) async {
  GlobalState.isLoading = true;

  var data = (await http.get(Uri.parse("$baseApiUrl/hero/$towerId")));

  var jsonData = json.decode(data.body);

  SingleHeroModel heroData = SingleHeroModel.fromJson(jsonData);

  GlobalState.currentTitle = heroData.name;

  GlobalState.isLoading = false;

  return heroData;
}

// Towers
Future<void> getTowers() async {
  var data = await http.get(Uri.parse("$baseApiUrl/towers"));

  var jsonData = json.decode(data.body);

  List<TowerModel> towers = [];

  for (var t in jsonData) {
    TowerModel tower = TowerModel.fromJson(t);
    towers.add(tower);
  }

  GlobalState.towers = towers;
  GlobalState.towerTypes = towers.map((e) => e.type).toSet().toList();
}

Future<SingleTowerModel> getTowerData(towerId) async {
  GlobalState.isLoading = true;
  var data = (await http.get(Uri.parse("$baseApiUrl/tower/$towerId")));

  var jsonData = json.decode(data.body);

  SingleTowerModel towerData = SingleTowerModel.fromJson(jsonData);

  GlobalState.currentTitle = towerData.name;

  GlobalState.isLoading = false;

  return towerData;
}
