class Stats {
  late final String damage;
  late final String pierce;
  late final String attackSpeed;
  late final String range;
  late final String camo;
  late final String statuseffects;
  late final String towerboosts;
  late final String incomeboosts;

  Stats({
    required damage,
    required pierce,
    required attackSpeed,
    required range,
    required type,
    required camo,
    required statuseffects,
    required towerboosts,
    required incomeboosts,
  });

  Stats.fromJson(Map<String, dynamic> json) {
    damage = json['damage'];
    pierce = json['pierce'];
    attackSpeed = json['attackSpeed'];
    range = json['range'];
    camo = json["camo"];
    if (json["statuseffects"] is bool) {
      statuseffects = (json["statuseffects"] ? 'true' : 'false');
    } else if (json["statuseffects"] is String) {
      statuseffects = (json["statuseffects"]);
    }
    towerboosts = json["towerboosts"] ?? 'none';
    incomeboosts = json["incomeboosts"] ?? 'none';
  }
}

class Cost {
  late final String easy;
  late final String medium;
  late final String hard;
  late final String impoppable;

  Cost({required easy, required medium, required hard, required impoppable});

  Cost.fromJson(dynamic json) {
    try {
      easy = json['easy'];
      medium = json['medium'];
      hard = json['hard'];
      impoppable = json['impoppable'];
    } catch (e) {
      // Handle the exception or provide default values
      easy = json;
      medium = json;
      hard = json;
      impoppable = json;
    }
  }
}
