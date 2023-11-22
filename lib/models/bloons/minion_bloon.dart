import 'package:btd6wiki/models/base_model.dart';
import 'package:btd6wiki/models/bloons/single_bloon.dart';

class MinionBloon extends BaseModel {
  late final Map<String, dynamic> images;
  late final Map<String, dynamic> health;
  late final Relative parent;
  late final Speed speed;

  MinionBloon(
    String id,
    String name,
    String image,
    String type,
    this.images,
    this.health,
    this.parent,
    this.speed,
  ) : super(id, name, image, type);

  MinionBloon.fromJson(Map<String, dynamic> json)
      : images = json["images"] as Map<String, dynamic>,
        health = json["health"] as Map<String, dynamic>,
        parent = Relative.fromJson(json["parent"] as Map<String, dynamic>),
        speed = Speed.fromJson(json["speed"] as Map<String, dynamic>),
        super(
          json["id"] as String,
          json["name"] as String,
          json["images"]["normal"] as String,
          json["type"] as String,
        );
}