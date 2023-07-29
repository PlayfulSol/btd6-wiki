import 'dart:convert';
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
  List<dynamic> _jsonData = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    final jsonData =
        await rootBundle.loadString('assets/data/maps/balance.json');
    final parsedData = jsonDecode(jsonData);
    final anotherMap =
        await rootBundle.loadString('assets/data/maps/bazaar.json');
    final anotherParsedMap = jsonDecode(anotherMap);
    setState(() {
      _jsonData = [parsedData, anotherParsedMap];
    });

    // final files = getFilesInFolder('assets/data/maps');

    // final jsonData = await Future.wait(
    //   files.map((file) async {
    //     final contents = await (file as File).readAsString();
    //     return json.decode(contents);
    //   }),
    // );

    // setState(() {
    //   _jsonData = jsonData;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items in a row
        crossAxisSpacing: 8, // Spacing between items horizontally
        mainAxisSpacing: 8, // Spacing between items vertically
      ),
      itemCount: _jsonData.length,
      itemBuilder: (context, index) {
        final data = _jsonData[index];
        return GestureDetector(
          onTap: () {
            GlobalState.currentTitle = data['name'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleMap(
                  map: _jsonData[index],
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
                    image: AssetImage(mapImage(data['image'])),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(data['difficulty'],
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
