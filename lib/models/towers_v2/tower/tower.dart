import '/models/towers/common/cost_class.dart';
import '/models/towers_v2/common/stats_class.dart';
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
  final Cost cost;
  final Stats stats;
  final MonkeyPathsV2 paths;
  final Map<String, String>? changes;

  TowerModelV2.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        image = json['image'],
        classType = json['classType'],
        unlock = json['unlock'] ?? '',
        inGameDesc = json['inGameDesc'],
        target = json['target'] ?? '',
        cost = Cost.fromJson(json['cost']),
        stats = Stats.fromJson(json['stats']),
        paths = MonkeyPathsV2.fromJson(json['paths']),
        changes = json['changes'] != null
            ? Map<String, String>.from(json['changes'])
            : null;
}
