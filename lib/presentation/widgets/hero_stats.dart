import 'package:flutter/material.dart';
import '/models/towers/hero.dart';
import '/utilities/constants.dart';

class StatsList extends StatelessWidget {
  final HeroStats heroStats;

  const StatsList({super.key, required this.heroStats});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          itemCount: heroStats.data.length,
          itemBuilder: (BuildContext context, int index) {
            final listData = heroStats.data.values.toList();
            final dynamicItem = listData[index];
            if (dynamicItem is String) {
              if (dynamicItem == 'N/A') {
                return const SizedBox.shrink();
              }
              return ListTile(
                title: Text(
                  heroStats.data.keys.toList()[index],
                  style: normalStyle,
                ),
                subtitle: Text(
                  dynamicItem,
                  style: subtitleStyle,
                ),
              );
            } else {
              return ExpansionTile(
                title:
                    Text(statsDictionary[heroStats.data.keys.toList()[index]]!),
                children: [
                  for (final dynamicItemValue in dynamicItem)
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 40.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (dynamicItemValue is String) ...[
                                ListTile(
                                  title: Text(
                                    dynamicItemValue,
                                    style: normalStyle,
                                  ),
                                ),
                                const SizedBox(height: 20)
                              ] else if (dynamicItemValue is List) ...[
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    primary: false,
                                    itemCount: dynamicItemValue.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final listData = dynamicItemValue;
                                      final dynamicItemValueValue =
                                          listData[index];
                                      return ListTile(
                                        title: Text(
                                          dynamicItemValueValue,
                                          style: subtitleStyle,
                                        ),
                                      );
                                    })
                              ] else ...[
                                Text(dynamicItemValue['name'],
                                    textAlign: TextAlign.center,
                                    style: bolderNormalStyle),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  primary: false,
                                  itemCount: dynamicItemValue['value'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final listData = dynamicItemValue['value'];
                                    final dynamicItemValueValue =
                                        listData[index];
                                    return ListTile(
                                      title: Text(
                                        dynamicItemValueValue,
                                        style: subtitleStyle,
                                      ),
                                    );
                                  },
                                ),
                              ],
                              const SizedBox(height: 20)
                            ]))
                ],
              );
            }
          },
        ));
  }
}
