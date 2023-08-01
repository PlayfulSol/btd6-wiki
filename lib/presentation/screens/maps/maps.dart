import 'dart:convert';
import 'package:btd6wiki/models/map.dart';
import 'package:btd6wiki/presentation/screens/maps/single_map.dart';
import 'package:btd6wiki/presentation/widgets/loader.dart';
import 'package:btd6wiki/utilities/extensions.dart';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:btd6wiki/utilities/images_url.dart';
import 'package:btd6wiki/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class Maps extends StatefulWidget {
  const Maps({required Key key, required String mapDifficulty})
      : super(key: key);
  final String? mapDifficulty = '';

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late final TextEditingController _searchController;
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    _searchController = TextEditingController();
    _searchController.addListener(() {
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
    // TODO: remove this after fixing the json file
    GlobalState.maps.removeWhere((map) => map.name == 'park path');

    GlobalState.maps.sort((a, b) =>
        GlobalState.mapDifficulties.indexOf(a.difficulty) -
        GlobalState.mapDifficulties.indexOf(b.difficulty));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalState.currentMapDifficulty != ''
          ? AppBar(
              title: Text(GlobalState.currentTitle),
              actions: [
                DropdownButton<String>(
                  value: GlobalState.currentMapDifficulty,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      GlobalState.currentMapDifficulty = newValue!;
                      GlobalState.currentTitle = newValue;
                    });
                  },
                  items: GlobalState.mapDifficulties
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.blue)),
                    );
                  }).toList(),
                ),
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.value(filterMaps(query)),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Loader();
            } else {
              return Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search maps',
                    ),
                    onChanged: (value) {
                      // TODO: Implement search functionality
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                GlobalState.currentTitle =
                                    snapshot.data[index].name;
                                final singleMap = await rootBundle.loadString(
                                    'assets/data/maps/${snapshot.data[index].id}.json');
                                final parsedMap = jsonDecode(singleMap);
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage(mapImage(
                                            snapshot.data[index].image)),
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
                                          Text(
                                            capitalizeEveryWord(
                                                snapshot.data[index].name),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(snapshot.data[index].difficulty,
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
