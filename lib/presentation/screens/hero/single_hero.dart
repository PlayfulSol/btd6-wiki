import 'package:flutter/material.dart';
import '/presentation/widgets/hero_stats.dart';
import '/presentation/widgets/hero_level.dart';
import '/models/towers/hero.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class SingleHero extends StatelessWidget {
  final HeroModel singleHero;
  final String heroId;

  const SingleHero({super.key, required this.singleHero, required this.heroId});

  HeroLevel _buildHeroLevel(BuildContext context, Levels level) {
    var shouldShowLevelImage = false;
    if (singleHero.skinChange.keys.contains('level_${level.name}') ||
        singleHero.skinChange.keys
            .any((e) => e.contains('level_${level.name}_'))) {
      shouldShowLevelImage = true;
    }
    return HeroLevel(
      singleHero: singleHero,
      heroId: heroId,
      level: level,
      shouldShowLevelImage: shouldShowLevelImage,
    );
  }

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
                  Image(
                    image: AssetImage(heroImage(singleHero.image)),
                    width: 200,
                    fit: BoxFit.fill,
                    semanticLabel: singleHero.name,
                  ),
                  const SizedBox(height: 10),
                  Text(singleHero.inGameDesc ?? "No description found",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(costToString(singleHero.cost),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text("Advanced Stats"),
                    children: [
                      StatsList(heroStats: singleHero.stats),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // if has skins, render a button that will take to a new page that shows the skins
                  // if (singleHero.skins.isNotEmpty)
                  //   ElevatedButton(
                  //     child: const Text("Skins"),
                  //     onPressed: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => HeroSkins(
                  //           heroId: heroId,
                  //           heroSkins: singleHero.skins,
                  //           skinChange: singleHero.skinChange,
                  //           heroName: singleHero.name,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  const SizedBox(height: 10),
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: singleHero.levels.length,
                      itemBuilder: (context, index) => _buildHeroLevel(
                            context,
                            singleHero.levels[index],
                          )),
                ],
              ),
            ),
          ),
        ));
  }
}
