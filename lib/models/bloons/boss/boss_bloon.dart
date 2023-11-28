import 'boss_health_class.dart';
import '../common/relative_class.dart';

class BossBloonModel {
  late final String id;
  late final String name;
  late final String description;
  late final Map<String, dynamic> images;
  late final Relative children;
  late final Health health;
  late final Map<String, dynamic> skullCount;
  late final List<String> immunities;
  late final Map<String, dynamic> gimmicks;

  BossBloonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.children,
    required this.health,
    required this.skullCount,
    required this.immunities,
    required this.gimmicks,
  });

  BossBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    images = json["images"];
    children = Relative.fromJson(json["children"]);
    health = Health.fromJson(json["health"]);
    skullCount = json['skullCount'];
    immunities = List<String>.from(json['generalImmunities']);
    gimmicks = json["gimmicks"];
  }
}
