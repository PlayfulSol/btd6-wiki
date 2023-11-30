import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../../../utilities/global_state.dart';
import '/models/base/base_tower.dart';
import '/presentation/widgets/image_outline.dart';
import '/presentation/screens/tower/single_tower.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Towers extends StatefulWidget {
  const Towers({
    super.key,
    required this.towers,
  });

  final List<BaseTower> towers;

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers> {
  Map<String, dynamic> constraintsValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraints(constraints);
          return Consumer<GlobalState>(
            builder: (context, globalState, child) {
              List<BaseTower> filteredTowers = filterTowers(
                  widget.towers, globalState.currentOptionSelected[towers]!);
              return GridView.builder(
                itemCount: filteredTowers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraintsValues["crossAxisCount"],
                  childAspectRatio: constraintsValues["childAspectRatio"],
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: ListTile(
                        leading: ImageOutliner(
                          imageName: filteredTowers[index].image,
                          imagePath: towerImage(filteredTowers[index].image),
                        ),
                        title: AutoSizeText(
                          filteredTowers[index].name,
                          maxLines: 1,
                          style: titleStyle.copyWith(
                            fontSize: constraintsValues["titleFontSize"],
                          ),
                        ),
                        subtitle: AutoSizeText(
                          filteredTowers[index].inGameDesc,
                          wrapWords: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: constraintsValues["rowsToShow"],
                          style: subtitleStyle.copyWith(
                              fontSize: constraintsValues["subtitleFontSize"]),
                          minFontSize: constraintsValues["subtitleFontSize"],
                          maxFontSize: constraintsValues["subtitleFontSize"],
                        ),
                        onTap: () {
                          logPageView(filteredTowers[index].name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleTower(
                                towerId: filteredTowers[index].id,
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
          );
        },
      ),
    );
  }
}
