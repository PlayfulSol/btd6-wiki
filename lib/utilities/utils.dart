import 'package:btd6wiki/models/map.dart';

import '/utilities/global_state.dart';

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

String getPathTitleFromKey(String key) {
  switch (key) {
    case 'path1':
      return 'Top Path';
    case 'path2':
      return 'Middle Path';
    case 'path3':
      return 'Bottom Path';
    case 'paragon':
      return 'Paragon';
    default:
      return 'Top Path';
  }
}

String costToString(Cost cost) {
  return "Easy: ${cost.easy}, Medium: ${cost.medium}, Hard: ${cost.hard}, Impoppable: ${cost.impoppable}";
}

String statsToString(Stats stats) {
  return "Damage: ${stats.damage}, Pierce: ${stats.pierce}, Attack Speed: ${stats.attackSpeed}, Range: ${stats.range}, Type: ${stats.type}";
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
  if (GlobalState.currentTowerType == '') {
    return GlobalState.currentTitle;
  } else {
    return GlobalState.currentTowerType;
  }
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
