class Skins {
  late final String id;
  late final String name;
  late final Map<String, String> images;

  Skins(
    this.id,
    this.name,
    this.images,
  );

  Skins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    images = (json['images'] as Map<String, dynamic>).cast<String, String>();
  }
}
