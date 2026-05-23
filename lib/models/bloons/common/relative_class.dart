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
    // New JSON uses 'count' (int); old format used 'value' (string)
    final rawValue = json['value'] ?? json['count'] ?? 1;
    value = rawValue.toString();
    // New JSON has no 'name'; derive from id ("super_ceramic" → "Super Ceramic")
    name = json['name'] as String? ??
        id
            .split('_')
            .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
  }
}
