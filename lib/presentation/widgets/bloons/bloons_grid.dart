import 'package:btd6wiki/analytics/analytics.dart';
import 'package:btd6wiki/analytics/analytics_constants.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:btd6wiki/presentation/screens/bloon/single_bloon.dart';
import 'package:btd6wiki/presentation/widgets/misc/image_outline.dart';
import 'package:btd6wiki/utilities/constants.dart';
import 'package:btd6wiki/utilities/images_url.dart';
import 'package:flutter/material.dart';

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
        return Card(
          margin: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 7,
          ),
          child: Center(
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: ImageOutliner(
                imageName: bloon.image,
                imagePath: bloonImage(bloon.image),
                width: constraintsValues[bloonImageWidth],
              ),
              title: Text(
                bloon.name,
                maxLines: 1,
                style: constraintsValues[bloonTitleStyle],
              ),
              onTap: () {
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
              },
            ),
          ),
        );
      },
    );
  }
}
