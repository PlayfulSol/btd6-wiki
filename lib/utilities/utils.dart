import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '/models/bloons/common/relative_class.dart';
import '/models/towers/common/stats_class.dart';
import '/models/towers/common/cost_class.dart';
import '/models/base/base_tower.dart';
import '/models/base/base_hero.dart';
import '/models/base/base_map.dart';
import '/models/base_model.dart';
import 'constants.dart';
import 'images_url.dart';
import 'layout_presets.dart';

int desiredCategoryOrder(dynamic key1, dynamic key2) {
  // Define the desired order as a list of category keys
  final desiredOrder = [
    'towers',
    'heroes',
    'bloons',
    'bosses',
    'maps',
    'blimps'
  ];

  // Get the category names from the keys
  final category1 = key1.split(':')[0];
  final category2 = key2.split(':')[0];

  // Find the indices of the categories in the desired order
  final index1 = desiredOrder.indexOf(category1);
  final index2 = desiredOrder.indexOf(category2);

  // Compare the indices to determine the order
  if (index1 == -1 || index2 == -1) {
    // Handle unexpected categories (not in desiredOrder)
    return 0; // Or throw an error if preferred
  } else if (index1 < index2) {
    return -1; // Category1 comes before Category2
  } else if (index1 > index2) {
    return 1; // Category1 comes after Category2
  } else {
    return 0; // Categories have the same desired order (shouldn't happen)
  }
}

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

String assetImagePath(String type, String imageName) {
  if (type == kTowers) {
    return towerImage(imageName);
  } else if (type == kHeroes) {
    return heroImage(imageName);
  } else if (type == kBloons || type == kBlimps) {
    return bloonImage(imageName);
  } else if (type == kBosses) {
    return bossImage(imageName);
  } else if (type == kMinions) {
    return minionImage(imageName);
  } else if (type == kMaps) {
    return mapImage(imageName);
  } else {
    throw Exception('Unsupported image type - $type');
  }
}

List<BaseModel> filterAndSearchBloons(
    List<BaseModel> bloons, String query, String option) {
  query = query.toLowerCase();
  bloons = option == 'All'
      ? bloons
      : bloons.where((bloon) => bloon.type == option.toLowerCase()).toList();
  return bloons
      .where((bloon) => bloon.name.toLowerCase().contains(query))
      .toList();
}

List<BaseTower> filterAndSearchTowers(
    List<BaseTower> towers, String query, String option) {
  query = query.toLowerCase();
  towers = option == 'All'
      ? towers
      : towers.where((tower) => tower.classType == option).toList();
  return towers
      .where((tower) => tower.name.toLowerCase().contains(query))
      .toList();
}

List<BaseMap> filterAndSearchMaps(
    List<BaseMap> maps, String query, String option) {
  query = query.toLowerCase();
  maps = option == 'All'
      ? maps
      : maps.where((map) => map.difficulty == option).toList();
  return maps.where((map) => map.name.toLowerCase().contains(query)).toList();
}

List<BaseHero> heroesFromSearch(List<BaseHero> heroes, String query) {
  query = query.toLowerCase();
  return heroes
      .where((hero) => hero.name.toLowerCase().contains(query))
      .toList();
}

List<String> dropMenuOptions(int pageIndex) {
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
    return null;
  }

  for (int i = 0; i < data.length; i++) {
    if (data[i] is String && data[i] != 'None') {
      isString = true;
    } else if (data[i] is Relative) {
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

Map<String, dynamic> getPreset(Size size) {
  if (size.width < 321) {
    return presetUS;
  } else if (size.width < 360) {
    return presetXS;
  } else if (size.width < 415) {
    return presetSM;
  } else if (size.width < 450) {
    return presetMD;
  } else if (size.width < 550) {
    return presetLG;
  } else if (size.width < 750) {
    return presetXL;
  } else if (size.width < 1000) {
    return presetXXL;
  } else {
    return presetXXXL;
  }
}
