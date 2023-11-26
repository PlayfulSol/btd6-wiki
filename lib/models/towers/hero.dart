import '/models/towers/common.dart';

class MenuHeroModel {
  late final String id;
  late final String name;
  late final String image;
  late final String inGameDesc;
  MenuHeroModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.inGameDesc});

  MenuHeroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    inGameDesc = json['inGameDesc'];
  }
}

class HeroStats {
  late final dynamic data;

  HeroStats({required this.data});

  HeroStats.fromJson(dynamic json) {
    data = json;
  }
}

class HeroModel {
  late final String name;
  late final Map<String, dynamic> skinChange;
  late final String abilities;
  late final String target;
  late final String? inGameDesc;
  late final String image;
  late final Cost cost;
  late final HeroStats stats;
  late final List<Levels> levels;
  HeroModel({
    required this.name,
    required this.skinChange,
    required this.abilities,
    required this.target,
    required this.inGameDesc,
    required this.image,
    required this.cost,
    required this.stats,
    required this.levels,
  });

  HeroModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    inGameDesc = json['inGameDesc'];
    image = json['image'];
    skinChange = json['skinChange'];
    abilities = json['abilities'];
    target = json['target'];
    cost = Cost.fromJson(json['cost']);
    stats = HeroStats.fromJson(json['stats']);
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels.add(Levels.fromJson(v));
      });
    }
  }
}

class Skins {
  late final String id;
  late final String name;

  Skins({required this.id, required this.name});

  Skins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Levels {
  late final String name;
  late final String description;
  late final String image;
  late final dynamic cost;

  Levels({
    required this.name,
    required this.description,
    required this.image,
    required this.cost,
  });

  Levels.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['levelBody'];
    image = json['image'];
    cost = json['cost'];
  }
}
