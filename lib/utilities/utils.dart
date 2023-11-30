import 'package:btd6wiki/models/base/base_map.dart';
import 'package:btd6wiki/models/base/base_tower.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:btd6wiki/models/bloons/common/relative_class.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/models/towers/common/cost_class.dart';
import '/models/towers/common/stats_class.dart';
import 'constants.dart';

String formatBigNumber(int number) {
  if (number < 1000) {
    return number.toString();
  } else if (number < 1000000) {
    return "${(number / 1000).toStringAsFixed(1)}K";
  } else if (number < 1000000000) {
    return "${(number / 1000000).toStringAsFixed(1)}M";
  } else {
    return "${(number / 1000000000).toStringAsFixed(1)}B";
  }
}

String getPathKeyFromIndex(int index) {
  switch (index) {
    case 0:
      return 'path1';
    case 1:
      return 'path2';
    case 2:
      return 'path3';
    case 3:
      return 'paragon';
    default:
      return 'path1';
  }
}

String costToString(Cost cost) {
  return "Easy: ${cost.easy}, Medium: ${cost.medium}\nHard: ${cost.hard}, Impoppable: ${cost.impoppable}";
}

String statsToString(Stats stats) {
  return "Damage: ${stats.damage} | Pierce: ${stats.pierce} | Attack Speed: ${stats.attackSpeed}\nRange: ${stats.range} |\nCamo: ${stats.camo} ";
}

String extraStatsToString(Stats stats) {
  return "Status Effects: ${stats.statuseffects}\nIncome Boosts: ${stats.incomeboosts}\nTower Boosts: ${stats.towerboosts}";
}

List<BaseModel> filterbloons(List<BaseModel> bloons, String option) {
  if (option == 'All') {
    return bloons;
  } else {
    return bloons.where((bloon) => bloon.type == option.toLowerCase()).toList();
  }
}

List<BaseTower> filterTowers(List<BaseTower> towers, String option) {
  if (option == 'All') {
    return towers;
  } else {
    return towers.where((tower) => tower.type == option).toList();
  }
}

List<BaseMap> filterMaps(List<BaseMap> maps, String option, String query) {
  if (option == '') {
    return maps;
  } else {
    return maps.where((map) => map.difficulty == option).toList();
  }
}

List<BaseMap> mapsFromSearch(List<BaseMap> maps, String query) {
  query = query.toLowerCase();
  return maps.where((map) => map.name.toLowerCase().contains(query)).toList();
}

List<String> dropmenuOptions(int pageIndex) {
  if (pageIndex == 0) {
    return towerTypes;
  } else if (pageIndex == 2) {
    return bloonTypes;
  } else if (pageIndex == 3) {
    return mapDifficulties;
  } else {
    return [];
  }
}

List<String> separateString(String stringToSeparate) {
  if (stringToSeparate.contains(':')) {
    List<String> returnList = stringToSeparate.split(':');
    returnList[0] += ':';
    return returnList;
  } else {
    return ["", stringToSeparate];
  }
}

dynamic extractItemTypeFromList(List<dynamic> data) {
  bool isString = false;
  bool isObject = false;

  if (data.isEmpty) {
    return null; // Return null for an empty list (or handle it differently if needed)
  }

  for (int i = 0; i < data.length; i++) {
    if (data[i] is String && data[i] != 'None') {
      isString = true;
    } else if (data[i] is Relative) {
      // Assuming objects are Map<String, dynamic>, you can adjust the type check as needed
      isObject = true;
    }
  }

  if (isString && isObject) {
    return "mix"; // Both strings and objects are present
  } else if (isString) {
    return "str"; // Only strings are present
  } else if (isObject) {
    return "obj"; // Only objects are present
  } else {
    return "none"; // No strings or objects found
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Future<void> openUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<void> openMail(String mailString) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: mailString,
    query: encodeQueryParameters({'subject': 'About BTD6 Wiki'}),
  );
  if (!await launchUrl(emailLaunchUri)) {
    throw 'Could not launch $emailLaunchUri';
  }
}

Map<String, dynamic> calculateConstraints(BoxConstraints constraints) {
  if (constraints.maxWidth < 450) {
    return constraintsNormalPreset;
  } else if (constraints.maxWidth < 1200) {
    return constraintsWidePreset;
  } else {
    return constraintsUWPreset;
  }
}

Map<String, dynamic> calculateConstraintsBloons(BoxConstraints constraints) {
  if (constraints.maxWidth < 350) {
    return constraintsBloonSmallPreset;
  } else if (constraints.maxWidth < 400) {
    return constraintsBloonNormalPreset;
  } else if (constraints.maxWidth < 470) {
    return constraintsBloonWidePreset;
  } else {
    return constraintsBloonUWPreset;
  }
}
