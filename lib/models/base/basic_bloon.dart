class BaseBloonModel {
  late final String id;
  late final String name;
  late final String image;

  BaseBloonModel(
    this.id,
    this.name,
    this.image,
  );

  BaseBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
