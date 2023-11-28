import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '/models/maps/map.dart';
import '/presentation/screens/maps/single_map.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class Maps extends StatefulWidget {
  const Maps({super.key, required String mapDifficulty});
  final String? mapDifficulty = '';

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late final TextEditingController _searchController;
  Map<String, dynamic> constraintsValues = {};
  List<MapModel> maps = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    maps = filterMaps(query);
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

  void _loadJsonData() async {
    GlobalState.maps.sort((a, b) =>
        GlobalState.mapDifficulties.indexOf(a.difficulty) -
        GlobalState.mapDifficulties.indexOf(b.difficulty));
  }

  String getPageTitle() {
    if (GlobalState.currentMapDifficulty != '') {
      return GlobalState.currentMapDifficulty;
    } else {
      return titles[GlobalState.currentPageIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalState.currentMapDifficulty != ''
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    GlobalState.currentMapDifficulty = '';
                  });
                  Navigator.pop(context);
                },
              ),
              title: Text(getPageTitle()),
              actions: [
                DropdownMenu<String>(
                  initialSelection: GlobalState.currentMapDifficulty,
                  width: 140,
                  onSelected: (String? newValue) {
                    setState(() {
                      GlobalState.currentMapDifficulty = newValue!;
                      GlobalState.currentTitle = newValue;
                    });
                  },
                  dropdownMenuEntries: GlobalState.mapDifficulties
                      .map<DropdownMenuEntry<String>>(
                    (String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    },
                  ).toList(),
                ),
              ],
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          maps = filterMaps(query);

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
              Expanded(
                child: GridView.builder(
                  primary: false,
                  itemCount: maps.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () async {
                          GlobalState.currentTitle = maps[index].name;
                          final singleMap = await rootBundle.loadString(
                              'assets/data/maps/${maps[index].id}.json');
                          final parsedMap = jsonDecode(singleMap);
                          logPageView(maps[index].name);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleMap(
                                map: MapModel.fromJson(parsedMap),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image(
                                  semanticLabel: maps[index].name,
                                  image:
                                      AssetImage(mapImage(maps[index].image)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      capitalizeEveryWord(maps[index].name),
                                      maxLines: 1,
                                      style: bolderNormalStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(maps[index].difficulty,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
