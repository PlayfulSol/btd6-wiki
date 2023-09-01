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

class HeroModel {
  // late final String id;
  late final String name;
  late final String skinChange;
  late final String cost;
  late final String abilities;
  late final String target;
  late final String? inGameDesc;
  late final String image;
  // late final List<int> skinChange;
  // late final List<Skins> skins;
  // late final Cost cost;
  late final Stats properties;
  // late final String levelSpeed;
  late final List<Levels> levels;
  // late final String abilities;
  // late final dynamic properties;
  HeroModel(
      {required this.name,
      required this.inGameDesc,
      required this.image,
      required this.skinChange,
      // required this.skins,
      required this.cost,
      // required this.stats,
      required this.levels,
      required this.properties});

  HeroModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    inGameDesc = json['description'];
    image = json['image'];
    // skinChange = json['skinChange'].cast<int>();
    skinChange = json['skinChange'];
    // if (json['skins'] != []) {
    //   skins = <Skins>[];
    //   json['skins'].forEach((v) {
    //     skins.add(Skins.fromJson(v));
    //   });
    // }
    // cost = Cost.fromJson(json['cost']);
    cost = json['cost'];
    properties = Stats.fromJson(json['properties']);
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
  // late final int level;
  late final String name;
  late final String description;
  late final String image;
  // late final int xp;
  late final String unlock;
  late final String cost;
  // late final Rounds rounds;
  // late final List<String> effects;

  Levels({
    // required this.level,
    required this.name,
    required this.description,
    required this.image,
    required this.unlock,
    required this.cost,
    // required this.rounds,
    // required this.effects
  });

  Levels.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['levelBody'];
    image = json['image'];
    unlock = json['unlock'];
    cost = json['cost'];
    // rounds = Rounds.fromJson(json['rounds']);
    // effects = json['effects'].cast<String>();
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
