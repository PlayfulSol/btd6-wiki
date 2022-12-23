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
    return GridView.builder(
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
            getBloonData(spawns[index].bloon).then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleBloon(
                          bloon: value,
                        ))));
          },
          child: Column(children: [
            Image.network(
              bloonImage(spawns[index].bloon),
              width: 50,
            ),
            const SizedBox(height: 3),
            Text('Round: ${rounds[roundIndex]}'),
            const SizedBox(height: 3),
            Text("Count: ${spawns[index].count}"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Scatter", style: TextStyle(fontSize: 18)),
      const SizedBox(height: 5),
      ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: scatter.length,
          itemBuilder: (context, index) {
            return _buildSpawnList(scatter[index].scatter, index);
          }),
      const Text("Skull", style: TextStyle(fontSize: 18)),
      const SizedBox(height: 5),
      ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: scatter.length,
          itemBuilder: (context, index) {
            return _buildSpawnList(scatter[index].skull, index);
          }),
    ]);
  }
}
