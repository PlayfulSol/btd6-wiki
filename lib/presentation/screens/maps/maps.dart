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
                    return GridView.builder(
                      itemCount: filteredMaps.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraintsValues[mapCrossCount],
                        childAspectRatio: constraintsValues[mapAspectRatio],
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        BaseMap map = filteredMaps[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onLongPress: () =>
                                toggleFavoriteFunc(context, favoriteState, map),
                            onTap: () {
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
                            },
                            child: MapCard(singleMap: map),
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
