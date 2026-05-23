import '/models/towers/common/cost_class.dart';
import 'stats_class.dart';

class TowerUpgrade {
  final String name;
  final String image;
  final String unlock;
  final String upgradeBody;
  final Cost cost;
  final UpgradeStats? stats;
  final Map<String, String>? changes;

  TowerUpgrade.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        image = json['image'] ?? '',
        unlock = json['unlock'] ?? '0 XP',
        upgradeBody = json['upgradeBody'] ?? json['body'] ?? '',
        cost = Cost.fromJson(json['cost']),
        stats = json['stats'] != null
            ? UpgradeStats.fromJson(json['stats'])
            : null,
        changes = json['changes'] != null
            ? Map<String, String>.from(json['changes'])
            : null;
}
