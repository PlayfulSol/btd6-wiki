import 'package:btd6wiki/models/base/base_hero.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '/presentation/widgets/image_outline.dart';
import '/presentation/screens/hero/single_hero.dart';
import '/analytics/analytics.dart';
import '/utilities/utils.dart';
import '/utilities/constants.dart';
import '/utilities/images_url.dart';

class Heroes extends StatefulWidget {
  const Heroes({
    super.key,
    required this.heroes,
  });

  final List<BaseHero> heroes;

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
            itemCount: widget.heroes.length,
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
                    mouseCursor: SystemMouseCursors.click,
                    leading: ImageOutliner(
                      imageName: widget.heroes[index].image,
                      imagePath: heroImage(widget.heroes[index].image),
                    ),
                    title: AutoSizeText(widget.heroes[index].name,
                        wrapWords: false,
                        style: titleStyle.copyWith(
                            fontSize: constraintsValues["titleFontSize"])),
                    subtitle: AutoSizeText(
                      widget.heroes[index].inGameDesc,
                      overflow: TextOverflow.ellipsis,
                      maxLines: constraintsValues["rowsToShow"],
                      minFontSize: constraintsValues["subtitleFontSize"],
                      maxFontSize: constraintsValues["subtitleFontSize"],
                      wrapWords: false,
                      style: TextStyle(
                          fontSize: constraintsValues["subtitleFontSize"]),
                    ),
                    onTap: () {
                      logPageView(widget.heroes[index].name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SingleHero(
                              heroId: widget.heroes[index].id,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
