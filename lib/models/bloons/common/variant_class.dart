class Variant {
  late final String image;
  late final String name;
  late final String appearances;

  Variant({required this.image, required this.name, required this.appearances});

  Variant.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    appearances = json['appearances'];
  }
}
