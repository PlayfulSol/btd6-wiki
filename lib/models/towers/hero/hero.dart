import '/models/towers/common/cost_class.dart';
import '/models/towers/common/stats_class.dart';
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
  final Cost cost;
  final Stats stats;
  final List<HeroSkin> skins;
  final List<HeroLevelData> levels;
  final Map<String, String>? changes;

  HeroModelV2.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        image = json['image'],
        inGameDesc = json['inGameDesc'],
        skinChange = List<String>.from(json['skinChange'] ?? []),
        target = json['target'] ?? '',
        cost = Cost.fromJson(json['cost']),
        stats = Stats.fromJson(json['stats']),
        skins = (json['skins'] as List)
            .map((e) => HeroSkin.fromJson(e))
            .toList(),
        levels = (json['levels'] as List)
            .map((e) => HeroLevelData.fromJson(e))
            .toList(),
        changes = json['changes'] != null
            ? Map<String, String>.from(json['changes'])
            : null;
}
