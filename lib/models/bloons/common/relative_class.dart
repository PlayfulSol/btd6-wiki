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
    image = json['image'] as String;
    value = (json['count'] ?? 1).toString();
    // JSON has no 'name'; derive from id ("super_ceramic" → "Super Ceramic")
    name = id
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
