import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '/models/towers/common/hero_level_class.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/carousel_with_indicator.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/presentation/widgets/common/stats_and_changes.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class HeroLevel extends StatefulWidget {
  final List<String> heroImages;
  final String heroName;
  final String heroId;
  final HeroLevelData level;
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
  final controller = CarouselSliderController();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
      collapsedBackgroundColor: colorScheme.surfaceContainerHighest,
      title: Text(
        "Level ${widget.level.name}",
        style: titleStyle.copyWith(color: colorScheme.primary),
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
        if (widget.shouldShowLevelImage)
          LayoutBuilder(
            builder: (context, constraints) {
              final sw = MediaQuery.of(context).size.width;
              final imgW = sw > 600 ? 400.0 : sw * 0.56;
              final carH = sw > 600 ? 360.0 : sw * 0.5;
              final vf = sw > 600 ? 0.8 : 0.64;
              return CarouselWithIndicator(
                itemCount: widget.heroImages.length,
                controller: controller,
                activeIndex: activeIndex,
                height: carH,
                viewportFraction: vf,
                activeDotColor: colorScheme.primary,
                dotColor: colorScheme.outline.withValues(alpha: 0.4),
                onPageChanged: (i) => setState(() => activeIndex = i),
                itemBuilder: (ctx, i) => AppImage(
                  path: heroImage(widget.heroImages[i]),
                  width: imgW,
                ),
              );
            },
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.level.upgrade != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Unlocks: ${widget.level.upgrade}',
                    style: subtitleStyle.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(widget.level.description, style: normalStyle),
              const SizedBox(height: 10),
              Divider(height: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 8),
              StatRow(label: 'XP Cost', value: widget.level.xpCost),
              UpgradeStatsWidget(stats: widget.level.stats),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
