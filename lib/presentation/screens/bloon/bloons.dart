import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../widgets/bloons/bloons_grid.dart';
import '../../widgets/bloons/bosses_grid.dart';
import '/models/base_model.dart';
import '../../widgets/misc/search_widget.dart';
import '../../widgets/misc/image_outline.dart';
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
      screenClass: kMainPagesClass,
      screenName: kBloons,
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraintsValues = getPreset(
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
                            analyticsHelper: widget.analyticsHelper,
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
                            analyticsHelper: widget.analyticsHelper,
                            bossesList: filteredBosses,
                            constraintsValues: constraintsValues,
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
