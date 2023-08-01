class MapModel {
  late final String? id;
  late final String name;
  late final String image;
  late final String difficulty;
  late final String? entrances;
  late final String? exits;
  late final String? length;
  late final String? music;
  late final String? terrain;
  late final String? water;
  late final String? removableObject;
  late final String? highground;
  late final String? sightBlocker;

  MapModel(
      {required this.name,
      required this.image,
      required this.difficulty,
      this.id,
      this.entrances,
      this.exits,
      this.length,
      this.music,
      this.terrain,
      this.water,
      this.removableObject,
      this.highground,
      this.sightBlocker});

  MapModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    difficulty = json['difficulty'];
    entrances = json['entrances'];
    exits = json['exits'];
    length = json['length'];
    music = json['music'];
    terrain = json['terrain'];
    water = json['water'];
    removableObject = json['removableObject'];
    highground = json['highground'];
    sightBlocker = json['sightBlocker'];
  }
}
