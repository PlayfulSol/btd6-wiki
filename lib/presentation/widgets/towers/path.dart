import 'package:flutter/material.dart';
import '/models/towers/common/upgrade_info_class.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class MonkeyPath extends StatelessWidget {
  final List<UpgradeInfo> path;
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
    return ExpansionTile(
      title: Text(pathsDictionary[pathKey]!,
          style: titleStyle.copyWith(color: Colors.teal)),
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
          padding: const EdgeInsets.symmetric(horizontal: 5),
          itemCount: path.length,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
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
            ],
          ),
        ),
      ],
    );
  }
}
