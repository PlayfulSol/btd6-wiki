import 'dart:convert';
import 'package:btd6wiki/utilities/favorite_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/towers/common/upgrade_info_class.dart';
import '/models/towers/hero/hero.dart';
import '../../widgets/heroes/hero_stats.dart';
import '../../widgets/heroes/hero_level.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import 'hero_skins.dart';

class SingleHero extends StatefulWidget {
  final AnalyticsHelper analyticsHelper;
  final String heroId;

  const SingleHero({
    super.key,
    required this.heroId,
    required this.analyticsHelper,
  });

  @override
  State<SingleHero> createState() => _SingleHeroState();
}

class _SingleHeroState extends State<SingleHero> {
  late final HeroModel singleHero;
  final controller = CarouselController();
  List<String> skinsFirstImages = [];
  List<String> skinsNames = [];
  int activeIndex = 0;
  bool loading = true;

  HeroLevel _buildHeroLevel(UpgradeInfo level) {
    List<String> lvlSkinsImages = [];
    bool shouldShowLevelImage = false;

    if (singleHero.skinChange.contains(level.name)) {
      shouldShowLevelImage = true;
      var skinNamesAndImages = getSkinNamesAndImages(level.name);
      lvlSkinsImages = skinNamesAndImages[1];
    }
    return HeroLevel(
      heroId: widget.heroId,
      level: level,
      shouldShowLevelImage: shouldShowLevelImage,
      heroImages: lvlSkinsImages,
      heroName: singleHero.name,
      analyticsHelper: widget.analyticsHelper,
    );
  }

  List<List<String>> getSkinNamesAndImages(String lvl) {
    List<String> names = [];
    List<String> images = [];
    for (var skin in singleHero.skins) {
      int lvlIndex =
          skin.value.indexWhere((image) => image.contains('$lvl.png'));
      if (lvlIndex != -1) {
        names.add(skin.name);
        images.add(skin.value[lvlIndex]);
      } else if (lvl == '1') {
        names.add(skin.name);
        images.add(skin.value[0]);
      }
    }
    return [names, images];
  }

  void loadHero() async {
    var path = '${heroDataPath + widget.heroId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    singleHero = HeroModel.fromJson(jsonData);
    setState(() {
      loading = false;
      var skinNamesAndImages = getSkinNamesAndImages("1");
      skinsNames = skinNamesAndImages[0];
      skinsFirstImages = skinNamesAndImages[1];
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kTowerPagesClass,
      screenName: widget.heroId,
    );
    loadHero();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !loading
          ? AppBar(
              title: Text(singleHero.name),
              actions: [
                Consumer<FavoriteState>(
                  builder: (context, favoriteState, child) {
                    return IconButton(
                      onPressed: () => favoriteState.toggleFavoriteFunc(
                          context, favoriteState, singleHero),
                      icon: favoriteState.isFavorite(
                              singleHero.type, singleHero.id)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined),
                    );
                  },
                ),
              ],
            )
          : AppBar(),
      body: !loading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: controller,
                            options: CarouselOptions(
                              viewportFraction: 0.64,
                              initialPage: 0,
                              height: MediaQuery.of(context).size.width * 0.5,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                            ),
                            itemCount: singleHero.skins.length,
                            itemBuilder: ((context, index, realIndex) => Image(
                                  image: AssetImage(
                                      heroImage(skinsFirstImages[index])),
                                  filterQuality: FilterQuality.high,
                                  width:
                                      MediaQuery.of(context).size.width * 0.56,
                                )),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            skinsNames[activeIndex],
                            style: smallTitleStyle,
                          ),
                          const SizedBox(height: 10),
                          AnimatedSmoothIndicator(
                            activeIndex: activeIndex,
                            count: singleHero.skins.length,
                            onDotClicked: (index) =>
                                controller.jumpToPage(index),
                            effect: const ScrollingDotsEffect(
                              activeDotScale: 1.25,
                              spacing: 11,
                              dotHeight: 9,
                              dotWidth: 9,
                              activeDotColor: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(singleHero.inGameDesc,
                          textAlign: TextAlign.center, style: normalStyle),
                      const SizedBox(height: 10),
                      Text(costToString(singleHero.cost),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ExpansionTile(
                        title: Text(
                          "Advanced Stats",
                          style: titleStyle.copyWith(color: Colors.teal),
                        ),
                        onExpansionChanged: (bool value) {
                          widget.analyticsHelper.logEvent(
                            name: widgetEngagement,
                            parameters: {
                              'screen': singleHero.id,
                              'widget': expansionTile,
                              'value': 'hero_stats_$value',
                            },
                          );
                        },
                        children: [
                          StatsList(
                            heroId: singleHero.id,
                            heroStats: singleHero.stats,
                            analyticsHelper: widget.analyticsHelper,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (singleHero.skins.isNotEmpty)
                        ElevatedButton(
                          child: const Text("Skins"),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeroSkins(
                                heroId: singleHero.id,
                                heroSkins: singleHero.skins,
                                heroName: singleHero.name,
                                analyticsHelper: widget.analyticsHelper,
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
