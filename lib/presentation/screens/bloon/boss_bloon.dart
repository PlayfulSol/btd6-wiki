import 'package:btd6wiki/presentation/widgets/bloon_aid_widget.dart';
import 'package:btd6wiki/utilities/constants.dart';
import 'package:flutter/material.dart';

import '/models/bloons/boss_bloon.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class BossBloon extends StatefulWidget {
  final BossBloonModel bloon;

  const BossBloon({super.key, required this.bloon});

  @override
  State<BossBloon> createState() => _BossBloonState();
}

class _BossBloonState extends State<BossBloon> {
  final controller = CarouselController();
  List<String> images = [];
  List<String> imageKeys = [];

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.bloon.images.values);
    imageKeys = List.from(widget.bloon.images.keys);
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
                          itemBuilder: ((context, index, realIndex) => Image(
                                image: AssetImage(bossImage(images[index])),
                                filterQuality: FilterQuality.high,
                                width: MediaQuery.of(context).size.width * 0.56,
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
                    widget.bloon.name,
                    style: bigTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.bloon.description.trimLeft(),
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
                        "Normal: ${widget.bloon.skullCount['normal']}",
                        style: normalStyle,
                      ),
                      Text(
                        "Elite: ${widget.bloon.skullCount['elite']}",
                        style: normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Health",
                    style: titleStyle,
                  ),
                  Text(
                    "Each additional player adds 20%",
                    style: normalStyle.copyWith(fontSize: 13),
                  ),
                  bossHealth("Normal", widget.bloon.health.base),
                  bossHealth("Elite", widget.bloon.health.elite),
                  const SizedBox(height: 10),
                  generateMinion(widget.bloon.children, context),
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
                    "General Properties",
                    List<String>.from(widget.bloon.gimmicks["general"]),
                    true,
                  ),
                  gimmicks(
                    "Normal Gimmicks",
                    List<String>.from(widget.bloon.gimmicks["normal"]),
                    false,
                  ),
                  gimmicks(
                    "Elite Gimmicks",
                    List<String>.from(widget.bloon.gimmicks["elite"]),
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
                    children: widget.bloon.immunities
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
        ));
  }

  ExpansionTile bossHealth(String title, List<TierHealth> healthTiers) {
    return ExpansionTile(
      title: Text(
        title,
        style: smallTitleStyle.copyWith(color: Colors.teal),
      ),
      children: healthTiers
          .map(
            (tierHealth) => ListTile(
              isThreeLine: true,
              title: Text(
                "Tier ${tierHealth.tier}:",
                style: normalStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "1 Palyer: ${tierHealth.normal}, 2 Palyers: ${tierHealth.coop2}"
                "\n3 Palyers: ${tierHealth.coop3}, 4 Palyers: ${tierHealth.coop4}",
                style: normalStyle.copyWith(color: Colors.white),
              ),
            ),
          )
          .toList(),
    );
  }
}
