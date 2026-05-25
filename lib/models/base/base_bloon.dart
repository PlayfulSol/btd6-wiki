import '/models/base/base_model.dart';

class BaseBloon extends BaseModel {
  final bool isMoab;

  BaseBloon(
    super.id,
    super.name,
    super.image,
    super.type,
    this.isMoab,
  );

  BaseBloon.fromJson(Map<String, dynamic> json)
      : isMoab = (json['isMoab'] as bool?) ?? false,
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
        );
}
