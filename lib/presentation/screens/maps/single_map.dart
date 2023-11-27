import 'package:flutter/material.dart';
import '/models/maps/map.dart';
import '/utilities/constants.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class SingleMap extends StatelessWidget {
  final MapModel map;

  const SingleMap({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GlobalState.currentTitle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                    semanticLabel: map.name,
                    image: AssetImage(mapImage(map.image)),
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  Text(map.name,
                      textAlign: TextAlign.center, style: bigTitleStyle),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[600],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text("Difficulty:", style: titleStyle),
                      const SizedBox(height: 5),
                      Text(map.difficulty, style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Entrances:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.entrances ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Exits:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.exits ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Terrain:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.terrain ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Water:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.water ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Removable Objects:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.removableObject ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Highground:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.highground ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Sight Blocker:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.sightBlocker ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text(
                        'Music:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.music ?? '', style: normalStyle),
                      const SizedBox(height: 15),
                      const Text('Reward for first completion:',
                          style: titleStyle),
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            mapDifficultyToReward[map.difficulty]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final rewards = mapDifficultyToReward[map.difficulty];
                          final rewardKeys = rewards?.keys.toList() ?? [];
                          final rewardValues = rewards?.values.toList() ?? [];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    rewardKeys[index],
                                    style: normalStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    rewardValues[index],
                                    style: normalStyle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Length:',
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(map.length ?? '', style: normalStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
