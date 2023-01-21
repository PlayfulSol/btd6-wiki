import 'package:btd6wiki/utilities/global_state.dart';
import 'package:flutter/material.dart';

import '/presentation/screens/bloon/single_bloon.dart';

import '/models/bloons/boss_bloon.dart';

import '/utilities/images_url.dart';
import '/utilities/requests.dart';

class BossBloonScatter extends StatelessWidget {
  final List<Spawn> scatter;
  final List<String> rounds;

  const BossBloonScatter(
      {super.key, required this.scatter, required this.rounds});

  Widget _buildSpawnList(List<SpawnedBloon> spawns, int roundIndex) {
    return Column(children: [
      Text('Round: ${rounds[roundIndex]}',
          style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 10),
      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 130,
          mainAxisSpacing: 0,
        ),
        primary: false,
        shrinkWrap: true,
        itemCount: spawns.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (!GlobalState.isLoading) {
                getBloonData(spawns[index].bloon)
                    .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleBloon(
                                  bloon: value,
                                ))));
              }
            },
            child: Column(children: [
              Image.network(
                bloonImage(spawns[index].bloon),
                width: 50,
              ),
              const SizedBox(height: 3),
              Text("Count: ${spawns[index].count}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18)),
              if (spawns[index].variant != null) ...[
                const SizedBox(height: 3),
                Text(
                  "Variant: ${spawns[index].variant}",
                  textAlign: TextAlign.center,
                ),
              ]
            ]),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpansionTile(
        title: const Text("Scatter",
            style: TextStyle(fontSize: 28, color: Colors.teal)),
        children: [
          const SizedBox(height: 15),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: scatter.length,
              itemBuilder: (context, index) {
                return _buildSpawnList(scatter[index].scatter, index);
              }),
        ],
      ),
      ExpansionTile(
        title: const Text("Skull",
            style: TextStyle(fontSize: 28, color: Colors.teal)),
        children: [
          const SizedBox(height: 15),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: scatter.length,
              itemBuilder: (context, index) {
                return _buildSpawnList(scatter[index].skull, index);
              }),
        ],
      )
    ]);
  }
}
