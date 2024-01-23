import 'package:btd6wiki/analytics/analytics.dart';
import 'package:btd6wiki/analytics/analytics_constants.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:btd6wiki/presentation/screens/bloon/boss_bloon.dart';
import 'package:btd6wiki/presentation/widgets/misc/image_outline.dart';
import 'package:btd6wiki/utilities/constants.dart';
import 'package:btd6wiki/utilities/images_url.dart';
import 'package:flutter/material.dart';

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

        return Card(
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
            ),
          ),
        );
      },
    );
  }
}
