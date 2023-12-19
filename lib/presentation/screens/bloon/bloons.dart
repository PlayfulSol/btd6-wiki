import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base_model.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import 'single_bloon.dart';
import 'boss_bloon.dart';

class Bloons extends StatefulWidget {
  const Bloons({
    super.key,
    required this.analyticsHelper,
    required this.bloonsList,
    required this.bossesList,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseModel> bloonsList;
  final List<BaseModel> bossesList;

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kMainPageClass,
      screenName: kBloons,
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraintsValues = selectSizePreset(
      kBloons,
      MediaQuery.of(context).size,
    );
    return Scaffold(
      body: Column(
        children: [
          Consumer<GlobalState>(
            builder: (context, globalState, child) =>
                globalState.isSearchEnabled
                    ? SearchBarWidget(queryText: globalState.currentQuery)
                    : Container(),
          ),
          Expanded(
            child: Consumer<GlobalState>(
              builder: (context, globalState, child) {
                final filteredBloons = filterAndSearchBloons(
                  widget.bloonsList,
                  globalState.currentQuery,
                  globalState.currentOption,
                );

                final filteredBosses = filterAndSearchBloons(
                  widget.bossesList,
                  globalState.currentQuery,
                  globalState.currentOption,
                );

                bool showBloons = true;
                bool showBosses = true;

                if (globalState.currentOption.toLowerCase() == kBloons ||
                    globalState.currentOption.toLowerCase() == kBlimps) {
                  showBosses = false;
                  showBloons = true;
                } else if (globalState.currentOption.toLowerCase() == kBosses) {
                  showBloons = false;
                  showBosses = true;
                }

                return ListView(
                  children: [
                    if (showBloons)
                      Column(
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
                      ),
                    if (showBosses)
                      Column(
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
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BloonsGrid extends StatelessWidget {
  const BloonsGrid({
    super.key,
    required this.bloons,
    required this.constraintsValues,
  });

  final List<BaseModel> bloons;
  final Map<String, dynamic> constraintsValues;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: bloons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraintsValues["crossAxisCount"],
        childAspectRatio: constraintsValues["childAspectRatio"],
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final bloon = bloons[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 7,
          ),
          child: Center(
            child: ListTile(
              horizontalTitleGap: 10,
              leading: ImageOutliner(
                imageName: bloon.image,
                imagePath: bloonImage(bloon.image),
                width: constraintsValues["imageWidth"],
              ),
              title: Text(
                bloon.name,
                maxLines: 1,
                style: smallTitleStyle.copyWith(
                  fontSize: constraintsValues["titleFontSize"],
                ),
              ),
              onTap: () {
                // logPageView(bloon.name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleBloon(bloonId: bloon.id),
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

class BossesGrid extends StatelessWidget {
  const BossesGrid({
    super.key,
    required this.constraintsValues,
    required this.bossesList,
  });

  final Map<String, dynamic> constraintsValues;
  final List<BaseModel> bossesList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraintsValues["crossAxisCountBoss"],
        childAspectRatio: constraintsValues["childAspectRatioBoss"],
      ),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: bossesList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final boss = bossesList[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Center(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: ImageOutliner(
                imageName: boss.image,
                imagePath: bossImage(boss.image),
              ),
              title: Text(
                boss.name,
                style: constraintsValues["textStyleBoss"],
              ),
              onTap: () {
                // logPageView(boss.name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BossBloon(bossId: boss.id),
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
