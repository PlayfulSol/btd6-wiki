import 'dart:convert';
import 'package:btd6wiki/models/map.dart';
import 'package:btd6wiki/presentation/screens/maps/single_map.dart';
import 'package:btd6wiki/utilities/global_state.dart';
import 'package:btd6wiki/utilities/images_url.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class Maps extends StatefulWidget {
  const Maps({required Key key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<MapModel> _jsonData = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    final jsonConfig =
        await rootBundle.loadString('assets/data/config/maps.json');
    final List<dynamic> parsedConfig = json.decode(jsonConfig);

    setState(() {
      _jsonData = parsedConfig.map((map) => MapModel.fromJson(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _jsonData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items in a row
                crossAxisSpacing: 8, // Spacing between items horizontally
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
              itemCount: _jsonData.length,
              itemBuilder: (context, index) {
                final data = _jsonData[index];
                return GestureDetector(
                  onTap: () async {
                    GlobalState.currentTitle = data.name;
                    final singleMap = await rootBundle
                        .loadString('assets/data/maps/${data.name}.json');
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image(
                            image: AssetImage(mapImage(data.image)),
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Text(data.difficulty,
                                  style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
