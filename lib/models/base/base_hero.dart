import 'package:btd6wiki/models/base_model.dart';

class BaseHero extends BaseModel {
  late final String inGameDesc;

  BaseHero(
    super.id,
    super.name,
    super.image,
    super.type,
    this.inGameDesc,
  );

  BaseHero.fromJson(Map<String, dynamic> json)
      : inGameDesc = json["inGameDesc"] as String,
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json["type"] as String,
        );
}
