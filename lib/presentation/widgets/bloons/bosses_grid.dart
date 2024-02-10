import 'package:btd6wiki/utilities/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/models/base_model.dart';
import '/presentation/widgets/misc/image_outline.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class BossesGrid extends StatelessWidget {
  const BossesGrid({
    super.key,
    required this.analyticsHelper,
    required this.bossesList,
    required this.constraintsValues,
  });
  final AnalyticsHelper analyticsHelper;
  final List<BaseModel> bossesList;
  final Map<String, dynamic> constraintsValues;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraintsValues[bossCrossCount],
        childAspectRatio: constraintsValues[bossAspectRatio],
      ),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: bossesList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final boss = bossesList[index];
        return Consumer<FavoriteState>(
          builder: (context, favoriteState, child) {
            return InkWell(
              onLongPress: () =>
                  toggleFavoriteFunc(context, favoriteState, boss),
              onTap: () {
                analyticsHelper.logEvent(
                  name: widgetEngagement,
                  parameters: {
                    'screen': kBossPagesClass,
                    'widget': listTile,
                    'value': boss.id,
                  },
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BossBloon(
                      analyticsHelper: analyticsHelper,
                      bossId: boss.id,
                    ),
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    leading: ImageOutliner(
                      imageName: boss.image,
                      imagePath: bossImage(boss.image),
                    ),
                    title: Text(
                      boss.name,
                      style: constraintsValues[bossTitleStyle],
                    ),
                    trailing: favoriteState.isFavorite(boss.type, boss.id)
                        ? const Icon(Icons.star)
                        : const Icon(Icons.star_border_outlined),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
