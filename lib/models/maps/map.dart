import '/models/base/base_map.dart';

class MapModel extends BaseMap {
  late final String? entrances;
  late final String? exits;
  late final String? length;
  late final String? music;
  late final dynamic terrain;
  late final String? water;
  late final dynamic removableObject;
  late final dynamic highground;
  late final String? sightBlocker;

  MapModel(
    this.entrances,
    this.exits,
    this.length,
    this.music,
    this.terrain,
    this.water,
    this.removableObject,
    this.highground,
    this.sightBlocker,
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
        terrain = json['terrain'],
        water = json['water'],
        removableObject = json['removableObject'],
        highground = json['highground'],
        sightBlocker = json['sightBlocker'],
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
          json['difficulty'] as String,
        );
}
