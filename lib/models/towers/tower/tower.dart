import '/models/towers/common/attack_class.dart';
import '/models/towers/common/cost_class.dart';
import 'monkey_paths.dart';

class TowerModelV2 {
  final String id;
  final String name;
  final String type;
  final String image;
  final String classType;
  final String unlock;
  final String inGameDesc;
  final String target;
  final String footprint;
  final String damageType;
  final String camoUnlock;
  final Cost cost;
  final List<Attack> attacks;
  final List<Ability> abilities;
  final MonkeyPathsV2 paths;
  final String? changes;
  final Map<String, String>? versionDiff;

  TowerModelV2.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        image = json['image'],
        classType = json['classType'],
        unlock = json['unlock'] ?? '',
        inGameDesc = json['inGameDesc'],
        target = json['target'] ?? '',
        footprint = json['footprint'] ?? '',
        damageType = json['damageType'] ?? '',
        camoUnlock = json['camoUnlock'] ?? '',
        cost = Cost.fromJson(json['cost']),
        attacks = parseAttacks(json['attacks']),
        abilities = parseAbilities(json['abilities']),
        paths = MonkeyPathsV2.fromJson(json['paths']),
        changes = json['changes'] as String?,
        versionDiff = json['versionDiff'] != null
            ? Map<String, String>.from(json['versionDiff'])
            : null;
}
