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

  @override
  Widget build(BuildContext context) {
    final constraintsValues = getPreset(
      MediaQuery.of(context).size,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final crossAxisCount = isMobile ? 1 : constraintsValues[towerCrossCount];

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

                if (isMobile) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredTowers.length,
                    itemBuilder: (context, index) {
                      final tower = filteredTowers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
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
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ImageOutliner(
                                      imageName: tower.image,
                                      imagePath: towerImage(tower.image),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            tower.name,
                                            style: constraintsValues[
                                                towerTitleStyle],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          favoriteState.isFavorite(
                                                  tower.type, tower.id)
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          size: 18,
                                          color: favoriteState.isFavorite(
                                                  tower.type, tower.id)
                                              ? Colors.amber
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredTowers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final tower = filteredTowers[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
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
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ImageOutliner(
                                      imageName: tower.image,
                                      imagePath: towerImage(tower.image),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            tower.name,
                                            style: constraintsValues[
                                                towerTitleStyle],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          favoriteState.isFavorite(
                                                  tower.type, tower.id)
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          size: 18,
                                          color: favoriteState.isFavorite(
                                                  tower.type, tower.id)
                                              ? Colors.amber
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
