import '/models/towers/common/cost_class.dart';
import '/models/towers/common/stats_class.dart';
import '/models/towers/common/upgrade_info_class.dart';

class HeroModel {
  late final String name;
  late final Map<String, dynamic> skinChange;
  late final String abilities;
  late final String target;
  late final String? inGameDesc;
  late final String image;
  late final Cost cost;
  late final HeroStats stats;
  late final List<UpgradeInfo> levels;

  HeroModel(
    this.name,
    this.skinChange,
    this.abilities,
    this.target,
    this.inGameDesc,
    this.image,
    this.cost,
    this.stats,
    this.levels,
  );

  HeroModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    inGameDesc = json['inGameDesc'];
    image = json['image'];
    skinChange = json['skinChange'];
    abilities = json['abilities'];
    target = json['target'];
    cost = Cost.fromJson(json['cost']);
    stats = HeroStats.fromJson(json['stats']);
    if (json['levels'] != null) {
      levels = <UpgradeInfo>[];
      json['levels'].forEach((v) {
        levels.add(UpgradeInfo.fromJson(v));
      });
    }
  }
}
