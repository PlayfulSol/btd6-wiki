import '/models/base/base_map.dart';

class MapModel extends BaseMap {
  late final String? entrances;
  late final String? exits;
  late final String? length;
  late final String? music;
  late final String? water;
  late final String? sightBlocker;
  late final String? coopDivision;

  MapModel(
    this.entrances,
    this.exits,
    this.length,
    this.music,
    this.water,
    this.sightBlocker,
    this.coopDivision,
    super.id,
    super.name,
    super.image,
    super.type,
    super.difficulty,
  );

  MapModel.fromJson(Map<String, dynamic> json)
      : entrances = json['entrances'],
        exits = json['exits'],
        length = json['length'],
        music = json['music'],
        water = json['water'],
        sightBlocker = json['sightBlocker'],
        coopDivision = json['coopDivision'],
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
          json['difficulty'] as String,
        );
}
