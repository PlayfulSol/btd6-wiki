import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/maps/map.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

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
    var jsonData = json.decode(data);
    map = MapModel.fromJson(jsonData);
    setState(() {
      loading = false;
    });
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

  Widget getImageWidget(String mapName) {
    try {
      return Image(
        semanticLabel: mapName,
        image: AssetImage(mapImage(mapName)),
        height: 200,
      );
    } catch (e) {
      return Image(
        semanticLabel: mapName,
        image: const AssetImage('assets/images/placeholder.png'),
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !loading
          ? AppBar(
              title: Text(map.name),
              actions: [
                Consumer<FavoriteState>(
                  builder: (context, favoriteState, child) {
                    return IconButton(
                      onPressed: () => favoriteState.toggleFavoriteFunc(
                          context, favoriteState, map),
                      icon: favoriteState.isFavorite(map.type, map.id)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined),
                    );
                  },
                ),
              ],
            )
          : AppBar(),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 300,
                      maxHeight: 400,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Image(
                          semanticLabel: map.name,
                          image: AssetImage(mapImage(map.image)),
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Center(
                              child: Image.asset(
                                "assets/images/placeholder.png",
                                width: 90,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          map.name,
                          style: bigTitleStyle,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            map.difficulty,
                            style: smallTitleStyle.copyWith(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPropertyCard(
                          context,
                          'Map Properties',
                          [
                            _buildPropertyRow('Terrain', map.terrain ?? 'N/A'),
                            _buildPropertyRow('Water', map.water ?? 'N/A'),
                            _buildPropertyRow('Entrances', map.entrances ?? 'N/A'),
                            _buildPropertyRow('Exits', map.exits ?? 'N/A'),
                            _buildPropertyRow(
                                'Removable Objects', map.removableObject ?? 'N/A'),
                            _buildPropertyRow('Highground', map.highground ?? 'N/A'),
                            _buildPropertyRow(
                                'Sight Blocker', map.sightBlocker ?? 'N/A'),
                          ],
                        ),
                        if (map.music != null && map.music!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildPropertyCard(
                            context,
                            'Music',
                            [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  map.music!,
                                  style: normalStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (mapDifficultyToReward[map.difficulty] != null) ...[
                          const SizedBox(height: 16),
                          _buildPropertyCard(
                            context,
                            'Reward for first completion',
                            List.generate(
                              mapDifficultyToReward[map.difficulty]!.length,
                              (index) {
                                final rewards =
                                    mapDifficultyToReward[map.difficulty];
                                final rewardKeys = rewards?.keys.toList() ?? [];
                                final rewardValues =
                                    rewards?.values.toList() ?? [];
                                return _buildPropertyRow(
                                  rewardKeys[index],
                                  rewardValues[index],
                                );
                              },
                            ),
                          ),
                        ],
                        if (map.length != null && map.length!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildPropertyCard(
                            context,
                            'Length',
                            [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  map.length!,
                                  style: normalStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPropertyCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: bolderNormalStyle.copyWith(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: normalStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
