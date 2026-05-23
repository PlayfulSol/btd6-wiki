import 'package:flutter/material.dart';
import '/models/towers_v2/common/stats_class.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';

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

String _formatChangeKey(String key) =>
    _changeKeyLabels[key] ?? key.replaceAll('.', ' ').replaceAll('_', ' ');

class UpgradeStatsWidget extends StatelessWidget {
  final UpgradeStats stats;

  const UpgradeStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, String>>[
      MapEntry('Damage', stats.damage),
      MapEntry('Pierce', stats.pierce),
      MapEntry('Attack Speed', stats.attackSpeed),
      MapEntry('Range', stats.range),
      MapEntry('Camo', stats.camo),
    ].where((e) => e.value.isNotEmpty).toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return PropertyCard(
      title: 'Stats at this tier',
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          StatRow(label: entries[i].key, value: entries[i].value),
          if (i < entries.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class ChangesWidget extends StatelessWidget {
  final Map<String, String> changes;

  const ChangesWidget({super.key, required this.changes});

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
    final title = hasVersions ? 'Changes (v$from → v$to)' : 'Changes';

    return PropertyCard(
      title: title,
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          StatRow(
            label: _formatChangeKey(entries[i].key),
            value: entries[i].value.replaceAll(' -> ', ' → '),
          ),
          if (i < entries.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }
}
