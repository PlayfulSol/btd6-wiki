import 'package:btd6wiki/utilities/constants.dart';
import 'package:flutter/material.dart';

import '/models/bloons/boss_bloon.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class BossBloon extends StatefulWidget {
  final BossBloonModel bloon;

  const BossBloon({super.key, required this.bloon});

  @override
  State<BossBloon> createState() => _BossBloonState();
}

class _BossBloonState extends State<BossBloon> {
  final controller = CarouselController();
  List<String> images = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.bloon.images.values);
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
                      CarouselSlider.builder(
                        carouselController: controller,
                        options: CarouselOptions(
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
                            )),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSmoothIndicator(
                        activeIndex: activeIndex,
                        count: images.length,
                        onDotClicked: (index) => controller.jumpToPage(index),
                        effect: const ScrollingDotsEffect(
                            activeDotColor: Colors.teal),
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
                  Text(widget.bloon.description, style: smallTitleStyle),
                  const SizedBox(height: 10),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Skulls:",
                    style: titleStyle,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Normal: ${widget.bloon.skullCount['normal']}",
                        style: normalStyle,
                      ),
                      Text(
                        "Normal: ${widget.bloon.skullCount['elite']}",
                        style: normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Health:",
                    style: titleStyle,
                  ),
                  const Text(
                    "Each additional player adds 20%",
                    style: normalStyle,
                  ),
                  bossHealth("Normal", widget.bloon.health.base),
                  bossHealth("Elite", widget.bloon.health.elite),
                  const SizedBox(height: 10),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "General Immunities:",
                    style: titleStyle,
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: widget.bloon.immunities.length,
                      itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(
                              "- ${widget.bloon.immunities[index]}",
                              style: normalStyle,
                            ),
                          )))
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
                "1: ${tierHealth.normal}, 2: ${tierHealth.coop2}"
                "\n3: ${tierHealth.coop3}, 4: ${tierHealth.coop4}",
                style: normalStyle,
              ),
            ),
          )
          .toList(),
    );
  }
}
