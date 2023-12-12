import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '/models/base/base_hero.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/utils.dart';
import '/utilities/constants.dart';
import '/utilities/images_url.dart';

class Heroes extends StatefulWidget {
  const Heroes({
    super.key,
    required this.heroes,
  });

  final List<BaseHero> heroes;

  @override
  State<Heroes> createState() => _HeroesState();
}

class _HeroesState extends State<Heroes> {
  Map<String, dynamic> constraintsValues = {};
  List<BaseHero> filteredHeroes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraints(constraints);
          return Column(
            children: [
              Consumer<GlobalState>(
                builder: (context, globalState, child) {
                  return globalState.isSearchEnabled
                      ? const SearchBarWidget()
                      : Container();
                },
              ),
              Expanded(
                child: Consumer<GlobalState>(
                  builder: (context, globalState, child) {
                    filteredHeroes = heroesFromSearch(
                        widget.heroes, globalState.currentQuery);
                    return GridView.builder(
                      itemCount: filteredHeroes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraintsValues["crossAxisCount"],
                        childAspectRatio: constraintsValues["childAspectRatio"],
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: ListTile(
                              mouseCursor: SystemMouseCursors.click,
                              leading: ImageOutliner(
                                imageName: filteredHeroes[index].image,
                                imagePath:
                                    heroImage(filteredHeroes[index].image),
                              ),
                              title: AutoSizeText(filteredHeroes[index].name,
                                  wrapWords: false,
                                  style: titleStyle.copyWith(
                                      fontSize:
                                          constraintsValues["titleFontSize"])),
                              subtitle: AutoSizeText(
                                filteredHeroes[index].inGameDesc,
                                overflow: TextOverflow.ellipsis,
                                maxLines: constraintsValues["rowsToShow"],
                                minFontSize:
                                    constraintsValues["subtitleFontSize"],
                                maxFontSize:
                                    constraintsValues["subtitleFontSize"],
                                wrapWords: false,
                                style: TextStyle(
                                    fontSize:
                                        constraintsValues["subtitleFontSize"]),
                              ),
                              onTap: () {
                                logPageView(filteredHeroes[index].name);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SingleHero(
                                        heroId: filteredHeroes[index].id,
                                      );
                                    },
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
          );
        },
      ),
    );
  }
}
