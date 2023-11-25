import '/models/base_model.dart';
import '/models/bloons/single_bloon.dart';

class MinionBloon extends BaseModel {
  late final Map<String, dynamic> images;
  late final Map<String, dynamic> health;
  late final Relative parent;
  late final Speed speed;
  late final Map<String, dynamic> gimmicks;

  MinionBloon(
    super.id,
    super.name,
    super.image,
    super.type,
    this.images,
    this.health,
    this.parent,
    this.speed,
    this.gimmicks,
  );

  MinionBloon.fromJson(Map<String, dynamic> json)
      : images = json["images"] as Map<String, dynamic>,
        health = json["health"] as Map<String, dynamic>,
        parent = Relative.fromJson(json["parent"] as Map<String, dynamic>),
        speed = Speed.fromJson(json["speed"] as Map<String, dynamic>),
        gimmicks = json["gimmicks"],
        super(
          json["id"] as String,
          json["name"] as String,
          json["images"]["normal"] as String,
          json["type"] as String,
        );
}
