import 'package:btd6wiki/utilities/analytics.dart';
import 'package:btd6wiki/models/bloons/boss_bloon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import '/models/bloons/single_bloon.dart';

import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/presentation/widgets/loader.dart';

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
      child: ListView(primary: false, children: [
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
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Center(
                child: Card(
                  child: ListTile(
                    mouseCursor: SystemMouseCursors.click,
                    minVerticalPadding: 25,
                    contentPadding: const EdgeInsets.only(left: 10),
                    horizontalTitleGap: 10,
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image(
                        image: AssetImage(
                          bloonImage(GlobalState.bloons[index].image),
                        ),
                      ),
                    ),
                    title: Text(
                      GlobalState.bloons[index].name,
                      style: normalStyle.copyWith(fontWeight: FontWeight.w600),
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
        FutureBuilder(
          future: Future.value(GlobalState.bosses),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Loader();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        mouseCursor: SystemMouseCursors.click,
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image(
                            image: AssetImage(
                              bossImage(snapshot.data[index].image),
                            ),
                          ),
                        ),
                        title: Text(
                          snapshot.data[index].name,
                          style:
                              normalStyle.copyWith(fontWeight: FontWeight.w600),
                        ),
                        onTap: () async {
                          if (!GlobalState.isLoading) {
                            var id = snapshot.data[index].id;
                            var path = '${bossesDataPath + id}.json';
                            final data = await rootBundle.loadString(path);
                            var jsonData = json.decode(data);
                            logInnerPageView(snapshot.data[index].name);
                            BossBloonModel bossData =
                                BossBloonModel.fromJson(jsonData);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BossBloon(bloon: bossData),
                              ),
                            );
                            GlobalState.currentTitle = bossData.name;
                          }
                        },
                      ),
                    );
                  });
            }
          },
        ),
      ]),
    ));
  }
}
