import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/towers_v2/tower/tower.dart';
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
          favoriteState.toggleFavoriteFunc(context, favoriteState, tower),
      headerContent: Padding(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 52),
        child: AppImage(path: towerImage(tower.image)),
      ),
      body: [
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
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Description',
          children: [Text(tower.inGameDesc, style: normalStyle)],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Stats',
          children: [
            for (final e in <MapEntry<String, String>>[
              MapEntry('Damage', tower.stats.damage),
              MapEntry('Pierce', tower.stats.pierce),
              MapEntry('Attack Speed', tower.stats.attackSpeed),
              MapEntry('Range', tower.stats.range),
              MapEntry('Camo', tower.stats.camo),
              MapEntry('Footprint', tower.stats.footprint),
              MapEntry('Damage Type', tower.stats.damageType),
              MapEntry('Status Effects', tower.stats.statuseffects),
              MapEntry('Tower Boosts', tower.stats.towerboosts),
              MapEntry('Income Boosts', tower.stats.incomeboosts),
            ].where((e) => e.value.isNotEmpty)) ...[
              StatRow(label: e.key, value: e.value),
              const SizedBox(height: 4),
            ],
          ],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Cost',
          children: [
            StatRow(label: 'Easy', value: tower.cost.easy),
            const SizedBox(height: 4),
            StatRow(label: 'Medium', value: tower.cost.medium),
            const SizedBox(height: 4),
            StatRow(label: 'Hard', value: tower.cost.hard),
            const SizedBox(height: 4),
            StatRow(label: 'Impoppable', value: tower.cost.impoppable),
          ],
        ),
        if (tower.changes != null) ...[
          const SizedBox(height: 8),
          ChangesWidget(changes: tower.changes!),
        ],
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
