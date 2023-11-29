import 'dart:convert';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/models/base/base_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '/models/maps/map.dart';
import '/presentation/screens/maps/single_map.dart';
import '/presentation/widgets/loader.dart';
import '/analytics/analytics.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

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
  String query = '';

  @override
  void initState() {
    super.initState();
    // _loadJsonData();
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

  // Future<void> _loadJsonData() async {
  //   widget.maps.sort((a, b) =>
  //       GlobalState.mapDifficulties.indexOf(a.difficulty) -
  //       GlobalState.mapDifficulties.indexOf(b.difficulty));
  // }

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      itemCount: widget.maps.length,
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
                              logPageView(widget.maps[index].name);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleMap(
                                    mapId: widget.maps[index].id,
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
                                      semanticLabel: widget.maps[index].name,
                                      image: AssetImage(
                                          mapImage(widget.maps[index].image)),
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
                                              widget.maps[index].name),
                                          maxLines: 1,
                                          style: bolderNormalStyle,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(widget.maps[index].difficulty,
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
