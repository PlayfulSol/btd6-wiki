import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/image_outline.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/boss_bloon.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Bloons extends StatefulWidget {
  const Bloons({super.key});

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  Map<String, dynamic> constraintsValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraintsBloons(constraints);

          return ListView(
            children: [
              const Text(
                "Bloons",
                style: bigTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              GridView.builder(
                  itemCount: GlobalState.bloons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraintsValues["crossAxisCount"],
                    childAspectRatio: constraintsValues["childAspectRatio"],
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 7),
                          horizontalTitleGap: 10,
                          leading: ImageOutliner(
                            imageName: GlobalState.bloons[index].image,
                            imagePath:
                                bloonImage(GlobalState.bloons[index].image),
                          ),
                          title: Text(
                            GlobalState.bloons[index].name,
                            style: smallTitleStyle,
                          ),
                          onTap: () async {
                            if (!GlobalState.isLoading) {
                              var id = GlobalState.bloons[index].id;
                              var path = '${bloonsDataPath + id}.json';
                              final data = await rootBundle.loadString(path);
                              var jsonData = json.decode(data);
                              logPageView(GlobalState.bloons[index].name);
                              SingleBloonModel bloonData =
                                  SingleBloonModel.fromJson(jsonData);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleBloon(bloon: bloonData),
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
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraintsValues["crossAxisCountBoss"],
                  childAspectRatio: constraintsValues["childAspectRatioBoss"],
                ),
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                itemCount: GlobalState.bosses.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.5),
                    child: Center(
                      child: ListTile(
                        mouseCursor: SystemMouseCursors.click,
                        leading: ImageOutliner(
                          imageName: GlobalState.bosses[index].image,
                          imagePath: bossImage(GlobalState.bosses[index].image),
                        ),
                        title: Text(
                          GlobalState.bosses[index].name,
                          style: smallTitleStyle,
                        ),
                        onTap: () async {
                          if (!GlobalState.isLoading) {
                            var id = GlobalState.bosses[index].id;
                            var path = '${bossesDataPath + id}.json';
                            final data = await rootBundle.loadString(path);
                            var jsonData = json.decode(data);
                            logPageView(GlobalState.bosses[index].name);
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
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
