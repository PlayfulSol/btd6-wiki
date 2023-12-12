import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/towers/common/upgrade_info_class.dart';
import '/models/towers/hero/hero.dart';
import '/presentation/widgets/hero_stats.dart';
import '/presentation/widgets/hero_level.dart';
import '/analytics/analytics_constants.dart';
import '/utilities/images_url.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class SingleHero extends StatefulWidget {
  final String heroId;

  const SingleHero({super.key, required this.heroId});

  @override
  State<SingleHero> createState() => _SingleHeroState();
}

class _SingleHeroState extends State<SingleHero> {
  late final HeroModel singleHero;
  bool loading = true;

  HeroLevel _buildHeroLevel(UpgradeInfo level) {
    var shouldShowLevelImage = false;
    if (singleHero.skinChange.keys.contains('level_${level.name}') ||
        singleHero.skinChange.keys
            .any((e) => e.contains('level_${level.name}_'))) {
      shouldShowLevelImage = true;
    }
    return HeroLevel(
      heroId: widget.heroId,
      level: level,
      shouldShowLevelImage: shouldShowLevelImage,
      heroImage: singleHero.image,
      heroName: singleHero.name,
    );
  }

  void loadHero() async {
    var path = '${heroDataPath + widget.heroId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    singleHero = HeroModel.fromJson(jsonData);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHero();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!loading ? singleHero.name : ''),
      ),
      body: !loading
          ? SingleChildScrollView(
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
                      Text(singleHero.inGameDesc,
                          textAlign: TextAlign.center, style: normalStyle),
                      const SizedBox(height: 10),
                      Text(costToString(singleHero.cost),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ExpansionTile(
                        title: const Text("Advanced Stats"),
                        onExpansionChanged: (value) {
                          logEvent(heroConst, 'Stats');
                        },
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
                          singleHero.levels[index],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
