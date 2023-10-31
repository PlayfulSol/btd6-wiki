import 'package:flutter/material.dart';

import '/presentation/widgets/boss_bloon_scatter.dart';

import '/models/bloons/boss_bloon.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class BossBloon extends StatelessWidget {
  final BossBloonModel bloon;

  const BossBloon({super.key, required this.bloon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Image.network(bossImage(bloon.id), width: 200),
                  const SizedBox(height: 10),
                  Text("Speed: ${bloon.speed}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Type: ${bloon.type}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 15),
                  Text("Immunities: ${bloon.immunities.join(", ")}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 15),
                  const Text("RBE (Red Bloon Equivalent):",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text("Base:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(bossRbeToString(bloon.rbe.base, bloon.rounds)),
                  const SizedBox(height: 10),
                  const Text("Elite:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(bossRbeToString(bloon.rbe.elite, bloon.rounds)),
                  const SizedBox(height: 10),
                  const Text("Base spawned Bloons:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  BossBloonScatter(
                      scatter: bloon.spawns.base, rounds: bloon.rounds),
                  const SizedBox(height: 15),
                  const Text("Elite spawned Bloons:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  BossBloonScatter(
                      scatter: bloon.spawns.elite, rounds: bloon.rounds),
                ],
              ),
            ),
          ),
        ));
  }
}
