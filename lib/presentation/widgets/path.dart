import 'package:flutter/material.dart';
import '/models/towers/tower.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import '/utilities/images_url.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';

class MonkeyPath extends StatelessWidget {
  final List<MonkeyPathModel> path;
  final String pathKey;
  final String monkeyId;

  const MonkeyPath(
      {super.key,
      required this.path,
      required this.pathKey,
      required this.monkeyId});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(pathsDictionary[pathKey]!,
          style: titleStyle.copyWith(color: Colors.teal)),
      onExpansionChanged: (value) {
        logEvent(
            towerConst, 'tower_${monkeyId}_path_${pathsDictionary[pathKey]}');
      },
      children: [
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: path.length,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  semanticLabel: path[index].name,
                  image: AssetImage(
                    towerImage(path[index].image),
                  ),
                  width: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  path[index].name,
                  style: smallTitleStyle,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                path[index].upgradeBody,
                style: normalStyle,
              ),
              const SizedBox(height: 10),
              const Text("Cost:", style: normalStyle),
              Text(costToString(path[index].cost), style: normalStyle),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
