import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/base/base_map.dart';
import '/presentation/widgets/common/filter_chips_row.dart';
import '/presentation/widgets/common/no_results_widget.dart';
import '/presentation/widgets/common/section_header.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/presentation/widgets/maps/map_card.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Maps extends StatefulWidget {
  const Maps({
    super.key,
    required this.analyticsHelper,
    required this.maps,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseMap> maps;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kMaps,
    );
    widget.maps.sort((a, b) =>
        mapDifficulties.indexOf(a.difficulty) -
        mapDifficulties.indexOf(b.difficulty));
  }

  Color _chipColor(BuildContext context, String option) {
    if (option == 'All') return Theme.of(context).colorScheme.primary;
    return difficultyColor(option);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final isTablet = screenWidth < 750;
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    final aspectRatio = isMobile ? 1.1 : 1.0;

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
              options: mapDifficulties,
              selected: globalState.optionForCategory(kMaps),
              onSelect: (option) => globalState.updateCurrentOptionSelected(
                  category: kMaps, option: option),
              colorForOption: _chipColor,
            ),
          ),
          Expanded(
            child: Consumer2<GlobalState, FavoriteState>(
              builder: (context, globalState, favoriteState, _) {
                final filtered = filterAndSearchMaps(
                    widget.maps,
                    globalState.currentQuery,
                    globalState.optionForCategory(kMaps));

                final groups = <String, List<BaseMap>>{};
                for (final d in mapDifficulties.skip(1)) {
                  final group =
                      filtered.where((m) => m.difficulty == d).toList();
                  if (group.isNotEmpty) groups[d] = group;
                }

                return CustomScrollView(
                  slivers: [
                    if (groups.isEmpty)
                      const SliverFillRemaining(child: NoResultsWidget()),

                    for (final entry in groups.entries) ...[
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: entry.key,
                          accentColor: difficultyColor(entry.key),
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
                              final map = entry.value[index];
                              return MapCard(
                                singleMap: map,
                                isFavorite: favoriteState.isFavorite(map.type, map.id),
                                onLongPress: () => favoriteState.toggleFavoriteFunc(
                                    context, favoriteState, map),
                                onTap: () {
                                  if (!favoriteState.isMultiSelectMode) {
                                    widget.analyticsHelper.logEvent(
                                      name: widgetEngagement,
                                      parameters: {
                                        'screen': kMapPagesClass,
                                        'widget': map.id,
                                      },
                                    );
                                    context.push('/maps/${map.id}');
                                  } else {
                                    favoriteState.toggleFavoriteFunc(
                                        context, favoriteState, map);
                                  }
                                },
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
