import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/towers/common/upgrade_info_class.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class HeroLevel extends StatefulWidget {
  final List<String> heroImages;
  final String heroName;
  final String heroId;
  final UpgradeInfo level;
  final bool shouldShowLevelImage;
  final AnalyticsHelper analyticsHelper;

  const HeroLevel({
    super.key,
    required this.heroId,
    required this.level,
    required this.shouldShowLevelImage,
    required this.heroImages,
    required this.heroName,
    required this.analyticsHelper,
  });

  @override
  State<HeroLevel> createState() => _HeroLevelState();
}

class _HeroLevelState extends State<HeroLevel> {
  final controller = CarouselController();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Level ${widget.level.name}",
        style: titleStyle.copyWith(color: Colors.teal),
      ),
      onExpansionChanged: (bool value) {
        widget.analyticsHelper.logEvent(
          name: widgetEngagement,
          parameters: {
            'screen': widget.heroId,
            'widget': expansionTile,
            'value': 'hero_${widget.level.name}_$value',
          },
        );
      },
      children: [
        const SizedBox(height: 15),
        widget.shouldShowLevelImage
            ? Column(
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
                    itemCount: widget.heroImages.length,
                    itemBuilder: ((context, index, realIndex) => Image(
                          image:
                              AssetImage(heroImage(widget.heroImages[index])),
                          filterQuality: FilterQuality.high,
                          width: MediaQuery.of(context).size.width * 0.56,
                        )),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: widget.heroImages.length,
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
              )
            : Container(),
        const SizedBox(height: 15),
        Text(widget.level.upgradeBody,
            textAlign: TextAlign.center, style: normalStyle),
        const SizedBox(height: 10),
        if (widget.level.name != '1') ...[
          Text(
            "Cost: ${widget.level.cost}",
            textAlign: TextAlign.center,
            style: normalStyle,
          ),
          const SizedBox(height: 30),
        ],
      ],
    );
  }
}
