import 'dart:convert';

String _parseStat(Object? v) {
  if (v == null) return '';
  if (v is String && v.startsWith('{')) {
    try {
      final map = json.decode(v) as Map<String, dynamic>;
      return map.entries.map((e) {
        final label = e.key[0].toUpperCase() + e.key.substring(1);
        return '$label: ${e.value}';
      }).join(', ');
    } catch (_) {}
  }
  return v.toString();
}

class Stats {
  final String damage;
  final String pierce;
  final String attackSpeed;
  final String range;
  final String camo;
  final String footprint;
  final String damageType;
  final String statuseffects;
  final String towerboosts;
  final String incomeboosts;

  Stats.fromJson(Map<String, dynamic> json)
      : damage = _parseStat(json['damage']),
        pierce = _parseStat(json['pierce']),
        attackSpeed = _parseStat(json['attackSpeed']),
        range = _parseStat(json['range']),
        camo = _parseStat(json['camo']),
        footprint = _parseStat(json['footprint']),
        damageType = _parseStat(json['damageType']),
        statuseffects = _parseStat(json['statuseffects']),
        towerboosts = _parseStat(json['towerboosts']),
        incomeboosts = _parseStat(json['incomeboosts']);
}

class UpgradeStats {
  final String damage;
  final String pierce;
  final String attackSpeed;
  final String range;
  final String camo;

  UpgradeStats.fromJson(Map<String, dynamic> json)
      : damage = _parseStat(json['damage']),
        pierce = _parseStat(json['pierce']),
        attackSpeed = _parseStat(json['attackSpeed']),
        range = _parseStat(json['range']),
        camo = _parseStat(json['camo']);
}
