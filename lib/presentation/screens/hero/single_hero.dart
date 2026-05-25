import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/towers/hero/hero.dart';
import '/models/towers/common/hero_level_class.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/image_carousel.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/presentation/widgets/common/stats_and_changes.dart';
import '/presentation/widgets/heroes/hero_level.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

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
  late final HeroModelV2 singleHero;
  final controller = CarouselSliderController();
  List<String> skinsFirstImages = [];
  List<String> skinsNames = [];
  int activeIndex = 0;
  bool loading = true;

  HeroLevel _buildHeroLevel(HeroLevelData level) {
    List<String> lvlSkinsImages = [];
    bool shouldShowLevelImage = false;
    if (singleHero.skinChange.contains(level.name)) {
      shouldShowLevelImage = true;
      lvlSkinsImages = getSkinsImages(level.name);
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

  List<String> getSkinsImages(String lvl) {
    return singleHero.skins
        .where((s) => s.images[lvl] != null && s.images[lvl]!.isNotEmpty)
        .map((s) => s.images[lvl]!)
        .toList();
  }

  void loadHero() async {
    final path = '${heroDataPath + widget.heroId}.json';
    final data = await rootBundle.loadString(path);
    singleHero = HeroModelV2.fromJson(json.decode(data));
    setState(() {
      loading = false;
      final validSkins = singleHero.skins
          .where((s) => s.images.values.any((v) => v.isNotEmpty))
          .toList();
      skinsNames = validSkins.map((s) => s.name).toList();
      skinsFirstImages = validSkins.map((s) {
        final lvl1 = s.images['1'];
        if (lvl1 != null && lvl1.isNotEmpty) return lvl1;
        return s.images.values.firstWhere((v) => v.isNotEmpty, orElse: () => '');
      }).where((img) => img.isNotEmpty).toList();
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
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;
    final favoriteState = context.watch<FavoriteState>();
    final isFav = favoriteState.isFavorite(singleHero.type, singleHero.id);

    return DetailPageScaffold(
      title: singleHero.name,
      accentColor: GameColors.hero,
      fadeHeight: 80,
      isFavorite: isFav,
      onFavoriteToggle: () =>
          favoriteState.toggleFavoriteFunc(context, favoriteState, singleHero),
      headerContent: Positioned.fill(
        bottom: 56,
        child: LayoutBuilder(
          builder: (context, constraints) => ImageCarousel(
            images: skinsFirstImages,
            pathBuilder: heroImage,
            controller: controller,
            activeIndex: activeIndex,
            height: constraints.maxHeight,
            viewportFraction: sw > 600 ? 0.8 : 0.7,
            accentColor: GameColors.hero,
            onPageChanged: (i) => setState(() => activeIndex = i),
            showIndicator: false,
          ),
        ),
      ),
      headerOverlay: skinsFirstImages.length > 1
          ? Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: skinsFirstImages.length,
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
      body: [
        Chip(
          label: const Text(
            'Hero',
            style: TextStyle(
              color: GameColors.hero,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          backgroundColor: GameColors.hero.withValues(alpha: 0.12),
          side: BorderSide(color: GameColors.hero.withValues(alpha: 0.4)),
          visualDensity: VisualDensity.compact,
        ),
        if (skinsNames.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            skinsNames[activeIndex],
            style: smallTitleStyle.copyWith(color: colorScheme.primary),
          ),
        ],
        const SizedBox(height: 12),

        PropertyCard(
          title: 'Description',
          children: [Text(singleHero.inGameDesc, style: normalStyle)],
        ),
        const SizedBox(height: 12),

        PropertyCard(
          title: 'Stats',
          children: [
            for (final e in <MapEntry<String, String>>[
              MapEntry('Damage', singleHero.stats.damage),
              MapEntry('Pierce', singleHero.stats.pierce),
              MapEntry('Attack Speed', singleHero.stats.attackSpeed),
              MapEntry('Range', singleHero.stats.range),
              MapEntry('Camo', singleHero.stats.camo),
              MapEntry('Footprint', singleHero.stats.footprint),
              MapEntry('Damage Type', singleHero.stats.damageType),
              MapEntry('Status Effects', singleHero.stats.statuseffects),
              MapEntry('Tower Boosts', singleHero.stats.towerboosts),
              MapEntry('Income Boosts', singleHero.stats.incomeboosts),
              if (singleHero.target.isNotEmpty)
                MapEntry('Targeting', singleHero.target),
            ].where((e) => e.value.isNotEmpty)) ...[
              StatRow(label: e.key, value: e.value),
              const SizedBox(height: 4),
            ],
          ],
        ),
        const SizedBox(height: 12),
        PropertyCard(
          title: 'Cost',
          children: [
            StatRow(label: 'Easy', value: singleHero.cost.easy),
            const SizedBox(height: 4),
            StatRow(label: 'Medium', value: singleHero.cost.medium),
            const SizedBox(height: 4),
            StatRow(label: 'Hard', value: singleHero.cost.hard),
            const SizedBox(height: 4),
            StatRow(label: 'Impoppable', value: singleHero.cost.impoppable),
          ],
        ),

        if (singleHero.changes != null) ...[
          const SizedBox(height: 8),
          ChangesWidget(changes: singleHero.changes!),
        ],

        if (singleHero.skins.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.style_outlined),
              label: const Text('View All Skins'),
              onPressed: () =>
                  context.push('/heroes/${singleHero.id}/skins'),
            ),
          ),
        ],

        const SizedBox(height: 12),

        ListView.builder(
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: singleHero.levels.length,
          itemBuilder: (_, index) => _buildHeroLevel(singleHero.levels[index]),
        ),
      ],
    );
  }
}
