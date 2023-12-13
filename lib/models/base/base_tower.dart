import '/models/base_model.dart';

class BaseTower extends BaseModel {
  late final String classType;
  late final String inGameDesc;

  BaseTower(
    super.id,
    super.name,
    super.image,
    super.type,
    this.classType,
    this.inGameDesc,
  );

  BaseTower.fromJson(Map<String, dynamic> json)
      : classType = json["classType"] as String,
        inGameDesc = json["inGameDesc"] as String,
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json["type"] as String,
        );
}
