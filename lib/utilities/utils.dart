import '/utilities/global_state.dart';

import '/models/map.dart';
import '/models/bloons/bloon_hierarchy.dart';
import '/models/hero.dart';
import '/models/common.dart';
import '/models/tower.dart';

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

String oldCostToString(OldCost cost) {
  return "Easy: ${cost.easy}, Medium: ${cost.medium}\nHard: ${cost.hard}, Impoppable: ${cost.impoppable}";
}

String statsToString(Stats stats) {
  return "Damage: ${stats.damage} | Pierce: ${stats.pierce} | Attack Speed: ${stats.attackSpeed}\nRange: ${stats.range} |\nCamo: ${stats.camo} ";
}

String oldStatsToString(OldStats stats) {
  return "Damage: ${stats.damage} | Pierce: ${stats.pierce} | Attack Speed: ${stats.attackSpeed}\nRange: ${stats.range} | Damage Type: ${stats.type}\n ";
}

String extraStatsToString(Stats stats) {
  return "Status Effects: ${stats.statuseffects}\nIncome Boosts: ${stats.incomeboosts}\nTower Boosts: ${stats.towerboosts}";
}

String roundsToString(Rounds rounds) {
  return "Easy: ${rounds.easy}, Medium: ${rounds.medium}, Hard: ${rounds.hard}, Impoppable: ${rounds.impoppable}";
}

String getTowerLevel(pathKey, index) {
  if (pathKey == 'paragon') {
    return 'paragon';
  } else if (pathKey == 'path1') {
    return '${index + 1}00';
  } else if (pathKey == 'path2') {
    return '0${index + 1}0';
  } else if (pathKey == 'path3') {
    return '00${index + 1}';
  } else {
    return '000';
  }
}

String bloonsParentsToString(List<BloonHierarchyModel> bloonHierarchy) {
  String hierarchy = '';
  for (var bloon in bloonHierarchy) {
    hierarchy += '${bloon.id}, ';
  }
  return hierarchy.substring(0, hierarchy.length - 3);
}

// boss rbe contains of a list of 5 rounds each is how many HP does the boss have in that round
// should print for each round the round number and the HP
// should take the rounds argument and use it to print by index
String bossRbeToString(List<int> bossRbe, List<String> rounds) {
  String rbe = '';
  for (var i = 0; i < bossRbe.length; i++) {
    rbe += 'Round ${rounds[i]}: ${formatBigNumber(bossRbe[i])}\n';
  }
  return rbe;
}

String getAppTitle() {
  return GlobalState.currentTitle;
}

List<TowerModel> filterTowers() {
  if (GlobalState.currentTowerType == '') {
    return GlobalState.towers;
  } else {
    return GlobalState.towers
        .where((tower) => tower.type == GlobalState.currentTowerType)
        .toList();
  }
}

List<MapModel> filterMaps(query) {
  if (query != '') {
    if (GlobalState.currentMapDifficulty == '') {
      return GlobalState.maps
          .where((map) => map.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      return GlobalState.maps
          .where((map) =>
              map.name.toLowerCase().contains(query.toLowerCase()) &&
              map.difficulty == GlobalState.currentMapDifficulty)
          .toList();
    }
  }
  if (GlobalState.currentMapDifficulty == '') {
    return GlobalState.maps;
  } else {
    return GlobalState.maps
        .where((map) => map.difficulty == GlobalState.currentMapDifficulty)
        .toList();
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
    } else if (data[i] is Map<String, dynamic>) {
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
