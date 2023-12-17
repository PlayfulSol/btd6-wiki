import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_hero.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Heroes extends StatelessWidget {
  const Heroes({
    super.key,
    required this.heroes,
  });

  final List<BaseHero> heroes;

  @override
  Widget build(BuildContext context) {
    final constraintsValues = calculateConstraints(
      kHeroes,
      MediaQuery.of(context).size,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logPageView(heroesPageConst);
    });

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
                    heroesFromSearch(heroes, globalState.currentQuery);
                return GridView.builder(
                  itemCount: filteredHeroes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraintsValues["crossAxisCount"],
                    childAspectRatio: constraintsValues["childAspectRatio"],
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
                              fontSize: constraintsValues["titleFontSize"],
                            ),
                          ),
                          subtitle: Text(
                            hero.inGameDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: constraintsValues["rowsToShow"],
                            style: TextStyle(
                              fontSize: constraintsValues["subtitleFontSize"],
                            ),
                          ),
                          onTap: () {
                            logPageView(hero.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleHero(heroId: hero.id),
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
