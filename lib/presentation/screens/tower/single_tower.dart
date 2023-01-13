import 'package:flutter/material.dart';

import '/models/tower.dart';

import '/utilities/global_state.dart';
import '/utilities/utils.dart';
import '/utilities/images_url.dart';
import '/utilities/themes.dart';

import '/presentation/widgets/path.dart';

class SingleTower extends StatelessWidget {
  final String towerId;
  final SingleTowerModel towerData;

  const SingleTower(
      {super.key, required this.towerId, required this.towerData});

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
        monkeyId: towerId);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: GlobalState.currentTheme == Themes.darkTheme
            ? Themes.darkTheme
            : Themes.lightTheme,
        child: Scaffold(
          appBar: AppBar(
            title: Text(GlobalState.currentTitle),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(towerBaseImage(towerId), width: 200),
                    const SizedBox(height: 10),
                    Text(towerData.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(towerData.type),
                    const SizedBox(height: 10),
                    Text(costToString(towerData.cost)),
                    const SizedBox(height: 10),
                    Text(statsToString(towerData.stats)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: towerData.paths.paragon != null ? 4 : 3,
                      itemBuilder: (context, index) => _buildPath(index),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
