class BasicBossModel {
  late final String id;
  late final String name;
  late final String type;
  late final double speed;

  BasicBossModel(this.id, this.name, this.type, this.speed);

  BasicBossModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }
}

class BasicBloonModel {
  late final String id;
  late final String name;
  late final String image;

  BasicBloonModel(this.id, this.name, this.image);

  BasicBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['shortName'];
    image = json['image'];
  }
}
