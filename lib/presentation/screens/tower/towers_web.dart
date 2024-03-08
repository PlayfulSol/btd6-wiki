import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/utilities/strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/presentation/widgets/common/image_outline.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class TowersWeb extends StatefulWidget {
  const TowersWeb({
    super.key,
    required this.analyticsHelper,
    required this.towers,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseTower> towers;

  @override
  State<TowersWeb> createState() => _TowersState();
}

class _TowersState extends State<TowersWeb> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kTowers,
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
                final filteredTowers = filterAndSearchTowers(widget.towers,
                    globalState.currentQuery, globalState.currentOption);

                return Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      itemCount: filteredTowers.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 40,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final tower = filteredTowers[index];

                        return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onLongPress: () => favoriteState.toggleFavoriteFunc(
                                context, favoriteState, tower),
                            onTap: () {
                              if (!favoriteState.isMultiSelectMode) {
                                widget.analyticsHelper.logEvent(
                                  name: widgetEngagement,
                                  parameters: {
                                    'screen': kTowerPagesClass,
                                    'widget': listTile,
                                    'value': tower.id,
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleTower(
                                      towerId: tower.id,
                                      analyticsHelper: widget.analyticsHelper,
                                    ),
                                  ),
                                );
                              } else {
                                favoriteState.toggleFavoriteFunc(
                                    context, favoriteState, tower);
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
                                        semanticLabel: tower.name,
                                        image:
                                            AssetImage(towerImage(tower.image)),
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
                                        capitalizeEveryWord(tower.name),
                                        maxLines: 1,
                                        style: titleStyle,
                                      ),
                                      subtitle: AutoSizeText(
                                        tower.inGameDesc,
                                        maxLines: 1,
                                        style: normalStyle,
                                        minFontSize: 15,
                                      ),
                                      trailing: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () =>
                                              favoriteState.toggleFavoriteFunc(
                                                  context,
                                                  favoriteState,
                                                  tower),
                                          child: favoriteState.isFavorite(
                                                  tower.type, tower.id)
                                              ? const Icon(Icons.star)
                                              : const Icon(
                                                  Icons.star_border_outlined),
                                        ),
                                      )),
                                ],
                              ),
                            ));
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
