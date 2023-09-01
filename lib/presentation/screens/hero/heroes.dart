import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/utilities/global_state.dart';
import '/utilities/requests.dart';
import '/utilities/images_url.dart';

import '/presentation/widgets/loader.dart';
import '/presentation/screens/hero/single_hero.dart';

class Heroes extends StatefulWidget {
  const Heroes({super.key});

  @override
  State<Heroes> createState() => _HeroesState();
}

class _HeroesState extends State<Heroes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.value(GlobalState.heroes),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Loader();
            } else {
              return LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = 2;
                double childAspectRatio = 1.5;
                double cardHeight = 130;
                double titleFontSize = 15;
                double subtitleFontSize = 13;

                if (constraints.maxWidth < 450) {
                  crossAxisCount = 1;
                  titleFontSize = 18;
                  subtitleFontSize = 15;
                  cardHeight = 100;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 2;
                  childAspectRatio = 1;
                  titleFontSize = 20;
                  subtitleFontSize = 16;
                } else {
                  crossAxisCount = 3;
                  childAspectRatio = 0.75;
                  titleFontSize = 24;
                  subtitleFontSize = 18;
                }

                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      mainAxisExtent: cardHeight,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                              dense: false,
                              isThreeLine: true,
                              mouseCursor: SystemMouseCursors.click,
                              leading: SizedBox(
                                height: double.infinity,
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(heroBaseImage(
                                        snapshot.data[index].id))),
                              ),
                              title: AutoSizeText(snapshot.data[index].name,
                                  wrapWords: false,
                                  style: TextStyle(fontSize: titleFontSize)),
                              subtitle: AutoSizeText(
                                snapshot.data[index].description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                wrapWords: false,
                                style: TextStyle(fontSize: subtitleFontSize),
                              ),
                              onTap: () => {
                                    if (!GlobalState.isLoading)
                                      {
                                        getHeroData(snapshot.data[index].id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleHero(
                                                          singleHero: value,
                                                          heroId: snapshot
                                                              .data[index].id,
                                                        )))),
                                      }
                                  }));
                    });
              });
            }
          },
        ),
      ),
    );
  }
}
