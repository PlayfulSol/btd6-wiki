import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/models/base/base_map.dart';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:btd6wiki/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/presentation/screens/maps/single_map.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';
import '/utilities/images_url.dart';

class Maps extends StatefulWidget {
  const Maps({
    super.key,
    required this.maps,
  });

  final List<BaseMap> maps;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late final TextEditingController _searchController;
  late List<BaseMap> filteredMaps;
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    filteredMaps =
        filterMaps(widget.maps, globalState.currentOptionSelected[maps]!);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      logEvent('search', 'searching for map ${_searchController.text}');
      setState(() {
        query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search maps',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<GlobalState>(
                  builder: (context, globalState, child) {
                    filteredMaps = filterMaps(
                        widget.maps, globalState.currentOptionSelected[maps]!);
                    filteredMaps = mapsFromSearch(filteredMaps, query);
                    return GridView.builder(
                      itemCount: filteredMaps.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              logPageView(filteredMaps[index].name);

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
