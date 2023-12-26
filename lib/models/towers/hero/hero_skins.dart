class Skins {
  late final String id;
  late final String name;
  late final List<String> value;

  Skins(
    this.id,
    this.name,
    this.value,
  );

  Skins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = List<String>.from(json['value']);
  }
}
