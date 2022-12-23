class Stats {
  String damage = '';
  String pierce = '';
  String attackSpeed = '';
  String range = '';
  String type = '';

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
    type = json['type'];
  }
}

class Cost {
  int easy = 0;
  int medium = 0;
  int hard = 0;
  int impoppable = 0;

  Cost({required easy, required medium, required hard, required impoppable});

  Cost.fromJson(Map<String, dynamic> json) {
    easy = json['easy'];
    medium = json['medium'];
    hard = json['hard'];
    impoppable = json['impoppable'];
  }
}
