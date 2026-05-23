import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/maps/map.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/presentation/widgets/maps/map_card.dart';

class SingleMap extends StatefulWidget {
  const SingleMap({
    super.key,
    required this.analyticsHelper,
    required this.mapId,
  });

  final AnalyticsHelper analyticsHelper;
  final String mapId;

  @override
  State<SingleMap> createState() => _SingleMapState();
}

class _SingleMapState extends State<SingleMap> {
  late final MapModel map;
  bool loading = true;

  void loadMap() async {
    var path = '${mapDataPath + widget.mapId}.json';
    final data = await rootBundle.loadString(path);
    map = MapModel.fromJson(json.decode(data));
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMapPagesClass,
      screenName: widget.mapId,
    );
    loadMap();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final accentColor = difficultyColor(map.difficulty);
    final favoriteState = context.watch<FavoriteState>();
    final isFav = favoriteState.isFavorite(map.type, map.id);

    return DetailPageScaffold(
      title: map.name,
      accentColor: accentColor,
      isFavorite: isFav,
      onFavoriteToggle: () =>
          favoriteState.toggleFavoriteFunc(context, favoriteState, map),
      headerContent: Padding(
        padding: const EdgeInsets.fromLTRB(16, 56, 16, 48),
        child: AppImage(
          path: mapImage(map.image),
          semanticLabel: map.name,
        ),
      ),
      body: [
        Chip(
          label: Text(
            map.difficulty,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          backgroundColor: accentColor.withValues(alpha: 0.12),
          side: BorderSide(color: accentColor.withValues(alpha: 0.4)),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(height: 12),

        Builder(builder: (context) {
          final data = <(String, String)>[
            if (map.terrain != null && map.terrain.toString().isNotEmpty)
              ('Terrain', map.terrain.toString()),
            if (map.water != null && map.water!.isNotEmpty)
              ('Water', map.water!),
            if (map.entrances != null && map.entrances!.isNotEmpty)
              ('Entrances', map.entrances!),
            if (map.exits != null && map.exits!.isNotEmpty)
              ('Exits', map.exits!),
            if (map.removableObject != null &&
                map.removableObject.toString().isNotEmpty)
              ('Removable Objects', map.removableObject.toString()),
            if (map.highground != null &&
                map.highground.toString().isNotEmpty)
              ('Highground', map.highground.toString()),
            if (map.sightBlocker != null && map.sightBlocker!.isNotEmpty)
              ('Sight Blocker', map.sightBlocker!),
            if (map.coopDivision != null && map.coopDivision!.isNotEmpty)
              ('Co-op Division', map.coopDivision!),
          ];
          if (data.isEmpty) return const SizedBox.shrink();
          return PropertyCard(
            title: 'Map Properties',
            children: [
              for (int i = 0; i < data.length; i++) ...[
                StatRow(label: data[i].$1, value: data[i].$2),
                if (i < data.length - 1) const SizedBox(height: 4),
              ],
            ],
          );
        }),

        if (map.length != null && map.length!.isNotEmpty) ...[
          const SizedBox(height: 12),
          PropertyCard(title: 'Length', children: [
            Text(map.length!, style: normalStyle),
          ]),
        ],

        if (map.music != null && map.music!.isNotEmpty) ...[
          const SizedBox(height: 12),
          PropertyCard(title: 'Music', children: [
            Text(map.music!, style: normalStyle),
          ]),
        ],

        if (mapDifficultyToReward[map.difficulty] != null) ...[
          const SizedBox(height: 12),
          PropertyCard(
            title: 'Reward for first completion',
            children: () {
              final entries =
                  mapDifficultyToReward[map.difficulty]!.entries.toList();
              return [
                for (int i = 0; i < entries.length; i++) ...[
                  StatRow(label: entries[i].key, value: entries[i].value),
                  if (i < entries.length - 1) const SizedBox(height: 4),
                ],
              ];
            }(),
          ),
        ],
      ],
    );
  }
}
