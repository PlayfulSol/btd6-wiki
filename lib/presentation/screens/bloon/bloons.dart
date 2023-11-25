import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/boss_bloon.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/../analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class Bloons extends StatefulWidget {
  const Bloons({super.key});

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(children: [
        const Text(
          "Bloons",
          style: bigTitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        GridView.builder(
            itemCount: GlobalState.bloons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisExtent: 80,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Center(
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black87,
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    minVerticalPadding: 25,
                    contentPadding: const EdgeInsets.only(left: 10),
                    horizontalTitleGap: 10,
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image(
                        semanticLabel: GlobalState.bloons[index].name,
                        image: AssetImage(
                          bloonImage(GlobalState.bloons[index].image),
                        ),
                      ),
                    ),
                    title: Text(
                      GlobalState.bloons[index].name,
                      style: bolderNormalStyle,
                    ),
                    onTap: () async {
                      if (!GlobalState.isLoading) {
                        var id = GlobalState.bloons[index].id;
                        var path = '${bloonsDataPath + id}.json';
                        final data = await rootBundle.loadString(path);
                        var jsonData = json.decode(data);
                        logInnerPageView(GlobalState.bloons[index].name);
                        SingleBloonModel bloonData =
                            SingleBloonModel.fromJson(jsonData);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleBloon(bloon: bloonData),
                          ),
                        );
                        GlobalState.currentTitle = bloonData.name;
                      }
                    },
                  ),
                ),
              );
            }),
        const SizedBox(height: 30),
        const Text(
          "Bosses",
          style: bigTitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            itemCount: GlobalState.bosses.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image(
                      semanticLabel: GlobalState.bosses[index].name,
                      image: AssetImage(
                        bossImage(GlobalState.bosses[index].image),
                      ),
                    ),
                  ),
                  title: Text(
                    GlobalState.bosses[index].name,
                    style: bolderNormalStyle,
                  ),
                  onTap: () async {
                    if (!GlobalState.isLoading) {
                      var id = GlobalState.bosses[index].id;
                      var path = '${bossesDataPath + id}.json';
                      final data = await rootBundle.loadString(path);
                      var jsonData = json.decode(data);
                      logInnerPageView(GlobalState.bosses[index].name);
                      BossBloonModel bossData =
                          BossBloonModel.fromJson(jsonData);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BossBloon(bloon: bossData),
                        ),
                      );
                      GlobalState.currentTitle = bossData.name;
                    }
                  },
                ),
              );
            })
      ]),
    ));
  }
}
