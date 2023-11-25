import 'package:flutter/material.dart';
import '/models/towers/hero.dart';
import '/utilities/images_url.dart';

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
        if (level.name != '1') ...[
          Text(
            "Cost: ${level.cost}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 30),
        ],
      ],
    );
  }
}
