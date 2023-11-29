import 'package:btd6wiki/models/base_model.dart';

import 'boss_health_class.dart';
import '../common/relative_class.dart';

class BossBloonModel extends BaseModel {
  late final String description;
  late final Map<String, dynamic> images;
  late final Relative children;
  late final Health health;
  late final Map<String, dynamic> skullCount;
  late final List<String> immunities;
  late final Map<String, dynamic> gimmicks;

  BossBloonModel(
    super.id,
    super.name,
    super.image,
    super.type,
    this.description,
    this.children,
    this.health,
    this.skullCount,
    this.immunities,
    this.gimmicks,
  );

  BossBloonModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        images = json["images"],
        children = Relative.fromJson(json["children"]),
        health = Health.fromJson(json["health"]),
        skullCount = json['skullCount'],
        immunities = List<String>.from(json['generalImmunities']),
        gimmicks = json["gimmicks"],
        super(
          json["id"] as String,
          json["name"] as String,
          json["images"]["normal"] as String,
          json['type'] as String,
        );
}
