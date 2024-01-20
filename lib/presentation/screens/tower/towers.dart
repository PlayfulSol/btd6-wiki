import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Towers extends StatefulWidget {
  const Towers({
    super.key,
    required this.analyticsHelper,
    required this.towers,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseTower> towers;

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers> {
  @override
  void initState() {
    super.initState();

    widget.analyticsHelper.logScreenView(
      screenClass: kMainPagesClass,
      screenName: kTowers,
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
                final filteredTowers = filterAndSearchTowers(widget.towers,
                    globalState.currentQuery, globalState.currentOption);

                return GridView.builder(
                  itemCount: filteredTowers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraintsValues[towerCrossCount],
                    childAspectRatio: constraintsValues[towerAspectRatio],
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final tower = filteredTowers[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      child: Center(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          horizontalTitleGap: 8,
                          minVerticalPadding: -4,
                          leading: ImageOutliner(
                            imageName: tower.image,
                            imagePath: towerImage(tower.image),
                            width: constraintsValues[towerImageWidth],
                          ),
                          title: Text(
                            tower.name,
                            style: constraintsValues[towerTitleStyle],
                          ),
                          subtitle: Text(
                            tower.inGameDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: constraintsValues[towerSubtitleRows],
                            style: constraintsValues[towerSubtitleStyle],
                          ),
                          onTap: () {
                            widget.analyticsHelper.logEvent(
                              name: widgetEngagement,
                              parameters: {
                                'screen': kTowerPagesClass,
                                'widget': listTile,
                                'value': tower.id,
                              },
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleTower(
                                  towerId: tower.id,
                                  analyticsHelper: widget.analyticsHelper,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
