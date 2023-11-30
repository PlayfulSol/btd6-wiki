import 'package:btd6wiki/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../analytics/analytics.dart';
import '../../../utilities/global_state.dart';
import '/presentation/widgets/image_outline.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import 'single_bloon.dart';

class Bloons extends StatefulWidget {
  const Bloons({
    super.key,
    required this.bloons,
    required this.bosses,
  });

  final List<BaseModel> bloons;
  final List<BaseModel> bosses;

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  Map<String, dynamic> constraintsValues = {};
  bool showBloons = true;
  bool showBosses = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraintsBloons(constraints);
          return Consumer<GlobalState>(
            builder: (context, globalState, child) {
              List<BaseModel> filteredBloons = widget.bloons;
              if (globalState.currentOptionSelected[bloons]!.toLowerCase() ==
                      bloons ||
                  globalState.currentOptionSelected[bloons]!.toLowerCase() ==
                      blimps) {
                filteredBloons = filterbloons(
                    filteredBloons, globalState.currentOptionSelected[bloons]!);
                showBosses = false;
                showBloons = true;
              } else if (globalState.currentOptionSelected[bloons]!
                      .toLowerCase() ==
                  bosses) {
                showBloons = false;
                showBosses = true;
              } else {
                showBloons = true;
                showBosses = true;
              }
              return ListView(
                children: [
                  showBloons
                      ? Column(
                          children: [
                            const Text(
                              "Bloons",
                              style: bigTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            BloonsGrid(
                              bloons: filteredBloons,
                              constraintsValues: constraintsValues,
                            ),
                            const SizedBox(height: 30),
                          ],
                        )
                      : Container(),
                  showBosses
                      ? Column(
                          children: [
                            const Text(
                              "Bosses",
                              style: bigTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            BossesGrid(
                              constraintsValues: constraintsValues,
                              widget: widget,
                            ),
                          ],
                        )
                      : Container(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class BossesGrid extends StatefulWidget {
  const BossesGrid({
    super.key,
    required this.constraintsValues,
    required this.widget,
  });

  final Map<String, dynamic> constraintsValues;
  final Bloons widget;

  @override
  State<BossesGrid> createState() => _BossesGridState();
}

class _BossesGridState extends State<BossesGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.constraintsValues["crossAxisCountBoss"],
        childAspectRatio: widget.constraintsValues["childAspectRatioBoss"],
      ),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: widget.widget.bosses.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.5),
          child: Center(
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              leading: ImageOutliner(
                imageName: widget.widget.bosses[index].image,
                imagePath: bossImage(widget.widget.bosses[index].image),
              ),
              title: Text(
                widget.widget.bosses[index].name,
                style: widget.constraintsValues["textStyleBoss"],
              ),
              onTap: () async {
                // if (!GlobalState.isLoading) {
                //   var id = GlobalState.bosses[index].id;
                //   var path = '${bossesDataPath + id}.json';
                //   final data = await rootBundle.loadString(path);
                //   var jsonData = json.decode(data);
                //   logPageView(GlobalState.bosses[index].name);
                //   BossBloonModel bossData =
                //       BossBloonModel.fromJson(jsonData);
                //   // ignore: use_build_context_synchronously
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           BossBloon(bloon: bossData),
                //     ),
                //   );
                //   GlobalState.currentTitle = bossData.name;
                // }
              },
            ),
          ),
        );
      },
    );
  }
}

class BloonsGrid extends StatefulWidget {
  const BloonsGrid({
    super.key,
    required this.bloons,
    required this.constraintsValues,
  });

  final List<BaseModel> bloons;
  final Map<String, dynamic> constraintsValues;

  @override
  State<BloonsGrid> createState() => _BloonsGridState();
}

class _BloonsGridState extends State<BloonsGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.bloons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.constraintsValues["crossAxisCount"],
        childAspectRatio: widget.constraintsValues["childAspectRatio"],
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 7,
          ),
          child: Center(
            child: ListTile(
              horizontalTitleGap: 10,
              leading: ImageOutliner(
                imageName: widget.bloons[index].image,
                imagePath: bloonImage(widget.bloons[index].image),
                width: widget.constraintsValues["imageWidth"],
              ),
              title: Text(
                widget.bloons[index].name,
                maxLines: 1,
                style: smallTitleStyle.copyWith(
                  fontSize: widget.constraintsValues["titleFontSize"],
                ),
              ),
              onTap: () {
                logPageView(widget.bloons[index].name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SingleBloon(bloonId: widget.bloons[index].id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
