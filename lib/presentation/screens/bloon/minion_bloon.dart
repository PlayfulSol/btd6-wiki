import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/image_carousel.dart';
import '/models/bloons/boss/minion_bloon.dart';
import '/presentation/widgets/bloons/bloon_aid_widget.dart' show GimmicksWidget;
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/analytics/analytics_constants.dart';
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
  final controller = CarouselSliderController();
  late final MinionBloon minion;
  List<String> images = [];
  List<String> imageKeys = [];
  bool loading = true;
  int activeIndex = 0;

  void loadMinion() async {
    final path = '${minionsDataPath + widget.minionId}.json';
    final data = await rootBundle.loadString(path);
    minion = MinionBloon.fromJson(json.decode(data));
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
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;
    final carH = sw > 600 ? 360.0 : sw * 0.42;
    final vf = sw > 600 ? 0.8 : 0.7;

    return DetailPageScaffold(
      title: minion.name,
      accentColor: GameColors.danger,
      headerContent: Padding(
        padding: const EdgeInsets.only(top: 44),
        child: ImageCarousel(
          images: images,
          pathBuilder: minionImage,
          controller: controller,
          activeIndex: activeIndex,
          height: carH,
          viewportFraction: vf,
          accentColor: GameColors.danger,
          onPageChanged: (i) => setState(() => activeIndex = i),
          showIndicator: false,
        ),
      ),
      belowHeader: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            if (images.length > 1)
              AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count: images.length,
                onDotClicked: (i) => controller.jumpToPage(i),
                effect: ScrollingDotsEffect(
                  activeDotScale: 1.25,
                  spacing: 10,
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: GameColors.danger,
                  dotColor: colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
            if (bossImageLabels[imageKeys[activeIndex]] != null) ...[
              const SizedBox(height: 6),
              Text(
                bossImageLabels[imageKeys[activeIndex]]!,
                textAlign: TextAlign.center,
                style: smallTitleStyle.copyWith(color: GameColors.danger),
              ),
            ],
          ],
        ),
      ),
      body: [
        Chip(
          label: const Text(
            'Minion',
            style: TextStyle(
              color: GameColors.danger,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          backgroundColor: GameColors.danger.withValues(alpha: 0.12),
          side: BorderSide(color: GameColors.danger.withValues(alpha: 0.4)),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(height: 12),

        PropertyCard(
          title: 'Speed',
          children: [
            StatRow(label: 'Absolute', value: minion.speed.absolute),
            const SizedBox(height: 4),
            StatRow(label: 'Relative (to red bloon)', value: minion.speed.relative),
          ],
        ),
        const SizedBox(height: 12),

        PropertyCard(
          title: 'Health',
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Normal',
                            style: bolderNormalStyle.copyWith(fontSize: 14)),
                        const SizedBox(height: 6),
                        ..._healthItems(minion.health['normal'] ?? []),
                      ],
                    ),
                  ),
                  VerticalDivider(color: colorScheme.outlineVariant),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Elite',
                            style: bolderNormalStyle.copyWith(fontSize: 14)),
                        const SizedBox(height: 6),
                        ..._healthItems(minion.health['elite'] ?? []),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        const Text('Properties & Gimmicks', style: titleStyle),
        const SizedBox(height: 8),
        Card(
          child: GimmicksWidget(
            analyticsHelper: widget.analyticsHelper,
            id: minion.id,
            title: 'General Properties',
            gimmicks: List<String>.from(minion.gimmicks['general'] ?? []),
            expand: true,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: GimmicksWidget(
            analyticsHelper: widget.analyticsHelper,
            id: minion.id,
            title: 'Normal Gimmicks',
            gimmicks: List<String>.from(minion.gimmicks['normal'] ?? []),
            expand: false,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: GimmicksWidget(
            analyticsHelper: widget.analyticsHelper,
            id: minion.id,
            title: 'Elite Gimmicks',
            gimmicks: List<String>.from(minion.gimmicks['elite'] ?? []),
            expand: false,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  List<Widget> _healthItems(List<dynamic> items) {
    return items.map<Widget>((entry) {
      final health = entry.toString();
      final parts = health.split(', ');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: [
            Text(
              parts[0],
              style: normalStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (parts.length > 1)
              Text(
                parts[1],
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }).toList();
  }
}
