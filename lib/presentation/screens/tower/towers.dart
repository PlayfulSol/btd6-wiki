import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Towers extends StatelessWidget {
  const Towers({
    super.key,
    required this.towers,
  });

  final List<BaseTower> towers;

  @override
  Widget build(BuildContext context) {
    final constraintsValues =
        calculateConstraints(kTowers, MediaQuery.of(context).size);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logPageView(towersPageConst);
    });

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
                final filteredTowers = filterAndSearchTowers(towers,
                    globalState.currentQuery, globalState.currentOption);

                return GridView.builder(
                  itemCount: filteredTowers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraintsValues["crossAxisCount"],
                    childAspectRatio: constraintsValues["childAspectRatio"],
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
                          leading: ImageOutliner(
                            imageName: tower.image,
                            imagePath: towerImage(tower.image),
                          ),
                          title: Text(
                            tower.name,
                            style: titleStyle.copyWith(
                              fontSize: constraintsValues["titleFontSize"],
                            ),
                          ),
                          subtitle: Text(
                            tower.inGameDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: constraintsValues["rowsToShow"],
                            style: subtitleStyle.copyWith(
                              fontSize: constraintsValues["subtitleFontSize"],
                            ),
                          ),
                          onTap: () {
                            logPageView(tower.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleTower(towerId: tower.id),
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
