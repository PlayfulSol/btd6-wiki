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

String _formatRange(dynamic v) {
  if (v == null) return '';
  final n = v is int ? v : int.tryParse(v.toString());
  if (n == null) return v.toString();
  return n >= 9999999 ? '∞' : n.toString();
}

const _modKeyLabels = <String, String>{
  'moabs': 'MOABs',
  'moab': 'MOAB',
  'ceramic': 'Ceramic',
  'ddt': 'DDT',
  'fortified': 'Fortified',
  'boss': 'Boss',
};

String _formatModifierKey(String key) =>
    _modKeyLabels[key.toLowerCase()] ??
    key
        .split('_')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');

String formatModifiers(Map<String, dynamic>? mods) {
  if (mods == null || mods.isEmpty) return '';
  return mods.entries
      .map((e) => '${_formatModifierKey(e.key)}: +${e.value}')
      .join(', ');
}

class Attack {
  final String label;
  final String damage;
  final String pierce;
  final String attackSpeed;
  final String range;
  final bool camo;
  final String damageModifiers;

  Attack.fromJson(Map<String, dynamic> json)
      : label = json['label'] as String? ?? 'main',
        damage = _parseStat(json['damage']),
        pierce = _parseStat(json['pierce']),
        attackSpeed = json['attackSpeed'] as String? ?? '',
        range = _formatRange(json['range']),
        camo = json['camo'] as bool? ?? false,
        damageModifiers = formatModifiers(
            json['damageModifiers'] as Map<String, dynamic>?);
}

final _genericAbilityLabel = RegExp(r'^ability_\d+$');

const _abilityLabelOverrides = {'isabm': 'ISABM'};

String _formatAbilityLabel(String label) {
  if (_genericAbilityLabel.hasMatch(label)) return 'Ability';
  if (_abilityLabelOverrides.containsKey(label)) return _abilityLabelOverrides[label]!;
  return label
      .replaceAll('_ability', '')
      .split('_')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

class Ability {
  final String displayName;
  final double cooldown;
  final String damageModifiers;

  Ability.fromJson(Map<String, dynamic> json)
      : displayName = _formatAbilityLabel(json['label'] as String? ?? ''),
        cooldown = (json['cooldown'] as num?)?.toDouble() ?? 0.0,
        damageModifiers = formatModifiers(
            json['damageModifiers'] as Map<String, dynamic>?);
}

List<Attack> parseAttacks(dynamic json) =>
    (json as List? ?? [])
        .map((e) => Attack.fromJson(e as Map<String, dynamic>))
        .toList();

List<Ability> parseAbilities(dynamic json) =>
    (json as List? ?? [])
        .map((e) => Ability.fromJson(e as Map<String, dynamic>))
        .toList();
