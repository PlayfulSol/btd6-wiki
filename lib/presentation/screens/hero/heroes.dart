import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/base/base_hero.dart';
import '/presentation/widgets/common/filter_chips_row.dart';
import '/presentation/widgets/common/list_item_card.dart';
import '/presentation/widgets/common/no_results_widget.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Heroes extends StatefulWidget {
  const Heroes({
    super.key,
    required this.analyticsHelper,
    required this.heroes,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseHero> heroes;

  @override
  State<Heroes> createState() => _HeroesState();
}

class _HeroesState extends State<Heroes> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kHeroes,
    );
  }

  String _costLabel(BaseHero hero, String option) {
    switch (option) {
      case 'Easy':
        return '\$${hero.easyCost} (Easy)';
      case 'Hard':
        return '\$${hero.hardCost} (Hard)';
      case 'Impop':
        return '\$${hero.impoppableCost} (Impop)';
      default:
        return '\$${hero.mediumCost} (Medium)';
    }
  }

  bool _matchesPriceFilter(BaseHero hero, String option) {
    switch (option) {
      case 'Easy':
        return hero.easyCost <= 650;
      case 'Medium':
        return hero.mediumCost <= 650;
      case 'Hard':
        return hero.hardCost <= 650;
      case 'Impop':
        return hero.impoppableCost <= 650;
      default:
        return true;
    }
  }

  void _onHeroTap(BuildContext context, BaseHero hero) {
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: {
        'screen': kHeroPagesClass,
        'widget': listTile,
        'value': hero.id,
      },
    );
    context.push('/heroes/${hero.id}');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final isTablet = screenWidth < 750;
    // Heroes always use 2 columns on mobile/tablet, 3 on desktop —
    // portrait images benefit from the extra vertical space.
    final crossAxisCount = isMobile || isTablet ? 2 : 3;
    final aspectRatio = isMobile ? 0.80 : 0.75;

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
              options: heroPriceRanges,
              selected: globalState.optionForCategory(kHeroes),
              onSelect: (option) => globalState.updateCurrentOptionSelected(
                  category: kHeroes, option: option),
              colorForOption: (_, __) => GameColors.hero,
            ),
          ),
          Expanded(
            child: Consumer2<GlobalState, FavoriteState>(
              builder: (context, globalState, favoriteState, _) {
                final filtered = heroesFromSearch(
                        widget.heroes, globalState.currentQuery)
                    .where((h) =>
                        _matchesPriceFilter(h, globalState.optionForCategory(kHeroes)))
                    .toList();

                return CustomScrollView(
                  slivers: [
                    if (filtered.isEmpty)
                      const SliverFillRemaining(child: NoResultsWidget()),

                    if (filtered.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
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
                              final hero = filtered[index];
                              final isFav =
                                  favoriteState.isFavorite(hero.type, hero.id);
                              return ListItemCard(
                                imagePath: heroImage(hero.image),
                                imageName: hero.image,
                                name: hero.name,
                                subtitle:
                                    _costLabel(hero, globalState.optionForCategory(kHeroes)),
                                accentColor: GameColors.hero,
                                isFavorite: isFav,
                                onTap: () => favoriteState.isMultiSelectMode
                                    ? favoriteState.toggleFavoriteFunc(
                                        context, favoriteState, hero)
                                    : _onHeroTap(context, hero),
                                onLongPress: () =>
                                    favoriteState.toggleFavoriteFunc(
                                        context, favoriteState, hero),
                              );
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),

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
