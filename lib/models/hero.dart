import '/models/common.dart';

class MenuHeroModel {
  late final String id;
  late final String name;
  late final String image;
  late final String? inGameDesc;
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
  late final dynamic testStats;
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
    required this.testStats,
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
    testStats = json['stats'];
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

class Special {
  String? name;
  String? value;

  Special({this.name, this.value});

  Special.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class Levels {
  late final String name;
  late final String description;
  late final String image;
  late final String unlock;
  late final dynamic cost;

  Levels({
    required this.name,
    required this.description,
    required this.image,
    required this.unlock,
    required this.cost,
  });

  Levels.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['levelBody'];
    image = json['image'];
    unlock = json['unlock'];
    cost = json['cost'];
  }
}

class Rounds {
  String? easy;
  String? medium;
  String? hard;
  String? impoppable;

  Rounds({this.easy, this.medium, this.hard, this.impoppable});

  Rounds.fromJson(Map<String, dynamic> json) {
    easy = json['easy'];
    medium = json['medium'];
    hard = json['hard'];
    impoppable = json['impoppable'];
  }
}
