import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/utilities/constants.dart';

import '../../../models/tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/loader.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class Towers extends StatefulWidget {
  const Towers({super.key, required String towerType});

  final String? towerTypes = '';

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers>
    with AutomaticKeepAliveClientMixin<Towers> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // if tower type is not empty show app bar
      appBar: GlobalState.currentTowerType != ''
          ? AppBar(
              title: Text(GlobalState.currentTitle),
              actions: [
                DropdownButton<String>(
                  value: GlobalState.currentTowerType,
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
                      GlobalState.currentTowerType = newValue!;
                      GlobalState.currentTitle = newValue;
                    });
                  },
                  items: GlobalState.towerTypes
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
          future: Future.value(filterTowers()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Loader();
            } else {
              return LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = 2;
                double childAspectRatio = 1.5;
                double cardHeight = 130;
                double titleFontSize = 15;
                double subtitleFontSize = 13;

                if (constraints.maxWidth < 450) {
                  crossAxisCount = 1;
                  titleFontSize = 18;
                  subtitleFontSize = 15;
                  cardHeight = 100;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 2;
                  childAspectRatio = 1;
                  titleFontSize = 20;
                  subtitleFontSize = 16;
                } else {
                  crossAxisCount = 3;
                  childAspectRatio = 0.75;
                  titleFontSize = 24;
                  subtitleFontSize = 18;
                }

                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      mainAxisExtent: cardHeight,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          mouseCursor: SystemMouseCursors.click,
                          dense: false,
                          isThreeLine: true,
                          leading: SizedBox(
                            height: double.infinity,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image(
                                image: AssetImage(
                                    towerImage(snapshot.data[index].image)),
                              ),
                            ),
                          ),
                          title: AutoSizeText(
                            snapshot.data[index].name,
                            maxLines: 1,
                            style: TextStyle(fontSize: titleFontSize),
                          ),
                          subtitle: AutoSizeText(
                              snapshot.data[index].inGameDesc,
                              wrapWords: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(fontSize: subtitleFontSize)),
                          onTap: () async {
                            if (!GlobalState.isLoading) {
                              var id = snapshot.data[index].id;
                              var path = '${towerDataPath + id}.json';
                              final data = await rootBundle.loadString(path);
                              var jsonData = json.decode(data);
                              SingleTowerModel towerData =
                                  SingleTowerModel.fromJson(jsonData);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleTower(towerData: towerData),
                                ),
                              );
                              GlobalState.currentTitle = towerData.name;
                            }
                          },
                        ),
                      );
                    });
              });
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
