import 'package:flutter/material.dart';
import '/models/towers/hero.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';

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
          style: titleStyle.copyWith(color: Colors.teal)),
      onExpansionChanged: (value) {
        logEvent(heroConst, 'expand_level_${level.name}');
      },
      children: [
        const SizedBox(height: 15),
        shouldShowLevelImage
            ? Column(
                children: [
                  Image(
                    semanticLabel: singleHero.name,
                    image:
                        AssetImage(heroLvlImage(singleHero.image, level.name)),
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 15),
                ],
              )
            : const SizedBox.shrink(),
        Text(level.description,
            textAlign: TextAlign.center, style: normalStyle),
        const SizedBox(height: 10),
        if (level.name != '1') ...[
          Text(
            "Cost: ${level.cost}",
            textAlign: TextAlign.center,
            style: normalStyle,
          ),
          const SizedBox(height: 30),
        ],
      ],
    );
  }
}
