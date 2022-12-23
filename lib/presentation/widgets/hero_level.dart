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
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Text("Level ${level.level}",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal)),
              const SizedBox(height: 15),
              shouldShowLevelImage
                  ? Image.network(heroLevelImage(heroId, level.level),
                      width: 200)
                  : const SizedBox.shrink(),
              Text(level.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
              Text(
                "XP needed: ${level.xp.toString()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 15),
              const Text(
                "Effects:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(level.effects.join(", "), textAlign: TextAlign.center),
              const SizedBox(height: 15),
              const Text("Rounds:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text(roundsToString(level.rounds)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
