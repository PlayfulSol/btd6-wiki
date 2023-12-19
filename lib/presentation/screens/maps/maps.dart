import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_map.dart';
import '/presentation/screens/maps/single_map.dart';
import '/presentation/widgets/search_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';
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
      screenClass: kMainPageClass,
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
                child: Consumer<GlobalState>(
                  builder: (context, globalState, child) {
                    final filteredMaps = filterAndSearchMaps(widget.maps,
                        globalState.currentQuery, globalState.currentOption);
                    return GridView.builder(
                      itemCount: filteredMaps.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        mainAxisSpacing: 4,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              // logPageView(filteredMaps[index].name);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleMap(
                                    mapId: filteredMaps[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Image(
                                      semanticLabel: filteredMaps[index].name,
                                      image: AssetImage(
                                          mapImage(filteredMaps[index].image)),
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          capitalizeEveryWord(
                                              filteredMaps[index].name),
                                          maxLines: 1,
                                          style: bolderNormalStyle,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(filteredMaps[index].difficulty,
                                            style: subtitleStyle),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
