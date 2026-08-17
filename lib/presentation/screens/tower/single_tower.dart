import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/towers/tower/tower.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/presentation/widgets/common/stats_and_changes.dart';
import '/presentation/widgets/towers/path.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

Color _classColor(String classType) => GameColors.forClass(classType);

class SingleTower extends StatefulWidget {
  const SingleTower({
    super.key,
    required this.analyticsHelper,
    required this.towerId,
  });

  final AnalyticsHelper analyticsHelper;
  final String towerId;

  @override
  State<SingleTower> createState() => _SingleTowerState();
}

class _SingleTowerState extends State<SingleTower> {
  late TowerModelV2 tower;
  bool loading = true;

  MonkeyPath _buildPath(int index) {
    final hasParagon = tower.paths.paragon != null;
    return MonkeyPath(
      path: index == 0
          ? tower.paths.path1
          : index == 1
              ? tower.paths.path2
              : index == 2
                  ? tower.paths.path3
                  : hasParagon
                      ? [tower.paths.paragon!]
                      : [],
      pathKey: getPathKeyFromIndex(index),
      monkeyId: tower.id,
      analyticsHelper: widget.analyticsHelper,
    );
  }

  void loadTower() async {
    final path = '${towerDataPath + widget.towerId}.json';
    final data = await rootBundle.loadString(path);
    tower = TowerModelV2.fromJson(json.decode(data));
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kTowerPagesClass,
      screenName: widget.towerId,
    );
    loadTower();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final classColor = _classColor(tower.classType);
    final favoriteState = context.watch<FavoriteState>();
    final isFav = favoriteState.isFavorite(tower.type, tower.id);

    return DetailPageScaffold(
      title: tower.name,
      accentColor: classColor,
      isFavorite: isFav,
      onFavoriteToggle: () =>
          favoriteState.toggleFavoriteFunc(context, tower),
      headerContent: Padding(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 52),
        child: AppImage(path: towerImage(tower.image)),
      ),
      body: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text(
                tower.classType,
                style: TextStyle(
                  color: classColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              backgroundColor: classColor.withValues(alpha: 0.12),
              side: BorderSide(color: classColor.withValues(alpha: 0.4)),
              visualDensity: VisualDensity.compact,
            ),
            if (tower.changes != null || tower.versionDiff != null)
              Chip(
                label: Text(
                  tower.changes == 'new' ? 'New' : 'Updated',
                  style: const TextStyle(
                    color: GameColors.danger,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: GameColors.danger.withValues(alpha: 0.12),
                side: BorderSide(color: GameColors.danger.withValues(alpha: 0.4)),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Description',
          children: [Text(tower.inGameDesc, style: normalStyle)],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Stats',
          titleWidget: diffHasPrefix(tower.versionDiff, 'stats.')
              ? cardBadgeTitle(context, 'Stats')
              : null,
          children: [
            StatTileGrid(
              items: <(String, String)>[
                if (tower.attacks.isNotEmpty) ...[
                  ('Damage', tower.attacks.first.damage),
                  ('Pierce', tower.attacks.first.pierce),
                  ('Attack Speed', tower.attacks.first.attackSpeed),
                  ('Range', tower.attacks.first.range),
                  ('Camo', tower.attacks.first.camo ? 'Yes' : 'No'),
                  if (tower.attacks.first.damageModifiers.isNotEmpty)
                    ('Damage Mods', tower.attacks.first.damageModifiers),
                ],
                ('Footprint', tower.footprint),
                ('Damage Type', tower.damageType),
                ('Target', tower.target),
                ('Camo Unlock', tower.camoUnlock),
              ].where((e) => e.$2.isNotEmpty).toList(),
            ),
            if (filterDiff(tower.versionDiff, 'stats.') != null) ...[
              const SizedBox(height: 8),
              ChangesWidget(changes: filterDiff(tower.versionDiff, 'stats.')!),
            ],
          ],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Cost',
          titleWidget: diffHasPrefix(tower.versionDiff, 'cost.')
              ? cardBadgeTitle(context, 'Cost')
              : null,
          children: [
            StatTileGrid(items: [
              ('Easy', tower.cost.easy),
              ('Medium', tower.cost.medium),
              ('Hard', tower.cost.hard),
              ('Impoppable', tower.cost.impoppable),
            ]),
            if (filterDiff(tower.versionDiff, 'cost.') != null) ...[
              const SizedBox(height: 8),
              ChangesWidget(changes: filterDiff(tower.versionDiff, 'cost.')!),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: tower.paths.paragon != null ? 4 : 3,
          itemBuilder: (_, index) => _buildPath(index),
        ),
      ],
    );
  }
}
