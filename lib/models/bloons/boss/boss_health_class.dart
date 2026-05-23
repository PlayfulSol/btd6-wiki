class BossTrigger {
  final double? at;
  final double? every;
  final String bloon;
  final int count;
  final bool repeating;

  BossTrigger.fromJson(Map<String, dynamic> json)
      : at = json['at'] != null ? (json['at'] as num).toDouble() : null,
        every =
            json['every'] != null ? (json['every'] as num).toDouble() : null,
        bloon = json['bloon'] as String,
        count = json['count'] as int,
        repeating = json['repeating'] as bool? ?? false;

  String get label {
    if (every != null) {
      final pct = (every! * 100).round();
      return 'Every $pct% health: $count $bloon (repeating)';
    }
    final pct = ((at ?? 0) * 100).round();
    return 'At $pct% health: $count $bloon';
  }
}

class BossTier {
  final int tier;
  final int health;
  final double speed;
  final double? speedRelative;
  final bool isCamo;
  final List<BossTrigger> triggers;
  final Map<String, dynamic> mechanics;

  BossTier.fromJson(Map<String, dynamic> json)
      : tier = json['tier'] as int,
        health = json['health'] as int,
        speed = (json['speed'] as num).toDouble(),
        speedRelative = json['speedRelative'] != null
            ? (json['speedRelative'] as num).toDouble()
            : null,
        isCamo = json['isCamo'] as bool? ?? false,
        triggers = (json['triggers'] as List? ?? [])
            .map((e) => BossTrigger.fromJson(e))
            .toList(),
        mechanics = Map<String, dynamic>.from(json['mechanics'] ?? {});
}

class BossTiers {
  final List<BossTier> normal;
  final List<BossTier> elite;

  BossTiers.fromJson(Map<String, dynamic> json)
      : normal = (json['normal'] as List)
            .map((e) => BossTier.fromJson(e))
            .toList(),
        elite = (json['elite'] as List)
            .map((e) => BossTier.fromJson(e))
            .toList();
}

class BossMinion {
  final String id;
  final String name;
  final String image;
  final String? imageElite;
  final bool isMoab;
  final bool isCamo;
  // health is either a flat int or per-tier lists
  final int? healthFlat;
  final List<int>? healthNormal;
  final List<int>? healthElite;
  // speed is either a flat double or per-mode
  final double? speedFlat;
  final double? speedNormal;
  final double? speedElite;

  bool get hasTierHealth => healthNormal != null;
  bool get hasModeSpeed => speedNormal != null;

  BossMinion.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        image = json['image'] as String,
        imageElite = json['imageElite'] as String?,
        isMoab = json['isMoab'] as bool? ?? false,
        isCamo = json['isCamo'] as bool? ?? false,
        healthFlat =
            json['health'] is int ? json['health'] as int : null,
        healthNormal = json['health'] is Map
            ? List<int>.from(json['health']['normal'])
            : null,
        healthElite = json['health'] is Map
            ? List<int>.from(json['health']['elite'])
            : null,
        speedFlat =
            json['speed'] is num && json['speed'] is! Map
                ? (json['speed'] as num).toDouble()
                : null,
        speedNormal = json['speed'] is Map
            ? (json['speed']['normal'] as num).toDouble()
            : null,
        speedElite = json['speed'] is Map
            ? (json['speed']['elite'] as num).toDouble()
            : null;
}
