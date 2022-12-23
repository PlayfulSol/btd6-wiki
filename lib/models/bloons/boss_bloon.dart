class BossBloonModel {
  late final String id;
  late final String name;
  late final String type;
  late final Rbe rbe;
  late final double speed;
  late final List<String> rounds;
  late final Spawns spawns;
  late final List<String> immunities;

  BossBloonModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rbe,
    required this.speed,
    required this.rounds,
    required this.spawns,
    required this.immunities,
  });

  BossBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    rbe = (json['rbe'] != null ? Rbe.fromJson(json['rbe']) : null)!;
    speed = json['speed'];
    rounds = json['rounds'].cast<String>();
    spawns = (json['spawns'] != null ? Spawns.fromJson(json['spawns']) : null)!;
    immunities = json['immunities'].cast<String>();
  }
}

class Rbe {
  late final List<int> base;
  late final List<int> elite;

  Rbe({required this.base, required this.elite});

  Rbe.fromJson(Map<String, dynamic> json) {
    base = json['base'].cast<int>();
    elite = json['elite'].cast<int>();
  }
}

class Spawns {
  late final List<Spawn> base;
  late final List<Spawn> elite;

  Spawns({required this.base, required this.elite});

  Spawns.fromJson(Map<String, dynamic> json) {
    if (json['base'] != null) {
      base = <Spawn>[];
      json['base'].forEach((v) {
        base.add(Spawn.fromJson(v));
      });
    }
    if (json['elite'] != null) {
      elite = <Spawn>[];
      json['elite'].forEach((v) {
        elite.add(Spawn.fromJson(v));
      });
    }
  }
}

class Spawn {
  late final List<SpawnedBloon> scatter;
  late final List<SpawnedBloon> skull;

  Spawn({required this.scatter, required this.skull});

  Spawn.fromJson(Map<String, dynamic> json) {
    if (json['scatter'] != null) {
      scatter = <SpawnedBloon>[];
      json['scatter'].forEach((v) {
        scatter.add(SpawnedBloon.fromJson(v));
      });
    }
    if (json['skull'] != null) {
      skull = <SpawnedBloon>[];
      json['skull'].forEach((v) {
        skull.add(SpawnedBloon.fromJson(v));
      });
    }
  }
}

class SpawnedBloon {
  late final String bloon;
  late final int count;
  String? variant;

  SpawnedBloon({required this.bloon, required this.count, this.variant});

  SpawnedBloon.fromJson(Map<String, dynamic> json) {
    bloon = json['bloon'];
    count = json['count'];
    variant = json['variant'];
  }
}
