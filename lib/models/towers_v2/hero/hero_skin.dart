class HeroSkin {
  final String id;
  final String name;
  final String description;
  final bool isDefault;
  final int mmCost;
  final List<String> portraitLevels;
  final Map<String, String> images;

  HeroSkin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'] ?? '',
        isDefault = json['isDefault'] ?? false,
        mmCost = json['mmCost'] ?? 0,
        portraitLevels = List<String>.from(json['portraitLevels'] ?? []),
        images =
            (json['images'] as Map<String, dynamic>).cast<String, String>();
}
