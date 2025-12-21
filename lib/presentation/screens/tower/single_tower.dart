import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/towers/tower/tower.dart';
import '/presentation/widgets/towers/path.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

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
  late TowerModel tower;
  bool loading = true;

  MonkeyPath _buildPath(int index) {
    var hasParagon = tower.paths.paragon != null;
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
    var path = '${towerDataPath + widget.towerId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    tower = TowerModel.fromJson(jsonData);
    setState(() {
      loading = false;
    });
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
    return Scaffold(
      appBar: !loading
          ? AppBar(
              title: Text(tower.name),
              actions: [
                Consumer<FavoriteState>(
                  builder: (context, favoriteState, child) {
                    return IconButton(
                      onPressed: () => favoriteState.toggleFavoriteFunc(
                          context, favoriteState, tower),
                      icon: favoriteState.isFavorite(tower.type, tower.id)
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              semanticLabel: tower.name,
                              image: AssetImage(towerImage(tower.image)),
                              width: 140,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tower.name,
                                    style: bigTitleStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Class: ${tower.classType}',
                                    style: smallTitleStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tower.inGameDesc,
                                    style: normalStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Stats',
                                    style: smallTitleStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    statsToString(tower.stats),
                                    style: normalStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  if (extraStatsToString(tower.stats)
                                      .trim()
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      extraStatsToString(tower.stats),
                                      style: normalStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cost',
                                    style: smallTitleStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    costToString(tower.cost),
                                    style: normalStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: tower.paths.paragon != null ? 4 : 3,
                      itemBuilder: (context, index) => _buildPath(index),
                    )
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
