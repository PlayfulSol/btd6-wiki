import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/towers/hero/hero.dart';
import '/models/towers/hero/hero_skin.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/image_carousel.dart';
import '/presentation/widgets/common/loader.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class HeroSkins extends StatefulWidget {
  final String heroId;
  final AnalyticsHelper analyticsHelper;

  const HeroSkins({
    super.key,
    required this.heroId,
    required this.analyticsHelper,
  });

  @override
  State<HeroSkins> createState() => _HeroSkinsState();
}

class _HeroSkinsState extends State<HeroSkins> {
  final controller = CarouselSliderController();
  int activeIndex = 0;
  bool loading = true;
  late String heroName;
  late List<HeroSkin> heroSkins;
  late List<String> carouselImages;

  void loadHero() async {
    final path = '${heroDataPath + widget.heroId}.json';
    final data = await rootBundle.loadString(path);
    final hero = HeroModelV2.fromJson(json.decode(data));
    setState(() {
      loading = false;
      heroName = hero.name;
      heroSkins = hero.skins
          .where((s) => s.images.values.any((v) => v.isNotEmpty))
          .toList();
      carouselImages = heroSkins
          .map((s) => s.images['1'])
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kHeroSkinsPage,
      screenName: widget.heroId,
    );
    loadHero();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final constraintsValues = getPreset(MediaQuery.of(context).size);
    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;
    final vf = sw > 600 ? 0.8 : 0.7;

    return DetailPageScaffold(
      title: '$heroName — Skins',
      accentColor: GameColors.hero,
      fadeHeight: 80,
      headerContent: carouselImages.isNotEmpty
          ? Positioned.fill(
              bottom: 56,
              child: LayoutBuilder(
                builder: (context, constraints) => ImageCarousel(
                  images: carouselImages,
                  pathBuilder: heroImage,
                  controller: controller,
                  activeIndex: activeIndex,
                  height: constraints.maxHeight,
                  viewportFraction: vf,
                  accentColor: GameColors.hero,
                  onPageChanged: (i) => setState(() => activeIndex = i),
                  showIndicator: false,
                ),
              ),
            )
          : const SizedBox.shrink(),
      headerOverlay: carouselImages.length > 1
          ? Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: carouselImages.length,
                  onDotClicked: (i) => controller.jumpToPage(i),
                  effect: ScrollingDotsEffect(
                    activeDotScale: 1.25,
                    spacing: 10,
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: GameColors.hero,
                    dotColor: colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
              ),
            )
          : null,
      sliverBody: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final skin = heroSkins[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ExpansionTile(
                      title: Text(
                        skin.name,
                        style: titleStyle.copyWith(color: GameColors.hero),
                      ),
                      onExpansionChanged: (bool value) {
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': kHeroSkinsPage,
                            'widget': expansionTile,
                            'value': '${widget.heroId}_${skin.name}_$value',
                          },
                        );
                      },
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                constraintsValues[skinCrossCount],
                            childAspectRatio:
                                constraintsValues[skinAspectRatio],
                          ),
                          itemCount: () {
                            final count = skin.images.entries
                                .where((e) => e.value.isNotEmpty)
                                .length;
                            return count > 0 ? count : 1;
                          }(),
                          itemBuilder: (context, imageIndex) {
                            final validEntries = skin.images.entries
                                .where((e) => e.value.isNotEmpty)
                                .toList();
                            if (validEntries.isEmpty) {
                              return const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: AppImage(path: ''),
                                ),
                              );
                            }
                            final entry = validEntries[imageIndex];
                            return Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: AppImage(
                                        path: heroImage(entry.value),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Level ${entry.key}',
                                      style: smallTitleStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: heroSkins.length,
            ),
          ),
        ),
      ],
    );
  }
}
