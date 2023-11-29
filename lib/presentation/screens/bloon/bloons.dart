import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/image_outline.dart';
import '../../../models/bloons/bloon/bloon.dart';
import '../../../models/bloons/boss/boss_bloon.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class Bloons extends StatefulWidget {
  const Bloons({
    super.key,
    required this.bloons,
    required this.bosses,
  });

  final List<BaseModel> bloons;
  final List<BaseModel> bosses;

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  Map<String, dynamic> constraintsValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraintsBloons(constraints);

          return ListView(
            children: [
              const Text(
                "Bloons",
                style: bigTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              BloonsGrid(widget: widget, constraintsValues: constraintsValues),
              const SizedBox(height: 30),
              const Text(
                "Bosses",
                style: bigTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              BossesGrid(constraintsValues: constraintsValues, widget: widget),
            ],
          );
        },
      ),
    );
  }
}

class BossesGrid extends StatelessWidget {
  const BossesGrid({
    super.key,
    required this.constraintsValues,
    required this.widget,
  });

  final Map<String, dynamic> constraintsValues;
  final Bloons widget;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraintsValues["crossAxisCountBoss"],
        childAspectRatio: constraintsValues["childAspectRatioBoss"],
      ),
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: widget.bosses.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.5),
          child: Center(
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              leading: ImageOutliner(
                imageName: widget.bosses[index].image,
                imagePath: bossImage(widget.bosses[index].image),
              ),
              title: Text(
                widget.bosses[index].name,
                style: constraintsValues["textStyleBoss"],
              ),
              onTap: () async {
                // if (!GlobalState.isLoading) {
                //   var id = GlobalState.bosses[index].id;
                //   var path = '${bossesDataPath + id}.json';
                //   final data = await rootBundle.loadString(path);
                //   var jsonData = json.decode(data);
                //   logPageView(GlobalState.bosses[index].name);
                //   BossBloonModel bossData =
                //       BossBloonModel.fromJson(jsonData);
                //   // ignore: use_build_context_synchronously
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           BossBloon(bloon: bossData),
                //     ),
                //   );
                //   GlobalState.currentTitle = bossData.name;
                // }
              },
            ),
          ),
        );
      },
    );
  }
}

class BloonsGrid extends StatelessWidget {
  const BloonsGrid({
    super.key,
    required this.widget,
    required this.constraintsValues,
  });

  final Bloons widget;
  final Map<String, dynamic> constraintsValues;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.bloons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: constraintsValues["crossAxisCount"],
          childAspectRatio: constraintsValues["childAspectRatio"],
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 7,
            ),
            child: Center(
              child: ListTile(
                horizontalTitleGap: 10,
                leading: ImageOutliner(
                  imageName: widget.bloons[index].image,
                  imagePath: bloonImage(widget.bloons[index].image),
                  width: constraintsValues["imageWidth"],
                ),
                title: Text(
                  widget.bloons[index].name,
                  maxLines: 1,
                  style: smallTitleStyle.copyWith(
                    fontSize: constraintsValues["titleFontSize"],
                  ),
                ),
                onTap: () async {
                  // if (!GlobalState.isLoading) {
                  //   var id = GlobalState.bloons[index].id;
                  //   var path = '${bloonsDataPath + id}.json';
                  //   final data = await rootBundle.loadString(path);
                  //   var jsonData = json.decode(data);
                  //   logPageView(GlobalState.bloons[index].name);
                  //   SingleBloonModel bloonData =
                  //       SingleBloonModel.fromJson(jsonData);
                  //   // ignore: use_build_context_synchronously
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           SingleBloon(bloon: bloonData),
                  //     ),
                  //   );
                  //   GlobalState.currentTitle = bloonData.name;
                  // }
                },
              ),
            ),
          );
        });
  }
}
