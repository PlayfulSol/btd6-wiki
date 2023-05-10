import 'package:flutter/material.dart';

import '/models/hero.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

import '/presentation/widgets/hero_level.dart';
import '/presentation/screens/hero/hero_skins.dart';

class SingleHero extends StatelessWidget {
  final SingleHeroModel singleHero;
  final String heroId;

  const SingleHero({super.key, required this.singleHero, required this.heroId});

  HeroLevel _buildHeroLevel(BuildContext context, Levels level) {
    var shouldShowLevelImage = false;
    // get last charecter from level name and parse to int
    var levelNumber = int.parse(level.name.substring(level.name.length - 1));
    if (singleHero.skinChange.contains(levelNumber)) {
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
                  Image.network(heroBaseImage(heroId), width: 200),
                  const SizedBox(height: 10),
                  Text(singleHero.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(costToString(singleHero.cost)),
                  const SizedBox(height: 10),
                  Text("Level Speed: ${singleHero.levelSpeed}"),
                  const SizedBox(height: 10),
                  Text(statsToString(singleHero.stats),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  // if has skins, render a button that will take to a new page that shows the skins
                  if (singleHero.skins.isNotEmpty)
                    ElevatedButton(
                      child: const Text("Skins"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeroSkins(
                            heroId: heroId,
                            heroSkins: singleHero.skins,
                            skinChange: singleHero.skinChange,
                            heroName: singleHero.name,
                          ),
                        ),
                      ),
                    ),
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
