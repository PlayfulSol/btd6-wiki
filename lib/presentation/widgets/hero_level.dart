import 'package:flutter/material.dart';

import '/models/hero.dart';

import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class HeroLevel extends StatelessWidget {
  final HeroModel singleHero;
  final String heroId;
  final Levels level;
  final bool shouldShowLevelImage;

  const HeroLevel(
      {super.key,
      required this.singleHero,
      required this.heroId,
      required this.level,
      required this.shouldShowLevelImage});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Level ${level.name}",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
      children: [
        const SizedBox(height: 15),
        shouldShowLevelImage
            ? Image(
                image: AssetImage(heroLvlImage(singleHero.image, level.name)),
                width: 200,
                fit: BoxFit.fill,
              )
            : const SizedBox.shrink(),
        Text(level.description,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 10),
        Text(
          "XP needed: ${level.unlock}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 15),
        const Text("Rounds:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        // Text(roundsToString(level.rounds)),
        Text(level.cost),
        const SizedBox(height: 30),

        // const Text("Effects:",
        //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        // const SizedBox(height: 10),
        // ListView.builder(
        //     shrinkWrap: true,
        //     primary: false,
        //     itemCount: level.effects.length,
        //     itemBuilder: (context, effectIndex) => Column(
        //           children: [
        //             Text(
        //               level.effects[effectIndex],
        //               textAlign: TextAlign.center,
        //             ),
        //             const SizedBox(height: 10),
        //           ],
        //         )),
        const SizedBox(height: 30),
      ],
    );
  }
}
