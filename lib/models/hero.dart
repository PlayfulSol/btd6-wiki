import '/models/common.dart';

class HeroModel {
  late final String id;
  late final String name;
  late final String description;
  late final List<int> skinChange;
  late final List<Skins> skins;
  late final OldCost cost;
  late final OldStats stats;
  late final String levelSpeed;
  late final List<Levels> levels;
  HeroModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.skinChange,
      required this.skins,
      required this.cost,
      required this.stats,
      required this.levelSpeed,
      required this.levels});

  HeroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    skinChange = json['skinChange'].cast<int>();
    if (json['skins'] != []) {
      skins = <Skins>[];
      json['skins'].forEach((v) {
        skins.add(Skins.fromJson(v));
      });
    }
    cost = OldCost.fromJson(json['cost']);
    stats = OldStats.fromJson(json['stats']);
    levelSpeed = json['levelSpeed'];
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
  late final int level;
  late final String description;
  late final int xp;
  late final Rounds rounds;
  late final List<String> effects;

  Levels(
      {required this.level,
      required this.description,
      required this.xp,
      required this.rounds,
      required this.effects});

  Levels.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    description = json['description'];
    xp = json['xp'];
    rounds = Rounds.fromJson(json['rounds']);
    effects = json['effects'].cast<String>();
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
