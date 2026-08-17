import '/models/towers/common/attack_class.dart';
import '/models/towers/common/cost_class.dart';
import '/models/towers/common/hero_level_class.dart';
import 'hero_skin.dart';

class HeroModelV2 {
  final String id;
  final String name;
  final String type;
  final String image;
  final String inGameDesc;
  final List<String> skinChange;
  final String target;
  final String footprint;
  final String damageType;
  final Cost cost;
  final List<Attack> attacks;
  final List<Ability> abilities;
  final List<HeroSkin> skins;
  final List<HeroLevelData> levels;
  final String? changes;
  final Map<String, String>? versionDiff;

  HeroModelV2.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        image = json['image'],
        inGameDesc = json['inGameDesc'],
        skinChange = List<String>.from(json['skinChange'] ?? []),
        target = json['target'] ?? '',
        footprint = json['footprint'] ?? '',
        damageType = json['damageType'] ?? '',
        cost = Cost.fromJson(json['cost']),
        attacks = parseAttacks(json['attacks']),
        abilities = parseAbilities(json['abilities']),
        skins = (json['skins'] as List? ?? [])
            .map((e) => HeroSkin.fromJson(e))
            .toList(),
        levels = (json['levels'] as List? ?? [])
            .map((e) => HeroLevelData.fromJson(e))
            .toList(),
        changes = json['changes'] as String?,
        versionDiff = json['versionDiff'] != null
            ? Map<String, String>.from(json['versionDiff'])
            : null;
}
