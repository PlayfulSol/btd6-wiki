import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/hive/favorite_model.dart';
import '/presentation/widgets/common/app_image.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.favItem,
    required this.analyticsHelper,
    required this.typeName,
    required this.constraintsValues,
  });

  final FavoriteModel favItem;
  final AnalyticsHelper analyticsHelper;
  final String typeName;
  final Map<String, dynamic> constraintsValues;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteState>(
      builder: (context, favoriteState, child) {
        return InkWell(
          onTap: () {
            if (!favoriteState.isMultiSelectMode) {
              navigateToPage(
                context,
                favItem,
                analyticsHelper,
                kFavoritesClass,
                card,
              );
            } else {
              favoriteState.toggleFavoriteFunc(context, favItem);
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: constraintsValues[favItemImageFlex],
                    child: AppImage(
                      path: assetImagePath(typeName, favItem.image),
                    ),
                  ),
                  Flexible(
                    flex: constraintsValues[favItemTextFlex],
                    child: Center(
                      child: Text(
                        favItem.name,
                        textAlign: TextAlign.center,
                        style: constraintsValues[favItemSubtitleStyle],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
