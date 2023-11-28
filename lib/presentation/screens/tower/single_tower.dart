import 'package:flutter/material.dart';
import '../../../models/towers/tower/tower.dart';
import '/presentation/widgets/path.dart';
import '/utilities/global_state.dart';
import '/utilities/utils.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class SingleTower extends StatelessWidget {
  final SingleTowerModel towerData;

  const SingleTower({super.key, required this.towerData});

  MonkeyPath _buildPath(int index) {
    var hasParagon = towerData.paths.paragon != null;
    return MonkeyPath(
        path: index == 0
            ? towerData.paths.path1
            : index == 1
                ? towerData.paths.path2
                : index == 2
                    ? towerData.paths.path3
                    : hasParagon
                        ? [towerData.paths.paragon!]
                        : [],
        pathKey: getPathKeyFromIndex(index),
        monkeyId: towerData.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalState.currentTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  semanticLabel: towerData.name,
                  image: AssetImage(towerImage(towerData.image)),
                  width: 200,
                  fit: BoxFit.fill,
                ),
                const BetterDivider(),
                Text(
                  towerData.inGameDesc,
                  textAlign: TextAlign.left,
                  style: normalStyle,
                ),
                const BetterDivider(),
                Text(
                  'Class - ${towerData.type}',
                  style: smallTitleStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  costToString(towerData.cost),
                  textAlign: TextAlign.center,
                  style: normalStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  statsToString(towerData.stats),
                  textAlign: TextAlign.center,
                  style: normalStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  extraStatsToString(towerData.stats),
                  textAlign: TextAlign.center,
                  style: normalStyle,
                ),
                const BetterDivider(),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: towerData.paths.paragon != null ? 4 : 3,
                  itemBuilder: (context, index) => Column(
                    children: [
                      _buildPath(index),
                      const BetterDivider(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
