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
              padding: const EdgeInsets.all(14.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      semanticLabel: tower.name,
                      image: AssetImage(towerImage(tower.image)),
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                    const BetterDivider(),
                    Text(
                      tower.inGameDesc,
                      textAlign: TextAlign.left,
                      style: normalStyle,
                    ),
                    const BetterDivider(),
                    Text(
                      'Class - ${tower.classType}',
                      style: smallTitleStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      costToString(tower.cost),
                      textAlign: TextAlign.center,
                      style: normalStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      statsToString(tower.stats),
                      textAlign: TextAlign.center,
                      style: normalStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      extraStatsToString(tower.stats),
                      textAlign: TextAlign.center,
                      style: normalStyle,
                    ),
                    const BetterDivider(),
                    Center(
                      child: Container(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: tower.paths.paragon != null ? 4 : 3,
                            itemBuilder: (context, index) => Column(
                              children: [
                                _buildPath(index),
                                const BetterDivider(),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ))
          : const CircularProgressIndicator(),
    );
  }
}

class BetterDivider extends StatelessWidget {
  const BetterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 3.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).focusColor),
    );
  }
}
