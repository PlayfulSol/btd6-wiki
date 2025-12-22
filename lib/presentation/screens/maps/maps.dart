import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_map.dart';
import '/presentation/widgets/misc/search_widget.dart';
import '/presentation/screens/maps/single_map.dart';
import '/presentation/widgets/maps/map_card.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import '/utilities/images_url.dart';
import '/utilities/strings.dart';

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
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    widget.maps.sort((a, b) =>
        mapDifficulties.indexOf(a.difficulty) -
        mapDifficulties.indexOf(b.difficulty));
  }

  @override
  Widget build(BuildContext context) {
    final constraintsValues = getPreset(
      MediaQuery.of(context).size,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final crossAxisCount = isMobile ? 1 : constraintsValues[mapCrossCount];
    
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Consumer<GlobalState>(
                builder: (context, globalState, child) {
                  return globalState.isSearchEnabled
                      ? SearchBarWidget(queryText: globalState.currentQuery)
                      : Container();
                },
              ),
              Expanded(
                child: Consumer2<GlobalState, FavoriteState>(
                  builder: (context, globalState, favoriteState, child) {
                    final filteredMaps = filterAndSearchMaps(widget.maps,
                        globalState.currentQuery, globalState.currentOption);
                    
                    if (isMobile) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredMaps.length,
                        itemBuilder: (context, index) {
                          BaseMap map = filteredMaps[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleMap(
                                        analyticsHelper: widget.analyticsHelper,
                                        mapId: map.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  favoriteState.toggleFavoriteFunc(
                                      context, favoriteState, map);
                                }
                              },
                              child: Consumer<FavoriteState>(
                                builder: (context, favoriteState, child) {
                                  return Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          child: Image(
                                            semanticLabel: map.name,
                                            image: AssetImage(mapImage(map.image)),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context, Object exception,
                                                StackTrace? stackTrace) {
                                              return const SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Icon(Icons.error),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        capitalizeEveryWord(map.name),
                                                        style: bolderNormalStyle,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        map.difficulty,
                                                        style: subtitleStyle,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  favoriteState.isFavorite(map.type, map.id)
                                                      ? Icons.star
                                                      : Icons.star_border_outlined,
                                                  size: 18,
                                                  color: favoriteState.isFavorite(
                                                          map.type, map.id)
                                                      ? Colors.amber
                                                      : null,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredMaps.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: constraintsValues[mapAspectRatio],
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        BaseMap map = filteredMaps[index];
                        return GestureDetector(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleMap(
                                      analyticsHelper: widget.analyticsHelper,
                                      mapId: map.id,
                                    ),
                                  ),
                                );
                              } else {
                                favoriteState.toggleFavoriteFunc(
                                    context, favoriteState, map);
                              }
                            },
                            child: MapCard(singleMap: map),
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
