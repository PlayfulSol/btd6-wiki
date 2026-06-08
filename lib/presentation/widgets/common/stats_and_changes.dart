import 'package:flutter/material.dart';
import '/models/towers/common/attack_class.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

/// Returns only the entries whose keys start with [prefix] (excluding
/// the metadata keys fromVersion/toVersion).
Map<String, String>? filterDiff(Map<String, String>? vd, String prefix) {
  if (vd == null) return null;
  final result = <String, String>{};
  for (final e in vd.entries) {
    if (e.key == 'fromVersion' || e.key == 'toVersion' || e.key.startsWith(prefix)) {
      result[e.key] = e.value;
    }
  }
  final hasData = result.keys.any((k) => k != 'fromVersion' && k != 'toVersion');
  return hasData ? result : null;
}

/// Whether [vd] has any change entries matching [prefix].
bool diffHasPrefix(Map<String, String>? vd, String prefix) {
  if (vd == null) return false;
  return vd.keys.any((k) =>
      k != 'fromVersion' && k != 'toVersion' && k.startsWith(prefix));
}

/// Standard badge-title widget for a [PropertyCard] that has changes.
Widget cardBadgeTitle(BuildContext context, String title) {
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: bolderNormalStyle.copyWith(
            fontSize: 19,
            color: colorScheme.primary,
          ),
        ),
      ),
      Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: GameColors.danger,
          shape: BoxShape.circle,
          border: Border.all(
              color: colorScheme.surfaceContainerHighest, width: 1.5),
        ),
      ),
    ],
  );
}

const _changeKeyLabels = {
  'cost.easy': 'Cost (Easy)',
  'cost.medium': 'Cost (Medium)',
  'cost.hard': 'Cost (Hard)',
  'cost.impoppable': 'Cost (Impoppable)',
  'unlock': 'XP Cost',
  'stats.damage': 'Damage',
  'stats.pierce': 'Pierce',
  'stats.attackSpeed': 'Attack Speed',
  'stats.range': 'Range',
  'stats.camo': 'Camo',
  'stats.damageType': 'Damage Type',
  'stats.footprint': 'Footprint',
};

String _singularize(String word) {
  if (word.endsWith('ies')) return '${word.substring(0, word.length - 3)}y';
  if (word.endsWith('s') && word.length > 2) return word.substring(0, word.length - 1);
  return word;
}

String _formatChangeKey(
  String key, {
  List<Attack>? attacks,
  List<Ability>? abilities,
}) {
  if (_changeKeyLabels.containsKey(key)) return _changeKeyLabels[key]!;
  final parts = key.split('.');
  final formatted = <String>[];
  for (final part in parts) {
    final arrayMatch = RegExp(r'^(\w+)\[(\d+)\]$').firstMatch(part);
    if (arrayMatch != null) {
      final index = int.parse(arrayMatch[2]!);
      final type = arrayMatch[1]!;
      if (type == 'attacks' && attacks != null && index < attacks.length) {
        formatted.add(_attackLabel(attacks[index].label));
      } else if (type == 'abilities' && abilities != null && index < abilities.length) {
        formatted.add(abilities[index].displayName);
      } else {
        final base = _singularize(camelToTitle(type));
        formatted.add(index == 0 ? base : '$base ${index + 1}');
      }
    } else {
      formatted.add(camelToTitle(part));
    }
  }
  return formatted.join(' · ');
}

String _attackLabel(String label) {
  if (label == 'main') return 'Attack';
  return label
      .split('_')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

class AttacksWidget extends StatelessWidget {
  final List<Attack> attacks;
  final List<Ability> abilities;

  const AttacksWidget({
    super.key,
    required this.attacks,
    this.abilities = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (attacks.isEmpty && abilities.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final showLabels = attacks.length > 1;
    final rows = <Widget>[];

    for (int i = 0; i < attacks.length; i++) {
      final a = attacks[i];
      if (i > 0) {
        rows.add(Container(height: 0.5, color: colorScheme.outlineVariant));
      }
      if (showLabels) {
        rows.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _attackLabel(a.label),
            style: subtitleStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ));
      }
      final data = <(String, String)>[
        ('Damage', a.damage),
        ('Pierce', a.pierce),
        ('Attack Speed', a.attackSpeed),
        ('Range', a.range),
        ('Camo', a.camo ? 'Yes' : 'No'),
        if (a.damageModifiers.isNotEmpty) ('Damage Mods', a.damageModifiers),
      ].where((e) => e.$2.isNotEmpty).toList();

      rows.add(StatTileGrid(items: data));
    }

    if (abilities.isNotEmpty) {
      if (rows.isNotEmpty) {
        rows.add(Container(height: 0.5, color: colorScheme.outlineVariant));
      }
      rows.add(StatTileGrid(
        items: abilities.map((ab) {
          final cd = ab.cooldown == ab.cooldown.roundToDouble()
              ? '${ab.cooldown.toInt()}s'
              : '${ab.cooldown}s';
          final value = ab.damageModifiers.isNotEmpty
              ? '$cd cooldown · ${ab.damageModifiers}'
              : '$cd cooldown';
          return (ab.displayName, value);
        }).toList(),
      ));
    }

    return PropertyCard(
      title: 'Stats',
      children: rows,
    );
  }
}

class ChangesWidget extends StatelessWidget {
  final Map<String, String> changes;
  final List<Attack> attacks;
  final List<Ability> abilities;

  const ChangesWidget({
    super.key,
    required this.changes,
    this.attacks = const [],
    this.abilities = const [],
  });

  @override
  Widget build(BuildContext context) {
    final entries = changes.entries
        .where((e) => e.key != 'fromVersion' && e.key != 'toVersion')
        .toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    final from = changes['fromVersion'];
    final to = changes['toVersion'];
    final hasVersions =
        from != null && to != null && from != 'unknown' && to != 'unknown';

    final colorScheme = Theme.of(context).colorScheme;
    final titleStyle = bolderNormalStyle.copyWith(
      fontSize: 19,
      color: colorScheme.primary,
    );

    final titleText =
        hasVersions ? 'Changes (v$from -> v$to)' : 'Changes';

    return PropertyCard(
      title: titleText,
      titleWidget: arrowText(context, titleText, titleStyle, iconSize: 16),
      children: [
        StatTileGrid(
          items: entries
              .map((e) => (
                    _formatChangeKey(e.key, attacks: attacks, abilities: abilities),
                    e.value,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
