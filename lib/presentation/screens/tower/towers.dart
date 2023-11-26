import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:auto_size_text/auto_size_text.dart';
import '../../widgets/image_outline.dart';
import '/models/towers/tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/loader.dart';
import '/utilities/constants.dart';
import '/../analytics/analytics.dart';
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
    Map<String, dynamic> constraintsValues;
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
      body: LayoutBuilder(builder: (context, constraints) {
        constraintsValues = calculateConstraints(constraints);
        return GridView.builder(
            itemCount: GlobalState.towers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraintsValues["crossAxisCount"],
              childAspectRatio: constraintsValues["childAspectRatio"],
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              // mainAxisExtent: constraintsValues["cardHeight"],
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.green,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    leading: ImageOutliner(
                        imageName: GlobalState.towers[index].image),
                    title: AutoSizeText(
                      GlobalState.towers[index].name,
                      maxLines: 1,
                      style: titleStyle.copyWith(
                          fontSize: constraintsValues["titleFontSize"]),
                    ),
                    subtitle: Container(
                      color: Colors.orange,
                      child: AutoSizeText(
                        GlobalState.towers[index].inGameDesc,
                        wrapWords: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: constraintsValues["rowsToShow"],
                        style: subtitleStyle.copyWith(
                            fontSize: constraintsValues["subtitleFontSize"]),
                        minFontSize: constraintsValues["subtitleFontSize"],
                        maxFontSize: constraintsValues["subtitleFontSize"],
                      ),
                    ),
                    onTap: () async {
                      if (!GlobalState.isLoading) {
                        GlobalState.currentTitle =
                            GlobalState.towers[index].name;
                        var id = GlobalState.towers[index].id;
                        var path = '${towerDataPath + id}.json';
                        final data = await rootBundle.loadString(path);
                        var jsonData = json.decode(data);
                        logInnerPageView(GlobalState.towers[index].name);
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
                ),
              );
            });
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
