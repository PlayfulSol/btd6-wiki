import '/models/towers/common/attack_class.dart';
import '/models/towers/common/cost_class.dart';

class TowerUpgrade {
  final String name;
  final String image;
  final String unlock;
  final String upgradeBody;
  final Cost cost;
  final List<Attack> attacks;
  final List<Ability> abilities;
  final Map<String, String>? changes;

  TowerUpgrade.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        image = json['image'] ?? '',
        unlock = json['unlock'] ?? '0 XP',
        upgradeBody = json['upgradeBody'] ?? '',
        cost = Cost.fromJson(json['cost']),
        attacks = parseAttacks(json['attacks']),
        abilities = parseAbilities(json['abilities']),
        changes = json['versionDiff'] != null
            ? Map<String, String>.from(json['versionDiff'])
            : null;
}
