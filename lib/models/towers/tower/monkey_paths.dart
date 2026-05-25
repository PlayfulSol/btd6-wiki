import '/models/towers/common/upgrade_class.dart';

class MonkeyPathsV2 {
  final List<TowerUpgrade> path1;
  final List<TowerUpgrade> path2;
  final List<TowerUpgrade> path3;
  final TowerUpgrade? paragon;

  MonkeyPathsV2.fromJson(Map<String, dynamic> json)
      : path1 = (json['path1'] as List)
            .map((e) => TowerUpgrade.fromJson(e))
            .toList(),
        path2 = (json['path2'] as List)
            .map((e) => TowerUpgrade.fromJson(e))
            .toList(),
        path3 = (json['path3'] as List)
            .map((e) => TowerUpgrade.fromJson(e))
            .toList(),
        paragon = json['paragon'] is Map &&
                (json['paragon'] as Map).isNotEmpty
            ? TowerUpgrade.fromJson(json['paragon'])
            : null;
}
