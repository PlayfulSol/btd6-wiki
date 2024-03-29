import '/models/towers/common/upgrade_info_class.dart';
import '/models/towers/common/stats_class.dart';
import '/models/towers/common/cost_class.dart';
import '/models/base/base_hero.dart';
import 'hero_skins.dart';

class HeroModel extends BaseHero {
  late final List<String> skinChange;
  late final List<Skins> skins;
  late final String abilities;
  late final String target;
  late final Cost cost;
  late final HeroStats stats;
  late final List<UpgradeInfo> levels;

  HeroModel(
    super.id,
    super.name,
    super.image,
    super.type,
    super.inGameDesc,
    this.skinChange,
    this.abilities,
    this.target,
    this.cost,
    this.stats,
    this.levels,
  );

  HeroModel.fromJson(Map<String, dynamic> json)
      : skinChange = List<String>.from(json['skinChange']),
        skins = List<Skins>.from(json["skins"].map((e) => Skins.fromJson(e)))
            .toList(),
        abilities = json['abilities'],
        target = json['target'],
        cost = Cost.fromJson(json['cost']),
        stats = HeroStats.fromJson(json['stats']),
        levels = List<UpgradeInfo>.from(
            json['levels'].map((e) => UpgradeInfo.fromJson(e))).toList(),
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json['type'] as String,
          json["inGameDesc"] as String,
        );
}
