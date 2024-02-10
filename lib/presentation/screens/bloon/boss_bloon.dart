import 'dart:convert';
import 'package:btd6wiki/utilities/favorite_state.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/bloons/boss/boss_health_class.dart';
import '/models/bloons/boss/boss_bloon.dart';
import '../../widgets/bloons/bloon_aid_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class BossBloon extends StatefulWidget {
  const BossBloon({
    super.key,
    required this.analyticsHelper,
    required this.bossId,
  });

  final AnalyticsHelper analyticsHelper;
  final String bossId;

  @override
  State<BossBloon> createState() => _BossBloonState();
}

class _BossBloonState extends State<BossBloon> {
  final controller = CarouselController();
  late final BossBloonModel boss;
  List<String> images = [];
  List<String> imageKeys = [];
  bool loading = true;
  int activeIndex = 0;

  void loadBoss() async {
    var path = '${bossesDataPath + widget.bossId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    boss = BossBloonModel.fromJson(jsonData);
    setState(() {
      loading = false;
      images = List.from(boss.images.values);
      imageKeys = List.from(boss.images.keys);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kBossPagesClass,
      screenName: widget.bossId,
    );
    loadBoss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !loading
          ? AppBar(
              title: Text(boss.name),
              actions: [
                Consumer<FavoriteState>(
                  builder: (context, favoriteState, child) {
                    return IconButton(
                      onPressed: () {
                        String msg = favoriteState.toggleFavorite(boss);
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: Text(msg)),
                            duration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      icon: favoriteState.isFavorite(boss.type, boss.id)
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: CarouselSlider.builder(
                              carouselController: controller,
                              options: CarouselOptions(
                                viewportFraction: 0.7,
                                initialPage: 0,
                                height: MediaQuery.of(context).size.width * 0.5,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                },
                              ),
                              itemCount: images.length,
                              itemBuilder: ((context, index, realIndex) =>
                                  Image(
                                    image: AssetImage(bossImage(images[index])),
                                    filterQuality: FilterQuality.high,
                                    width: MediaQuery.of(context).size.width *
                                        0.56,
                                    semanticLabel:
                                        bossImageLabels[imageKeys[index]],
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            bossImageLabels[imageKeys[activeIndex]]!,
                            style: smallTitleStyle,
                          ),
                          const SizedBox(height: 10),
                          AnimatedSmoothIndicator(
                            activeIndex: activeIndex,
                            count: images.length,
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
                      Text(
                        boss.name,
                        style: bigTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        boss.description.trimLeft(),
                        style: normalStyle,
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Skulls",
                        style: titleStyle,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Normal: ${boss.skullCount['normal']}",
                            style: normalStyle,
                          ),
                          Text(
                            "Elite: ${boss.skullCount['elite']}",
                            style: normalStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Health",
                        style: titleStyle,
                      ),
                      const Text(
                        "Each additional player adds 20%",
                        style: subtitleStyle,
                      ),
                      bossHealth("Normal", boss.health.base),
                      bossHealth("Elite", boss.health.elite),
                      const SizedBox(height: 10),
                      generateMinion(
                          boss.children, context, widget.analyticsHelper),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Properties and Gimmicks",
                        style: titleStyle,
                      ),
                      const SizedBox(height: 5),
                      gimmicks(
                        widget.analyticsHelper,
                        boss.id,
                        "General Properties",
                        List<String>.from(boss.gimmicks["general"]),
                        true,
                      ),
                      gimmicks(
                        widget.analyticsHelper,
                        boss.id,
                        "Normal Gimmicks",
                        List<String>.from(boss.gimmicks["normal"]),
                        false,
                      ),
                      gimmicks(
                        widget.analyticsHelper,
                        boss.id,
                        "Elite Gimmicks",
                        List<String>.from(boss.gimmicks["elite"]),
                        false,
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 2,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 10),
                      ExpansionTile(
                        title: Text(
                          "General Immunities",
                          style: smallTitleStyle.copyWith(color: Colors.teal),
                        ),
                        onExpansionChanged: (bool value) {
                          widget.analyticsHelper.logEvent(
                            name: widgetEngagement,
                            parameters: {
                              'screen': boss.id,
                              'widget': expansionTile,
                              'value': 'general_immunities_$value',
                            },
                          );
                        },
                        children: boss.immunities
                            .map<Widget>(
                              (item) => ListTile(
                                title: Text("- $item", style: normalStyle),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  ExpansionTile bossHealth(String title, List<TierHealth> healthTiers) {
    return ExpansionTile(
      title: Text(
        title,
        style: smallTitleStyle.copyWith(color: Colors.teal),
      ),
      onExpansionChanged: (bool value) {
        widget.analyticsHelper.logEvent(
          name: widgetEngagement,
          parameters: {
            'screen': boss.id,
            'widget': expansionTile,
            'value': 'health_${title}_$value',
          },
        );
      },
      children: healthTiers
          .map(
            (tierHealth) => ListTile(
              isThreeLine: true,
              title: Text(
                "Tier ${tierHealth.tier}:",
                style: normalStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "1 Player: ${tierHealth.normal}, 2 Players: ${tierHealth.coop2}"
                "\n3 Players: ${tierHealth.coop3}, 4 Players: ${tierHealth.coop4}",
                style: normalStyle.copyWith(color: Colors.white),
              ),
            ),
          )
          .toList(),
    );
  }
}
