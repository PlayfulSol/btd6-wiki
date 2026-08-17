class SkinPortrait {
  final String level;
  final String image;

  SkinPortrait.fromJson(Map<String, dynamic> json)
      : level = json['level'] as String? ?? '',
        image = json['image'] as String? ?? '';
}

class HeroSkin {
  final String id;
  final String name;
  final String description;
  final bool isDefault;
  final int mmCost;
  final List<SkinPortrait> portraits;

  HeroSkin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'] ?? '',
        isDefault = json['isDefault'] ?? false,
        mmCost = json['mmCost'] ?? 0,
        portraits = (json['portraits'] as List<dynamic>? ?? [])
            .map((e) => SkinPortrait.fromJson(e as Map<String, dynamic>))
            .toList();

  String? imageForLevel(String level) {
    for (final p in portraits) {
      if (p.level == level && p.image.isNotEmpty) return p.image;
    }
    return null;
  }
}
