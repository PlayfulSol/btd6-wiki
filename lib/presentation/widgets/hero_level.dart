import 'package:flutter/material.dart';
import '/models/towers/common/upgrade_info_class.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class HeroLevel extends StatelessWidget {
  final String heroImage;
  final String heroName;
  final String heroId;
  final UpgradeInfo level;
  final bool shouldShowLevelImage;

  const HeroLevel(
      {super.key,
      required this.heroId,
      required this.level,
      required this.shouldShowLevelImage,
      required this.heroImage,
      required this.heroName});

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
                    semanticLabel: heroName,
                    image: AssetImage(heroLvlImage(heroImage, level.name)),
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 15),
                ],
              )
            : const SizedBox.shrink(),
        Text(level.upgradeBody,
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
