import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/bloons/bloon/bloon.dart';
import '/models/bloons/common/variant_class.dart';
import '/presentation/widgets/bloons/bloon_aid_widget.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class SingleBloon extends StatefulWidget {
  const SingleBloon({
    super.key,
    required this.analyticsHelper,
    required this.bloonId,
  });

  final AnalyticsHelper analyticsHelper;
  final String bloonId;

  @override
  State<SingleBloon> createState() => _SingleBloonState();
}

class _SingleBloonState extends State<SingleBloon> {
  late final BloonModel bloon;
  bool loading = true;

  void loadBloon() async {
    final path = '${bloonsDataPath + widget.bloonId}.json';
    final data = await rootBundle.loadString(path);
    bloon = BloonModel.fromJson(json.decode(data));
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kBloonPagesClass,
      screenName: widget.bloonId,
    );
    loadBloon();
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
    final accentColor =
        bloon.isMoab ? GameColors.moab : colorScheme.tertiaryContainer;
    final chipColor = bloon.isMoab ? GameColors.moab : colorScheme.tertiary;
    final favoriteState = context.watch<FavoriteState>();
    final isFav = favoriteState.isFavorite(bloon.type, bloon.id);

    return DetailPageScaffold(
      title: bloon.name,
      accentColor: accentColor,
      isFavorite: isFav,
      onFavoriteToggle: () =>
          favoriteState.toggleFavoriteFunc(context, favoriteState, bloon),
      headerContent: Padding(
        padding: const EdgeInsets.fromLTRB(0, 56, 0, 48),
        child: AppImage(path: bloonImage(bloon.image)),
      ),
      body: [
        Chip(
          label: Text(
            bloon.isMoab ? 'MOAB-Class' : 'Bloon',
            style: TextStyle(
              color: chipColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          backgroundColor: chipColor.withValues(alpha: 0.12),
          side: BorderSide(color: chipColor.withValues(alpha: 0.4)),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(height: 12),

        // Stats
        PropertyCard(
          title: 'Stats',
          children: [
            StatRow(label: 'Health', value: '${bloon.health}'),
            const SizedBox(height: 4),
            StatRow(label: 'Leak Damage', value: '${bloon.leakDamage}'),
            const SizedBox(height: 4),
            StatRow(label: 'Layer Number', value: '${bloon.layerNumber}'),
            const SizedBox(height: 4),
            StatRow(label: 'First Appearance', value: bloon.firstAppearance),
          ],
        ),
        const SizedBox(height: 12),

        // RBE
        BloonAidWidget(
          bloonId: bloon.id,
          analyticsHelper: widget.analyticsHelper,
          data: bloon.rbe,
          title: 'RBE (Red Bloon Equivalent)',
        ),
        const SizedBox(height: 12),

        // Speed
        PropertyCard(
          title: 'Speed',
          children: [
            StatRow(label: 'Relative (to red bloon)', value: bloon.speed.relative),
            const SizedBox(height: 4),
            StatRow(label: 'Absolute (units)', value: bloon.speed.absolute),
          ],
        ),
        const SizedBox(height: 12),

        // Children / Parents
        BloonAidWidget(
          analyticsHelper: widget.analyticsHelper,
          data: bloon.children,
          title: 'Children',
          bloonId: bloon.id,
        ),
        const SizedBox(height: 12),
        BloonAidWidget(
          bloonId: bloon.id,
          analyticsHelper: widget.analyticsHelper,
          data: bloon.parents,
          title: 'Parents',
        ),

        // Variants
        if (bloon.variants.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              title: Text(
                'Variants',
                style: smallTitleStyle.copyWith(color: colorScheme.primary),
              ),
              onExpansionChanged: (v) {
                widget.analyticsHelper.logEvent(
                  name: widgetEngagement,
                  parameters: {
                    'screen': bloon.id,
                    'widget': expansionTile,
                    'value': 'variants_$v',
                  },
                );
              },
              children: bloon.variants
                  .map((e) => _variantTile(e, colorScheme))
                  .toList(),
            ),
          ),
        ],

        // Rounds
        const SizedBox(height: 12),
        const Text('Rounds', style: titleStyle),
        const SizedBox(height: 6),
        Card(
          child: ExpansionTile(
            title: Text('Normal',
                style: smallTitleStyle.copyWith(color: colorScheme.primary)),
            onExpansionChanged: (v) {
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': bloon.id,
                  'widget': expansionTile,
                  'value': 'normal_rounds_$v',
                },
              );
            },
            children:
                bloon.rounds.normal.map((e) => _roundTile(e)).toList(),
          ),
        ),
        const SizedBox(height: 6),
        Card(
          child: ExpansionTile(
            title: Text('ABR',
                style: smallTitleStyle.copyWith(color: colorScheme.primary)),
            onExpansionChanged: (v) {
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': bloon.id,
                  'widget': expansionTile,
                  'value': 'abr_rounds_$v',
                },
              );
            },
            children: bloon.rounds.abr.map((e) => _roundTile(e)).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _variantTile(Variant e, ColorScheme colorScheme) {
    final badges = <String>[];
    if (e.isCamo) badges.add('Camo');
    if (e.isRegrow) badges.add('Regrow');
    if (e.isFortified) badges.add('Fortified');

    return ListTile(
      title: Text(e.name,
          style: normalStyle.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badges.isNotEmpty)
            Wrap(
              spacing: 4,
              children: badges
                  .map((b) => Chip(
                        label: Text(b,
                            style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onPrimaryContainer)),
                        backgroundColor: colorScheme.primaryContainer,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          Text('HP: ${e.health}  •  ${e.appearances}',
              style: subtitleStyle.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
      leading: SizedBox(
        width: 50,
        child: AppImage(path: bloonImage(e.image)),
      ),
    );
  }

  Widget _roundTile(String e) {
    final parts = separateString(e);
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Text(parts[0], style: bolderNormalStyle),
          Text(parts[1], style: normalStyle),
        ],
      ),
    );
  }
}
