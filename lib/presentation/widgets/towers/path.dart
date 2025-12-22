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
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          pathsDictionary[pathKey]!,
          style: titleStyle.copyWith(color: Colors.teal),
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: path.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      semanticLabel: path[index].name,
                      image: AssetImage(
                        towerImage(path[index].image),
                      ),
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            path[index].name,
                            style: smallTitleStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            path[index].upgradeBody,
                            style: normalStyle,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Cost: ${costToString(path[index].cost)}',
                            style: normalStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
