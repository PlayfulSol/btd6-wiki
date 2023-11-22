class BaseModel {
  late final String id;
  late final String name;
  late final String image;
  late final String type;

  BaseModel(this.id, this.name, this.image, this.type);

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      json['id'] as String,
      json['name'] as String,
      json['image'] as String,
      json['type'] as String,
    );
  }
}
