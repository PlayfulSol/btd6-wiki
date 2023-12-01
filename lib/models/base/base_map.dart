import '/models/base_model.dart';

class BaseMap extends BaseModel {
  late final String difficulty;

  BaseMap(
    super.id,
    super.name,
    super.image,
    super.type,
    this.difficulty,
  );

  BaseMap.fromJson(Map<String, dynamic> json)
      : difficulty = json["difficulty"] as String,
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json["type"] as String,
        );
}
