import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:auto_size_text/auto_size_text.dart';
import '/models/towers/tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/loader.dart';
import '/utilities/constants.dart';
import '/utilities/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class Towers extends StatefulWidget {
  const Towers({super.key, required String towerType});

  final String? towerType = '';

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers>
    with AutomaticKeepAliveClientMixin<Towers> {
  String getPageTitle() {
    if (GlobalState.currentTowerType != '') {
      return GlobalState.currentTowerType;
    } else {
      return titles[GlobalState.currentPageIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: GlobalState.currentTowerType != ''
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    GlobalState.currentTowerType = '';
                  });
                  Navigator.pop(context);
                },
              ),
              title: Text(getPageTitle()),
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
                int rowsToShow = 2;

                if (constraints.maxWidth < 450) {
                  crossAxisCount = 1;
                  titleFontSize = 18;
                  subtitleFontSize = 15;
                  cardHeight = 100;
                  rowsToShow = 2;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 2;
                  childAspectRatio = 1;
                  titleFontSize = 20;
                  subtitleFontSize = 16;
                  rowsToShow = 3;
                } else {
                  crossAxisCount = 3;
                  childAspectRatio = 0.75;
                  titleFontSize = 24;
                  subtitleFontSize = 18;
                  rowsToShow = 2;
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
                        elevation: 5,
                        shadowColor: Colors.black87,
                        child: ListTile(
                          mouseCursor: SystemMouseCursors.click,
                          dense: false,
                          isThreeLine: false,
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image(
                              image: AssetImage(
                                  towerImage(snapshot.data[index].image)),
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
                              maxLines: rowsToShow,
                              minFontSize: subtitleFontSize,
                              maxFontSize: subtitleFontSize),
                          onTap: () async {
                            if (!GlobalState.isLoading) {
                              GlobalState.currentTitle =
                                  snapshot.data[index].name;
                              var id = snapshot.data[index].id;
                              var path = '${towerDataPath + id}.json';
                              final data = await rootBundle.loadString(path);
                              var jsonData = json.decode(data);
                              logInnerPageView(snapshot.data[index].name);
                              SingleTowerModel towerData =
                                  SingleTowerModel.fromJson(jsonData);

                              // ignore: use_build_context_synchronously
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
