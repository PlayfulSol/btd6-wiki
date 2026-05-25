import 'package:flutter/material.dart';
import '/models/towers/common/upgrade_class.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/presentation/widgets/common/stats_and_changes.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/presentation/widgets/common/property_card.dart';
import '/utilities/constants.dart';

class MonkeyPath extends StatelessWidget {
  final List<TowerUpgrade> path;
  final String pathKey;
  final String monkeyId;
  final AnalyticsHelper analyticsHelper;

  const MonkeyPath({
    super.key,
    required this.path,
    required this.pathKey,
    required this.monkeyId,
    required this.analyticsHelper,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          pathsDictionary[pathKey]!,
          style: titleStyle.copyWith(color: colorScheme.primary),
        ),
        onExpansionChanged: (bool value) {
          analyticsHelper.logEvent(
            name: widgetEngagement,
            parameters: {
              'screen': monkeyId,
              'widget': expansionTile,
              'value': '${pathKey}_$value',
            },
          );
        },
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: path.length,
            itemBuilder: (context, index) {
              final upgrade = path[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                color: colorScheme.surfaceContainerLow,
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: colorScheme.primaryContainer,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Text(
                        upgrade.name,
                        style: bolderNormalStyle.copyWith(
                          fontSize: 14,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: AppImage(
                                  path: towerImage(upgrade.image),
                                  semanticLabel: upgrade.name,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  upgrade.upgradeBody,
                                  style: normalStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          PropertyCard(
                            title: 'Cost',
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _CostCell(label: 'Easy', value: upgrade.cost.easy)),
                                  Expanded(child: _CostCell(label: 'Medium', value: upgrade.cost.medium)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _CostCell(label: 'Hard', value: upgrade.cost.hard)),
                                  Expanded(child: _CostCell(label: 'Impoppable', value: upgrade.cost.impoppable)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              StatRow(label: 'XP Required', value: upgrade.unlock),
                            ],
                          ),
                          if (upgrade.stats != null) ...[
                            const SizedBox(height: 12),
                            UpgradeStatsWidget(stats: upgrade.stats!),
                          ],
                          if (upgrade.changes != null) ...[
                            const SizedBox(height: 12),
                            ChangesWidget(changes: upgrade.changes!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CostCell extends StatelessWidget {
  final String label;
  final String value;
  const _CostCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value, style: normalStyle.copyWith(fontSize: 14)),
      ],
    );
  }
}
