import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/base_model.dart';
import '/presentation/widgets/common/image_outline.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class BloonsGrid extends StatelessWidget {
  const BloonsGrid({
    super.key,
    required this.analyticsHelper,
    required this.bloons,
    required this.constraintsValues,
  });

  final AnalyticsHelper analyticsHelper;
  final List<BaseModel> bloons;
  final Map<String, dynamic> constraintsValues;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;
    final crossAxisCount = isMobile ? 1 : constraintsValues[bloonCrossCount];
    
    if (isMobile) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: bloons.length,
        itemBuilder: (context, index) {
          final bloon = bloons[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Consumer<FavoriteState>(
              builder: (context, favoriteState, child) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onLongPress: () => favoriteState.toggleFavoriteFunc(
                      context, favoriteState, bloon),
                  onTap: () {
                    if (!favoriteState.isMultiSelectMode) {
                      analyticsHelper.logEvent(
                        name: widgetEngagement,
                        parameters: {
                          'screen': kBloonPagesClass,
                          'widget': listTile,
                          'value': bloon.id,
                        },
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleBloon(
                            analyticsHelper: analyticsHelper,
                            bloonId: bloon.id,
                          ),
                        ),
                      );
                    } else {
                      favoriteState.toggleFavoriteFunc(
                          context, favoriteState, bloon);
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
                              imageName: bloon.image,
                              imagePath: bloonImage(bloon.image),
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
                                    bloon.name,
                                    style: constraintsValues[bloonTitleStyle],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Icon(
                                  favoriteState.isFavorite(bloon.type, bloon.id)
                                      ? Icons.star
                                      : Icons.star_border_outlined,
                                  size: 16,
                                  color: favoriteState.isFavorite(
                                          bloon.type, bloon.id)
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
      itemCount: bloons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final bloon = bloons[index];
        return Consumer<FavoriteState>(
          builder: (context, favoriteState, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onLongPress: () => favoriteState.toggleFavoriteFunc(
                  context, favoriteState, bloon),
              onTap: () {
                if (!favoriteState.isMultiSelectMode) {
                  analyticsHelper.logEvent(
                    name: widgetEngagement,
                    parameters: {
                      'screen': kBloonPagesClass,
                      'widget': listTile,
                      'value': bloon.id,
                    },
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleBloon(
                        analyticsHelper: analyticsHelper,
                        bloonId: bloon.id,
                      ),
                    ),
                  );
                } else {
                  favoriteState.toggleFavoriteFunc(
                      context, favoriteState, bloon);
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
                      flex: 4,
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
                              imageName: bloon.image,
                              imagePath: bloonImage(bloon.image),
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                bloon.name,
                                style: constraintsValues[bloonTitleStyle],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Icon(
                              favoriteState.isFavorite(bloon.type, bloon.id)
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              size: 16,
                              color: favoriteState.isFavorite(
                                      bloon.type, bloon.id)
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
