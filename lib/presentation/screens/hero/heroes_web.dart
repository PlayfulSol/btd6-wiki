import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/utilities/strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_hero.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/presentation/widgets/common/image_outline.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class HeroesWeb extends StatefulWidget {
  const HeroesWeb({
    super.key,
    required this.analyticsHelper,
    required this.heroes,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseHero> heroes;

  @override
  State<HeroesWeb> createState() => _HeroesWebState();
}

class _HeroesWebState extends State<HeroesWeb> {
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
            child: Consumer2<GlobalState, FavoriteState>(
              builder: (context, globalState, favoriteState, child) {
                final filteredHeroes =
                    heroesFromSearch(widget.heroes, globalState.currentQuery);
                return GridView.builder(
                  itemCount: filteredHeroes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final hero = filteredHeroes[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onLongPress: () => favoriteState.toggleFavoriteFunc(
                          context, favoriteState, hero),
                      onTap: () {
                        if (!favoriteState.isMultiSelectMode) {
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
                        } else {
                          favoriteState.toggleFavoriteFunc(
                              context, favoriteState, hero);
                        }
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  semanticLabel: hero.name,
                                  image: AssetImage(heroImage(hero.image)),
                                  fit: BoxFit.contain,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                                title: AutoSizeText(
                                  capitalizeEveryWord(hero.name),
                                  maxLines: 1,
                                  style: titleStyle,
                                ),
                                subtitle: AutoSizeText(
                                  hero.inGameDesc,
                                  maxLines: 1,
                                  style: normalStyle,
                                  minFontSize: 15,
                                ),
                                trailing: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () =>
                                        favoriteState.toggleFavoriteFunc(
                                            context, favoriteState, hero),
                                    child: favoriteState.isFavorite(
                                            hero.type, hero.id)
                                        ? const Icon(Icons.star)
                                        : const Icon(
                                            Icons.star_border_outlined),
                                  ),
                                )),
                          ],
                        ),
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
