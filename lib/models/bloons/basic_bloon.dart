class BasicBloonModel {
  late final String id;
  late final String name;
  late final String image;

  BasicBloonModel(this.id, this.name, this.image);

  BasicBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
