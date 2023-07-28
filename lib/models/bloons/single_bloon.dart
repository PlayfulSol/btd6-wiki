import '/models/bloons/bloon_hierarchy.dart';

class SingleBloonModel {
  late final String id;
  late final String name;
  late final String type;
  late final int rbe;
  late final dynamic speed;
  dynamic hp;
  int? initialRound;
  int? initialRoundABR;
  late final List<BloonHierarchyModel> children;
  late final List<BloonHierarchyModel> parents;
  late final List<String> immunities;
  late final List<String> variants;

  SingleBloonModel(
      {required this.id,
      required this.name,
      required this.type,
      required this.rbe,
      required this.speed,
      this.hp,
      this.initialRound,
      this.initialRoundABR,
      required this.children,
      required this.parents,
      required this.immunities,
      required this.variants});

  SingleBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    rbe = json['rbe'];
    speed = json['speed'];
    hp = json['hp'];
    initialRound = json['initialRound'];
    initialRoundABR = json['initialRoundABR'];
    if (json['children'] != null) {
      children = <BloonHierarchyModel>[];
      json['children'].forEach((v) {
        children.add(BloonHierarchyModel.fromJson(v));
      });
    }
    if (json['parents'] != null) {
      parents = <BloonHierarchyModel>[];
      json['parents'].forEach((v) {
        parents.add(BloonHierarchyModel.fromJson(v));
      });
    }
    if (json['immunities'] != null) {
      immunities = <String>[];
      json['immunities'].forEach((v) {
        immunities.add(v);
      });
    }
    variants = json['variants'].cast<String>();
  }
}
