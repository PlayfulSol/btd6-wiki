class Skins {
  late final String id;
  late final String name;

  Skins(
    this.id,
    this.name,
  );

  Skins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
