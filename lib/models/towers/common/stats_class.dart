class Stats {
  late final String damage;
  late final String pierce;
  late final String attackSpeed;
  late final String range;
  late final String camo;
  late final String statuseffects;
  late final String towerboosts;
  late final String incomeboosts;

  Stats(
    damage,
    pierce,
    attackSpeed,
    range,
    type,
    camo,
    statuseffects,
    towerboosts,
    incomeboosts,
  );

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

class HeroStats {
  late final dynamic data;

  HeroStats(
    this.data,
  );

  HeroStats.fromJson(dynamic json) {
    data = json;
  }
}
