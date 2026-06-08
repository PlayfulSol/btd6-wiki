import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/base/base_model.dart';
import '/models/base/base_bloon.dart';
import '/presentation/widgets/common/filter_chips_row.dart';
import '/presentation/widgets/common/list_item_card.dart';
import '/presentation/widgets/common/no_results_widget.dart';
import '/presentation/widgets/common/section_header.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/seen_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class Bloons extends StatefulWidget {
  const Bloons({
    super.key,
    required this.analyticsHelper,
    required this.bloonsList,
    required this.bossesList,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseBloon> bloonsList;
  final List<BaseModel> bossesList;

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kBloons,
    );
  }

  Color _chipColor(BuildContext context, String option) {
    switch (option) {
      case 'MOAB':
        return GameColors.moab;
      case 'Bosses':
      case 'Changes':
        return GameColors.danger;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _sectionLabel(BaseModel item) {
    if (item.type == kBosses) return 'Boss';
    if (item is BaseBloon && item.isMoab) return 'MOAB';
    return 'Bloon';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final isTablet = screenWidth < 750;

    final bloonCross = isMobile ? 3 : (isTablet ? 4 : 5);
    final bossCross = isMobile ? 2 : (isTablet ? 3 : 4);
    final bloonAspect = isMobile ? 0.90 : 0.85;
    final bossAspect = isMobile ? 0.88 : 0.80;

    return Scaffold(
      body: Column(
        children: [
          Consumer<GlobalState>(
            builder: (context, globalState, _) => globalState.isSearchEnabled
                ? SearchBarWidget(queryText: globalState.currentQuery)
                : const SizedBox.shrink(),
          ),
          Consumer<GlobalState>(
            builder: (context, globalState, _) => FilterChipsRow(
              options: bloonTypes,
              selected: globalState.optionForCategory(kBloons),
              onSelect: (option) => globalState.updateCurrentOptionSelected(
                  category: kBloons, option: option),
              colorForOption: _chipColor,
            ),
          ),
          Expanded(
            child: Consumer3<GlobalState, FavoriteState, SeenState>(
              builder: (context, globalState, favoriteState, seenState, _) {
                final query = globalState.currentQuery.toLowerCase();
                final option = globalState.optionForCategory(kBloons);

                final allBloons = widget.bloonsList
                    .where((b) => !b.isMoab && b.name.toLowerCase().contains(query))
                    .toList();
                final allMoab = widget.bloonsList
                    .where((b) => b.isMoab && b.name.toLowerCase().contains(query))
                    .toList();
                final allBosses = widget.bossesList
                    .where((b) => b.name.toLowerCase().contains(query))
                    .toList();

                final visibleBloons = switch (option) {
                  'All' || 'Bloons' => allBloons,
                  'Changes' => allBloons.where((b) => b.changes != null).toList(),
                  _ => <BaseModel>[],
                };
                final visibleMoab = switch (option) {
                  'All' || 'MOAB' => allMoab,
                  'Changes' => allMoab.where((b) => b.changes != null).toList(),
                  _ => <BaseModel>[],
                };
                final visibleBosses = switch (option) {
                  'All' || 'Bosses' => allBosses,
                  'Changes' => allBosses.where((b) => b.changes != null).toList(),
                  _ => <BaseModel>[],
                };

                final hasResults = visibleBloons.isNotEmpty ||
                    visibleMoab.isNotEmpty ||
                    visibleBosses.isNotEmpty;

                return CustomScrollView(
                  slivers: [
                    if (!hasResults)
                      const SliverFillRemaining(child: NoResultsWidget()),

                    if (visibleBloons.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: 'Bloons',
                          accentColor: Theme.of(context).colorScheme.primary,
                          count: visibleBloons.length,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: _buildGrid(
                          context: context,
                          items: visibleBloons,
                          favoriteState: favoriteState,
                          seenState: seenState,
                          crossAxisCount: bloonCross,
                          aspectRatio: bloonAspect,
                          getImagePath: (b) => bloonImage(b.image),
                          getRoute: (b) => '/bloons/${b.id}',
                          analyticsScreen: kBloonPagesClass,
                        ),
                      ),
                    ],

                    if (visibleMoab.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: 'MOAB',
                          accentColor: GameColors.moab,
                          count: visibleMoab.length,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: _buildGrid(
                          context: context,
                          items: visibleMoab,
                          favoriteState: favoriteState,
                          seenState: seenState,
                          crossAxisCount: bloonCross,
                          aspectRatio: bloonAspect,
                          getImagePath: (b) => bloonImage(b.image),
                          getRoute: (b) => '/bloons/${b.id}',
                          analyticsScreen: kBloonPagesClass,
                        ),
                      ),
                    ],

                    if (visibleBosses.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: 'Boss',
                          accentColor: GameColors.danger,
                          count: visibleBosses.length,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: _buildGrid(
                          context: context,
                          items: visibleBosses,
                          favoriteState: favoriteState,
                          seenState: seenState,
                          crossAxisCount: bossCross,
                          aspectRatio: bossAspect,
                          getImagePath: (b) => bossImage(b.image),
                          getRoute: (b) => '/bosses/${b.id}',
                          analyticsScreen: kBossPagesClass,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverGrid _buildGrid({
    required BuildContext context,
    required List<BaseModel> items,
    required FavoriteState favoriteState,
    required SeenState seenState,
    required int crossAxisCount,
    required double aspectRatio,
    required String Function(BaseModel) getImagePath,
    required String Function(BaseModel) getRoute,
    required String analyticsScreen,
  }) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          final isFav = favoriteState.isFavorite(item.type, item.id);
          // Accent per section: bosses → danger, MOAB-class → moab, regular → primary.
          // item is BaseBloon for bloons/MOAB, BaseModel for bosses.
          final bloonItem = item is BaseBloon ? item : null;
          final accentColor = item.type == kBosses
              ? GameColors.danger
              : (bloonItem?.isMoab ?? false)
                  ? GameColors.moab
                  : Theme.of(context).colorScheme.primary;
          final showBadge = item.changes != null && !seenState.isSeen(item.id);

          return ListItemCard(
            imagePath: getImagePath(item),
            imageName: item.image,
            name: item.name,
            subtitle: _sectionLabel(item),
            accentColor: accentColor,
            isFavorite: isFav,
            showChangeBadge: showBadge,
            onDismissChangeBadge:
                showBadge ? () => seenState.markSeen(item.id) : null,
            onTap: () {
              if (favoriteState.isMultiSelectMode) {
                favoriteState.toggleFavoriteFunc(context, item);
              } else {
                seenState.markSeen(item.id);
                widget.analyticsHelper.logEvent(
                  name: widgetEngagement,
                  parameters: {
                    'screen': analyticsScreen,
                    'widget': listTile,
                    'value': item.id,
                  },
                );
                context.push(getRoute(item));
              }
            },
            onLongPress: () =>
                favoriteState.toggleFavoriteFunc(context, item),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
