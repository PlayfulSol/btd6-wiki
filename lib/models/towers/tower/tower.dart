import 'package:btd6wiki/models/base/base_tower.dart';

import '/models/towers/common/cost_class.dart';
import '/models/towers/common/stats_class.dart';
import 'monkey_paths.dart';

class TowerModel extends BaseTower {
  late final Cost cost;
  late final Stats stats;
  late final MonkeyPathsModel paths;

  TowerModel(
    super.id,
    super.name,
    super.image,
    super.type,
    super.inGameDesc,
    this.cost,
    this.stats,
    this.paths,
  );

  TowerModel.fromJson(Map<String, dynamic> json)
      : cost = Cost.fromJson(json['cost']),
        stats = Stats.fromJson(json['stats']),
        paths = MonkeyPathsModel.fromJson(json['paths']),
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json["type"] as String,
          json["inGameDesc"] as String,
        );
}
