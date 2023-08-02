class Stats {
  late final String damage;
  late final String pierce;
  late final String attackSpeed;
  late final String range;
  late final String damageType;

  Stats(
      {required damage,
      required pierce,
      required attackSpeed,
      required range,
      required type});

  Stats.fromJson(Map<String, dynamic> json) {
    damage = json['damage'];
    pierce = json['pierce'];
    attackSpeed = json['attackSpeed'];
    range = json['range'];
    damageType = json['damageType'];
  }
}

class Cost {
  late final String easy;
  late final String medium;
  late final String hard;
  late final String impoppable;

  Cost({required easy, required medium, required hard, required impoppable});

  Cost.fromJson(Map<String, dynamic> json) {
    easy = json['easy'];
    medium = json['medium'];
    hard = json['hard'];
    impoppable = json['impoppable'];
  }
}
