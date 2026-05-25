import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/base/base_tower.dart';
import '/presentation/widgets/common/filter_chips_row.dart';
import '/presentation/widgets/common/list_item_card.dart';
import '/presentation/widgets/common/no_results_widget.dart';
import '/presentation/widgets/common/section_header.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

// Class sections in canonical BTD6 order.
const _towerSections = ['Primary', 'Military', 'Magic', 'Support'];

class Towers extends StatefulWidget {
  const Towers({
    super.key,
    required this.analyticsHelper,
    required this.towers,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseTower> towers;

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kTowers,
    );
  }

  Color _chipColor(BuildContext context, String option) {
    if (option == 'All') return Theme.of(context).colorScheme.primary;
    return GameColors.forClass(option);
  }

  void _onTowerTap(BuildContext context, BaseTower tower) {
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: {
        'screen': kTowerPagesClass,
        'widget': listTile,
        'value': tower.id,
      },
    );
    context.push('/towers/${tower.id}');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final isTablet = screenWidth < 750;
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    final aspectRatio = isMobile ? 0.88 : 0.80;

    return Scaffold(
      body: Column(
        children: [
          // Search bar (visible when enabled)
          Consumer<GlobalState>(
            builder: (context, globalState, _) => globalState.isSearchEnabled
                ? SearchBarWidget(queryText: globalState.currentQuery)
                : const SizedBox.shrink(),
          ),
          // Filter chips (always visible)
          Consumer<GlobalState>(
            builder: (context, globalState, _) => FilterChipsRow(
              options: towerTypes,
              selected: globalState.optionForCategory(kTowers),
              onSelect: (option) => globalState.updateCurrentOptionSelected(
                  category: kTowers, option: option),
              colorForOption: _chipColor,
            ),
          ),
          // Sectioned grid
          Expanded(
            child: Consumer2<GlobalState, FavoriteState>(
              builder: (context, globalState, favoriteState, _) {
                final filtered = filterAndSearchTowers(
                  widget.towers,
                  globalState.currentQuery,
                  globalState.optionForCategory(kTowers),
                );

                // Group by class, keeping canonical section order.
                final groups = {
                  for (final cls in _towerSections)
                    cls: filtered
                        .where((t) => t.classType == cls)
                        .toList()
                };
                final nonEmpty =
                    groups.entries.where((e) => e.value.isNotEmpty).toList();

                return CustomScrollView(
                  slivers: [
                    if (nonEmpty.isEmpty)
                      const SliverFillRemaining(child: NoResultsWidget()),

                    for (final entry in nonEmpty) ...[
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: entry.key,
                          accentColor: GameColors.forClass(entry.key),
                          count: entry.value.length,
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final tower = entry.value[index];
                              final isFav = favoriteState.isFavorite(
                                  tower.type, tower.id);
                              return ListItemCard(
                                imagePath: towerImage(tower.image),
                                imageName: tower.image,
                                name: tower.name,
                                subtitle: tower.classType,
                                accentColor: GameColors.forClass(tower.classType),
                                isFavorite: isFav,
                                onTap: () => favoriteState.isMultiSelectMode
                                    ? favoriteState.toggleFavoriteFunc(
                                        context, favoriteState, tower)
                                    : _onTowerTap(context, tower),
                                onLongPress: () =>
                                    favoriteState.toggleFavoriteFunc(
                                        context, favoriteState, tower),
                              );
                            },
                            childCount: entry.value.length,
                          ),
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
}
