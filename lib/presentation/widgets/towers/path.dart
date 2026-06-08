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
        title: Row(
          children: [
            Text(
              pathsDictionary[pathKey]!,
              style: titleStyle.copyWith(color: colorScheme.primary),
            ),
            if (path.any((u) => u.changes != null)) ...[
              const SizedBox(width: 8),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: GameColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: colorScheme.surfaceContainerHighest, width: 1.5),
                ),
              ),
            ],
          ],
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              upgrade.name,
                              style: bolderNormalStyle.copyWith(
                                fontSize: 14,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          if (upgrade.changes != null)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: GameColors.danger,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colorScheme.primaryContainer,
                                    width: 1.5),
                              ),
                            ),
                        ],
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(upgrade.upgradeBody, style: normalStyle),
                                    const SizedBox(height: 8),
                                    StatTile(label: 'XP Required', value: upgrade.unlock),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          PropertyCard(
                            title: 'Cost',
                            children: [
                              StatTileGrid(items: [
                                ('Easy', upgrade.cost.easy),
                                ('Medium', upgrade.cost.medium),
                                ('Hard', upgrade.cost.hard),
                                ('Impoppable', upgrade.cost.impoppable),
                              ]),
                            ],
                          ),
                          if (upgrade.attacks.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            AttacksWidget(attacks: upgrade.attacks, abilities: upgrade.abilities),
                          ],
                          if (upgrade.changes != null) ...[
                            const SizedBox(height: 12),
                            ChangesWidget(changes: upgrade.changes!, attacks: upgrade.attacks, abilities: upgrade.abilities),
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

