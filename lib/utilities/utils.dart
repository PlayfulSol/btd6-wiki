import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/models/bloons/common/relative_class.dart';
import '/models/base/base_tower.dart';
import '/models/base/base_hero.dart';
import '/models/base/base_map.dart';
import '/models/base/base_model.dart';
import 'layout_presets.dart';
import 'images_url.dart';
import 'constants.dart';

void navigateToPage(BuildContext context, var item,
AnalyticsHelper analyticsHelper, String originScreen, String originWidget) {
  analyticsHelper.logEvent(
    name: widgetEngagement,
    parameters: {
      'screen': originScreen,
      'widget': originWidget,
      'value': item.id,
    },
  );

  Map<String, String> routes = {
    kTowers: '/towers/${item.id}',
    kHeroes: '/heroes/${item.id}',
    kBloons: '/bloons/${item.id}',
    kBlimps: '/bloons/${item.id}',
    kBosses: '/bosses/${item.id}',
    kMaps: '/maps/${item.id}',
  };
  context.push(routes[item.type]!);
}

String formatWithCommas(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

String camelToTitle(String s) {
  final withSpaces = s.replaceAll('_', ' ').replaceAll(':', ' ');
  final spaced = withSpaces.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (m) => '${m[1]} ${m[2]}',
  );
  return spaced
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

String formatBigNumber(int number) {
  if (number < 1000) {
    return number.toString();
  } else if (number < 1000000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else if (number < 1000000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
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


String assetImagePath(String type, String imageName) {
  if (type == kTowers) {
    return towerImage(imageName);
  } else if (type == kHeroes) {
    return heroImage(imageName);
  } else if (type == kBloons || type == kBlimps) {
    return bloonImage(imageName);
  } else if (type == kBosses) {
    return bossImage(imageName);
  } else if (type == kMaps) {
    return mapImage(imageName);
  } else {
    throw Exception('Unsupported image type - $type');
  }
}

List<BaseModel> filterAndSearchBloons(
    List<BaseModel> bloons, String query, String option) {
  query = query.toLowerCase();
  bloons = switch (option) {
    'All' => bloons,
    'Changes' => bloons.where((b) => b.changes != null).toList(),
    _ => bloons.where((b) => b.type == option.toLowerCase()).toList(),
  };
  return bloons
      .where((bloon) => bloon.name.toLowerCase().contains(query))
      .toList();
}

List<BaseTower> filterAndSearchTowers(
    List<BaseTower> towers, String query, String option) {
  query = query.toLowerCase();
  towers = switch (option) {
    'All' => towers,
    'Changes' => towers.where((t) => t.changes != null).toList(),
    _ => towers.where((t) => t.classType == option).toList(),
  };
  return towers
      .where((tower) => tower.name.toLowerCase().contains(query))
      .toList();
}

List<BaseMap> filterAndSearchMaps(
    List<BaseMap> maps, String query, String option) {
  query = query.toLowerCase();
  maps = switch (option) {
    'All' => maps,
    'Changes' => maps.where((m) => m.changes != null).toList(),
    _ => maps.where((m) => m.difficulty == option).toList(),
  };
  return maps.where((map) => map.name.toLowerCase().contains(query)).toList();
}

List<BaseHero> heroesFromSearch(List<BaseHero> heroes, String query) {
  query = query.toLowerCase();
  return heroes
      .where((hero) => hero.name.toLowerCase().contains(query))
      .toList();
}


List<String> separateString(String stringToSeparate) {
  if (stringToSeparate.contains(':')) {
    List<String> returnList = stringToSeparate.split(':');
    returnList[0] += ':';
    return returnList;
  } else {
    return ['', stringToSeparate];
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
    return 'mix'; // Both strings and objects are present
  } else if (isString) {
    return 'str'; // Only strings are present
  } else if (isObject) {
    return 'obj'; // Only objects are present
  } else {
    return 'none'; // No strings or objects found
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
