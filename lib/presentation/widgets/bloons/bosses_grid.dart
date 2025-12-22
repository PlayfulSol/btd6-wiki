import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/models/base_model.dart';
import '/presentation/widgets/common/image_outline.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final crossAxisCount = isMobile ? 1 : constraintsValues[bossCrossCount];
    
    if (isMobile) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: bossesList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final boss = bossesList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Consumer<FavoriteState>(
              builder: (context, favoriteState, child) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onLongPress: () => favoriteState.toggleFavoriteFunc(
                      context, favoriteState, boss),
                  onTap: () {
                    if (!favoriteState.isMultiSelectMode) {
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
                    } else {
                      favoriteState.toggleFavoriteFunc(
                          context, favoriteState, boss);
                    }
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ImageOutliner(
                              imageName: boss.image,
                              imagePath: bossImage(boss.image),
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    boss.name,
                                    style: constraintsValues[bossTitleStyle],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  favoriteState.isFavorite(boss.type, boss.id)
                                      ? Icons.star
                                      : Icons.star_border_outlined,
                                  size: 18,
                                  color: favoriteState.isFavorite(
                                          boss.type, boss.id)
                                      ? Colors.amber
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
              borderRadius: BorderRadius.circular(12),
              onLongPress: () => favoriteState.toggleFavoriteFunc(
                  context, favoriteState, boss),
              onTap: () {
                if (!favoriteState.isMultiSelectMode) {
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
                } else {
                  favoriteState.toggleFavoriteFunc(
                      context, favoriteState, boss);
                }
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.2),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ImageOutliner(
                              imageName: boss.image,
                              imagePath: bossImage(boss.image),
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                boss.name,
                                style: constraintsValues[bossTitleStyle],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              favoriteState.isFavorite(boss.type, boss.id)
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              size: 18,
                              color: favoriteState.isFavorite(
                                      boss.type, boss.id)
                                  ? Colors.amber
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
