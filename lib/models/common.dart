class Stats {
  late final String damage;
  late final String pierce;
  late final String attackSpeed;
  late final String range;
  // late final String? damageType;
  late final String camo;
  late final String statuseffects;
  late final String towerboosts;
  late final String incomeboosts;
  // late final String? footprint;

  Stats({
    required damage,
    required pierce,
    required attackSpeed,
    // required damageType,
    required range,
    required type,
    required camo,
    required statuseffects,
    required towerboosts,
    required incomeboosts,
    // required footprint,
  });

  Stats.fromJson(Map<String, dynamic> json) {
    damage = json['damage'];
    pierce = json['pierce'];
    attackSpeed = json['attackSpeed'];
    range = json['range'];
    // damageType = json['damageType'];
    camo = json["camo"];
    if (json["statusEffects"] is bool) {
      statuseffects = (json["statusEffects"] ? 'true' : 'false');
    } else if (json["statusEffects"] is String) {
      statuseffects = (json["statusEffects"]);
    }
    towerboosts = json["towerboosts"] ?? 'none';
    incomeboosts = json["incomeboosts"] ?? 'none';
    // footprint = json["footprint"];
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
