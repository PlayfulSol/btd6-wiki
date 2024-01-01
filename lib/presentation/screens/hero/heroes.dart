import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_hero.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
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

                    return Card(
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
                            style: titleStyle.copyWith(
                              fontSize: constraintsValues[heroTitleFontSize],
                            ),
                          ),
                          subtitle: Text(
                            hero.inGameDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: constraintsValues[heroSubtitleRows],
                            style: TextStyle(
                              fontSize: constraintsValues[heroSubtitleFontSize],
                            ),
                          ),
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
