import '/models/base/base_model.dart';

class BaseTower extends BaseModel {
  late final String classType;

  BaseTower(
    super.id,
    super.name,
    super.image,
    super.type,
    this.classType, {
    super.changes,
  });

  BaseTower.fromJson(Map<String, dynamic> json)
      : classType = json['classType'] as String,
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
          changes: json['changes'] as String?,
        );
}
