import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart' show rootBundle;
import '/models/towers/hero.dart';
import '/presentation/widgets/image_outline.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/analytics/analytics.dart';
import '/utilities/utils.dart';
import '/utilities/constants.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class Heroes extends StatefulWidget {
  const Heroes({super.key});

  @override
  State<Heroes> createState() => _HeroesState();
}

class _HeroesState extends State<Heroes> {
  Map<String, dynamic> constraintsValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          constraintsValues = calculateConstraints(constraints);
          return GridView.builder(
            itemCount: GlobalState.menuHeroes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraintsValues["crossAxisCount"],
              childAspectRatio: constraintsValues["childAspectRatio"],
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  leading: ImageOutliner(
                    imageName: GlobalState.menuHeroes[index].image,
                    imagePath: heroImage(GlobalState.menuHeroes[index].image),
                  ),
                  title: AutoSizeText(GlobalState.menuHeroes[index].name,
                      wrapWords: false,
                      style: titleStyle.copyWith(
                          fontSize: constraintsValues["titleFontSize"])),
                  subtitle: AutoSizeText(
                    GlobalState.menuHeroes[index].inGameDesc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    minFontSize: constraintsValues["subtitleFontSize"],
                    maxFontSize: constraintsValues["subtitleFontSize"],
                    wrapWords: false,
                    style: TextStyle(
                        fontSize: constraintsValues["subtitleFontSize"]),
                  ),
                  onTap: () async {
                    if (!GlobalState.isLoading) {
                      var id = GlobalState.menuHeroes[index].id;
                      var path = '${heroDataPath + id}.json';
                      final data = await rootBundle.loadString(path);
                      var jsonData = json.decode(data);
                      logInnerPageView(GlobalState.menuHeroes[index].name);
                      HeroModel heroData = HeroModel.fromJson(jsonData);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SingleHero(
                              heroId: id,
                              singleHero: heroData,
                            );
                          },
                        ),
                      );
                      GlobalState.currentTitle = heroData.name;
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
