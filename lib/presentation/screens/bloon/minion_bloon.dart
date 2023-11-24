import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/bloons/minion_bloon.dart';
import '../../../utilities/images_url.dart';
import '../../../utilities/constants.dart';
import '../../widgets/bloon_aid_widget.dart';

class MinionBloonPage extends StatefulWidget {
  final MinionBloon minion;

  const MinionBloonPage({super.key, required this.minion});

  @override
  State<MinionBloonPage> createState() => _MinionBloonPageState();
}

class _MinionBloonPageState extends State<MinionBloonPage> {
  final controller = CarouselController();
  List<String> images = [];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.minion.images.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.minion.name),
      ),
      body: SingleChildScrollView(
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
                        image: AssetImage(minionImage(images[index])),
                        filterQuality: FilterQuality.high,
                        width: MediaQuery.of(context).size.width * 0.56,
                      )),
                ),
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
            widget.minion.name,
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
                "Absolute: ${widget.minion.speed.absolute}",
                style: normalStyle,
              ),
              Text(
                "Relative (to red bloon): ${widget.minion.speed.relative}",
                style: normalStyle,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Health",
            style: bigTitleStyle,
          ),
          const SizedBox(height: 10),
          GridView(
            primary: false,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            children: [
              BloonAidWidget(
                data: widget.minion.health["normal"],
                title: "Normal",
              ),
              BloonAidWidget(
                data: widget.minion.health["elite"],
                title: "Elite",
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
            "General Properties",
            List<String>.from(widget.minion.gimmicks["general"]),
            true,
          ),
          gimmicks(
            "Normal Gimmicks",
            List<String>.from(widget.minion.gimmicks["normal"]),
            false,
          ),
          gimmicks(
            "Elite Gimmicks",
            List<String>.from(widget.minion.gimmicks["elite"]),
            false,
          ),
        ],
      )),
    );
  }
}
