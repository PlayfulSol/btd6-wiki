class Relative {
  late final String id;
  late final String name;
  late final String image;
  late final String value;

  Relative({
    required this.id,
    required this.name,
    required this.image,
    required this.value,
  });

  Relative.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    image = json['image'] as String;
    value = json['value'] as String;
  }
}
