import 'package:btd6wiki/models/hero.dart';
import 'package:flutter/material.dart';

class StatsList extends StatelessWidget {
  final HeroStats heroStats;

  const StatsList({Key? key, required this.heroStats}) : super(key: key);

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
            if (dynamicItem[0] is String) {
              if (dynamicItem[0] == 'N/A') {
                return const SizedBox.shrink();
              }
              return ExpansionTile(
                title: Text(heroStats.data.keys.toList()[index]),
                children: [
                  for (final dynamicItemValue in dynamicItem)
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: ListTile(
                          title: Text(dynamicItemValue),
                        ))
                ],
              );
            } else {
              return ExpansionTile(
                title: Text(heroStats.data.keys.toList()[index]),
                children: [
                  for (final dynamicItemValue in dynamicItem)
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 40.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(dynamicItemValue['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                itemCount: dynamicItemValue['value'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final listData = dynamicItemValue['value'];
                                  final dynamicItemValueValue = listData[index];
                                  return ListTile(
                                    title: Text(
                                      dynamicItemValueValue,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20)
                            ]))
                ],
              );
            }
          },
        ));
  }
}
