import 'package:btd6wiki/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/analytics/analytics.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import 'boss_bloon.dart';
import 'single_bloon.dart';

class Bloons extends StatefulWidget {
  const Bloons({
    super.key,
    required this.bloonsList,
    required this.bossesList,
  });

  final List<BaseModel> bloonsList;
  final List<BaseModel> bossesList;

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  Map<String, dynamic> constraintsValues = {};
  List<BaseModel> filteredBloons = [];
  List<BaseModel> filteredBosses = [];
  bool showBloons = true;
  bool showBosses = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraintsBloons(constraints);
          return Column(
            children: [
              Consumer<GlobalState>(
                builder: (context, globalState, child) {
                  return globalState.isSearchEnabled
                      ? const SearchBarWidget()
                      : Container();
                },
              ),
              Expanded(
                child: Consumer<GlobalState>(
                  builder: (context, globalState, child) {
                    filteredBloons = filterAndSearchBloons(widget.bloonsList,
                        globalState.currentQuery, globalState.currentOption);

                    filteredBosses = filterAndSearchBloons(widget.bossesList,
                        globalState.currentQuery, globalState.currentOption);

                    if (globalState.currentOption.toLowerCase() == kBloons ||
                        globalState.currentOption.toLowerCase() == kBlimps) {
                      showBosses = false;
                      showBloons = true;
                    } else if (globalState.currentOption.toLowerCase() ==
                        kBosses) {
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
                                    bossesList: filteredBosses,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
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

class BossesGrid extends StatefulWidget {
  const BossesGrid({
    super.key,
    required this.constraintsValues,
    required this.bossesList,
  });

  final Map<String, dynamic> constraintsValues;
  final List<BaseModel> bossesList;

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
      itemCount: widget.bossesList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.5),
          child: Center(
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              leading: ImageOutliner(
                imageName: widget.bossesList[index].image,
                imagePath: bossImage(widget.bossesList[index].image),
              ),
              title: Text(
                widget.bossesList[index].name,
                style: widget.constraintsValues["textStyleBoss"],
              ),
              onTap: () {
                logPageView(widget.bossesList[index].name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BossBloon(bossId: widget.bossesList[index].id),
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
