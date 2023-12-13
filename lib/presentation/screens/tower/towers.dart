import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_tower.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/search_widget.dart';
import '/presentation/widgets/image_outline.dart';
import '/analytics/analytics.dart';
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
    final constraintsValues = calculateConstraints(MediaQuery.of(context).size);

    return Scaffold(
      body: Column(
        children: [
          Consumer<GlobalState>(
            builder: (context, globalState, child) =>
                globalState.isSearchEnabled
                    ? const SearchBarWidget()
                    : Container(),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final filteredTowers = filterAndSearchTowers(
                  towers,
                  Provider.of<GlobalState>(context).currentQuery,
                  Provider.of<GlobalState>(context).currentOption,
                );

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
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: ImageOutliner(
                          imageName: tower.image,
                          imagePath: towerImage(tower.image),
                        ),
                        title: AutoSizeText(
                          tower.name,
                          maxLines: 1,
                          style: titleStyle.copyWith(
                            fontSize: constraintsValues["titleFontSize"],
                          ),
                        ),
                        subtitle: AutoSizeText(
                          tower.inGameDesc,
                          wrapWords: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: constraintsValues["rowsToShow"],
                          style: subtitleStyle.copyWith(
                            fontSize: constraintsValues["subtitleFontSize"],
                          ),
                          minFontSize: constraintsValues["subtitleFontSize"],
                          maxFontSize: constraintsValues["subtitleFontSize"],
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
