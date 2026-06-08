import '/models/towers/common/attack_class.dart';

class HeroLevelData {
  final String name;
  final String? image;
  final String xpCost;
  final String description;
  final List<Attack> attacks;
  final List<Ability> abilities;
  final String? upgrade;
  final String? upgradeBody;
  final Map<String, String>? versionDiff;

  HeroLevelData.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String? ?? '',
        image = json['image'],
        xpCost = json['xpCost'] ?? '0 XP',
        description = json['description'] ?? '',
        attacks = parseAttacks(json['attacks']),
        abilities = parseAbilities(json['abilities']),
        upgrade = json['upgrade'],
        upgradeBody = json['upgradeBody'] as String?,
        versionDiff = json['versionDiff'] != null
            ? Map<String, String>.from(json['versionDiff'])
            : null;
}
