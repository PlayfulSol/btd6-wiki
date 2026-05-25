class Variant {
  late final String image;
  late final String name;
  late final String appearances;
  late final bool isCamo;
  late final bool isRegrow;
  late final bool isFortified;
  late final int health;
  late final double speed;

  Variant({
    required this.image,
    required this.name,
    required this.appearances,
    this.isCamo = false,
    this.isRegrow = false,
    this.isFortified = false,
    this.health = 0,
    this.speed = 0,
  });

  Variant.fromJson(Map<String, dynamic> json) {
    image = json['image'] as String;
    isCamo = (json['isCamo'] as bool?) ?? false;
    isRegrow = (json['isRegrow'] as bool?) ?? false;
    isFortified = (json['isFortified'] as bool?) ?? false;
    health = (json['health'] as num?)?.toInt() ?? 0;
    speed = (json['speed'] as num?)?.toDouble() ?? 0;
    // Derive name from id if not present: "ceramic_camo" → "Ceramic Camo"
    final rawId = json['id'] as String? ?? '';
    name = json['name'] as String? ??
        rawId
            .split('_')
            .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
    final fa = json['firstAppearance'] as Map<String, dynamic>?;
    final normal = fa?['normal'];
    final alternate = fa?['alternate'];
    final parts = <String>[];
    if (normal != null) parts.add('Round $normal');
    if (alternate != null) parts.add('ABR: Round $alternate');
    appearances = parts.isEmpty ? 'N/A' : parts.join(' | ');
  }
}
