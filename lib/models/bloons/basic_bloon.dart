class BasicBloonModel {
  late final String id;
  late final String name;
  late final String type;
  late final double speed;

  BasicBloonModel(this.id, this.name, this.type, this.speed);

  BasicBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }
}
