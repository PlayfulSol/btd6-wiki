import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_hero.dart';
import '/models/base_model.dart';
import '/presentation/screens/hero/single_hero.dart';
import '../../widgets/misc/search_widget.dart';
import '../../widgets/misc/image_outline.dart';
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

  @override
  Widget build(BuildContext context) {
    final constraintsValues = getPreset(
      MediaQuery.of(context).size,
    );

    FavoriteState favoriteState =
        Provider.of<FavoriteState>(context, listen: false);
    favoriteState.fillList(kHeroes, widget.heroes);
    bool isFavorite = false;
    return Scaffold(
      body: Column(
        children: [
          Consumer<GlobalState>(
            builder: (context, globalState, child) =>
                globalState.isSearchEnabled
                    ? SearchBarWidget(queryText: globalState.currentQuery)
                    : Container(),
          ),
          Expanded(
            child: Consumer<GlobalState>(
              builder: (context, globalState, child) {
                final filteredHeroes =
                    heroesFromSearch(widget.heroes, globalState.currentQuery);
                return GridView.builder(
                  itemCount: filteredHeroes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraintsValues[heroCrossCount],
                    childAspectRatio: constraintsValues[heroAspectRatio],
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final hero = filteredHeroes[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onLongPress: () {
                        isFavorite = handleFavorite(kHeroes, hero.id);
                        if (isFavorite) {
                          BaseModel favoriteHero = BaseModel(
                            hero.id,
                            hero.name,
                            hero.image,
                            hero.type,
                          );
                          favoriteState.addFavorite(kHeroes, favoriteHero);
                        } else {
                          favoriteState.removeFavorite(kHeroes, hero.id);
                        }
                        print(favoriteState.favoriteBox.get(kHeroes));
                      },
                      onTap: () {
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': kHeroPagesClass,
                            'widget': listTile,
                            'value': hero.id,
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleHero(
                              heroId: hero.id,
                              analyticsHelper: widget.analyticsHelper,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 8),
                            child: Center(
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                horizontalTitleGap: 8,
                                leading: ImageOutliner(
                                  imageName: hero.image,
                                  imagePath: heroImage(hero.image),
                                ),
                                title: Text(
                                  hero.name,
                                  style: constraintsValues[heroTitleStyle],
                                ),
                                subtitle: Text(
                                  hero.inGameDesc,
                                  overflow: TextOverflow.ellipsis,
                                  style: constraintsValues[heroSubtitleStyle],
                                  maxLines: constraintsValues[heroSubtitleRows],
                                ),
                              ),
                            ),
                          ),
                          Consumer<FavoriteState>(
                            builder: (context, favoriteState, child) {
                              return Positioned(
                                top: 17,
                                right: 25,
                                child: favoriteState.isInFavorites(
                                        kHeroes, hero.id)
                                    ? const Icon(Icons.star)
                                    : const Icon(Icons.star_border_outlined),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
