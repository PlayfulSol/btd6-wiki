class BossBloonModel {
  late final String id;
  late final String name;
  late final String description;
  late final Map<String, dynamic> images;
  late final Health health;
  late final Map<String, dynamic> skullCount;
  late final List<String> immunities;
  late final Map<String, dynamic> gimmicks;

  BossBloonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.health,
    required this.skullCount,
    required this.immunities,
    required this.gimmicks,
  });

  BossBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    images = json["images"];
    health = Health.fromJson(json["health"]);
    skullCount = json['skullCount'];
    immunities = List<String>.from(['generalImmunities']);
    gimmicks = json["gimmicks"];
  }
}

class Health {
  late final List<TierHealth> base;
  late final List<TierHealth> elite;

  Health({required this.base, required this.elite});

  Health.fromJson(Map<String, dynamic> json) {
    if (json['normal'] != null) {
      base = <TierHealth>[];
      json['normal'].forEach((v) {
        base.add(TierHealth.fromJson(v));
      });
    }
    if (json['elite'] != null) {
      elite = <TierHealth>[];
      json['elite'].forEach((v) {
        elite.add(TierHealth.fromJson(v));
      });
    }
  }
}

class TierHealth {
  late final String tier;
  late final String normal;
  late final String coop2;
  late final String coop3;
  late final String coop4;

  TierHealth({
    required this.tier,
    required this.normal,
    required this.coop2,
    required this.coop3,
    required this.coop4,
  });

  TierHealth.fromJson(Map<String, dynamic> json) {
    tier = json["tier"];
    normal = json["normal"];
    coop2 = json["coop2"];
    coop3 = json["coop3"];
    coop4 = json["coop4"];
  }
}
