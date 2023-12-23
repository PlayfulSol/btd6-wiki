import 'dart:convert';
import 'package:btd6wiki/analytics/analytics_constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/bloons/boss/minion_bloon.dart';
import '/presentation/widgets/bloon_aid_widget.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class MinionBloonPage extends StatefulWidget {
  const MinionBloonPage({
    super.key,
    required this.analyticsHelper,
    required this.minionId,
  });
  final AnalyticsHelper analyticsHelper;
  final String minionId;
  @override
  State<MinionBloonPage> createState() => _MinionBloonPageState();
}

class _MinionBloonPageState extends State<MinionBloonPage> {
  final controller = CarouselController();
  late final MinionBloon minion;
  List<String> images = [];
  List<String> imageKeys = [];
  bool loading = true;
  int activeIndex = 0;

  void loadMinion() async {
    var path = '${minionsDataPath + widget.minionId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    minion = MinionBloon.fromJson(jsonData);
    setState(() {
      loading = false;
      images = List.from(minion.images.values);
      imageKeys = List.from(minion.images.keys);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kBossPagesClass,
      screenName: widget.minionId,
    );
    loadMinion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!loading ? minion.name : ''),
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                              viewportFraction: 0.62,
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
                            itemBuilder: ((context, index, realIndex) {
                              return Image(
                                image: AssetImage(minionImage(images[index])),
                                filterQuality: FilterQuality.high,
                                width: MediaQuery.of(context).size.width * 0.56,
                                semanticLabel:
                                    bossImageLabels[imageKeys[index]],
                              );
                            }),
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
                          onDotClicked: (index) => controller.jumpToPage(index),
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
                      minion.name,
                      style: bigTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Speed",
                      style: bigTitleStyle,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Absolute: ${minion.speed.absolute}",
                          style: normalStyle,
                        ),
                        Text(
                          "Relative (to red bloon): ${minion.speed.relative}",
                          style: normalStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Health",
                      style: bigTitleStyle,
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Normal",
                          style: smallTitleStyle,
                        ),
                        Text(
                          "Elite",
                          style: smallTitleStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: minion.health["normal"].length,
                            itemBuilder: ((context, index) {
                              String health = minion.health["normal"][index];
                              List<String> parts = health.split(", ");
                              return ListTile(
                                dense: true,
                                title: Text(
                                  parts.length > 1 ? parts[0] : health,
                                  style: normalStyle,
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: parts.length > 1
                                    ? Text(
                                        parts[1],
                                        textAlign: TextAlign.center,
                                        style: normalStyle,
                                      )
                                    : null,
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: minion.health["elite"].length,
                            itemBuilder: ((context, index) {
                              String health = minion.health["elite"][index];
                              List<String> parts = health.split(", ");
                              return ListTile(
                                dense: true,
                                title: Text(
                                  parts.length > 1 ? parts[0] : health,
                                  style: normalStyle,
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: parts.length > 1
                                    ? Text(
                                        parts[1],
                                        textAlign: TextAlign.center,
                                        style: normalStyle,
                                      )
                                    : null,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
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
                      minion.id,
                      "General Properties",
                      List<String>.from(minion.gimmicks["general"]),
                      true,
                    ),
                    gimmicks(
                      widget.analyticsHelper,
                      minion.id,
                      "Normal Gimmicks",
                      List<String>.from(minion.gimmicks["normal"]),
                      false,
                    ),
                    gimmicks(
                      widget.analyticsHelper,
                      minion.id,
                      "Elite Gimmicks",
                      List<String>.from(minion.gimmicks["elite"]),
                      false,
                    ),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
