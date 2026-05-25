import 'stats_class.dart';

class HeroLevelData {
  final String name;
  final String? image;
  final String xpCost;
  final String description;
  final UpgradeStats stats;
  final String? upgrade;

  HeroLevelData.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String? ?? '',
        image = json['image'],
        xpCost = json['xpCost'] ?? '0 XP',
        description = json['description'] ?? '',
        stats = UpgradeStats.fromJson(json['stats'] ?? {}),
        upgrade = json['upgrade'];
}
