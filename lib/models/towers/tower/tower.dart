import '/models/towers/common/cost_class.dart';
import '/models/towers/common/stats_class.dart';
import 'monkey_paths.dart';

class TowerModel {
  late final String id;
  late final String image;
  late final String name;
  late final String inGameDesc;
  late final String type;
  late final Cost cost;
  late final Stats stats;
  late final MonkeyPathsModel paths;

  TowerModel(
    id,
    name,
    description,
    type,
    cost,
    stats,
    paths,
  );

  TowerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json["image"];
    name = json['name'];
    inGameDesc = json['inGameDesc'];
    type = json['type'];
    cost = Cost.fromJson(json['cost']);
    stats = Stats.fromJson(json['stats']);
    paths = MonkeyPathsModel.fromJson(json['paths']);
  }
}
