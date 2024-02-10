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
    return GridView.builder(
      itemCount: bloons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraintsValues[bloonCrossCount],
        childAspectRatio: constraintsValues[bloonAspectRatio],
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final bloon = bloons[index];
        return Consumer<FavoriteState>(
          builder: (context, favoriteState, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onLongPress: () => favoriteState.toggleFavoriteFunc(
                  context, favoriteState, bloon),
              onTap: () {
                if (!favoriteState.multiSelect) {
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
                margin: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 7,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageOutliner(
                        imageName: bloon.image,
                        imagePath: bloonImage(bloon.image),
                        width: constraintsValues[bloonImageWidth],
                      ),
                      Center(
                        child: Text(
                          bloon.name,
                          style: constraintsValues[bloonTitleStyle],
                        ),
                      ),
                      Icon(
                        favoriteState.isFavorite(bloon.type, bloon.id)
                            ? Icons.star
                            : Icons.star_border_outlined,
                      ),
                    ],
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
