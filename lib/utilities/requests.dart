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
Future<void> getBloons() async {
  var data = await http.get(Uri.parse("$baseApiUrl/bloons"));

  var jsonData = json.decode(data.body);

  List<BasicBloonModel> bloons = [];

  List<BasicBloonModel> bosses = [];

  for (var b in jsonData) {
    if (b['type'] == 'boss') {
      BasicBloonModel boss = BasicBloonModel.fromJson(b);

      bosses.add(boss);
    } else {
      BasicBloonModel bloon = BasicBloonModel.fromJson(b);

      bloons.add(bloon);
    }
  }

  GlobalState.bloons = bloons;
  GlobalState.bosses = bosses;
}

// Maps
Future<void> getMaps() async {
  final jsonConfig =
      await rootBundle.loadString('assets/data/config/maps.json');
  final List<dynamic> parsedConfig = json.decode(jsonConfig);
  GlobalState.maps = parsedConfig.map((e) => MapModel.fromJson(e)).toList();
}
