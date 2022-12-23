import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import '/utilities/requests.dart';

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
          future: getHeroes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("Loading..."),
              );
            } else {
              return LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = 2;
                double childAspectRatio = 1.5;
                double cardHeight = 130;

                if (constraints.maxWidth < 345) {
                  crossAxisCount = 1;
                  childAspectRatio = 2;
                  cardHeight = 80;
                } else if (constraints.maxWidth < 400) {
                  crossAxisCount = 2;
                  childAspectRatio = 1.5;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 3;
                  childAspectRatio = 1;
                } else {
                  crossAxisCount = 4;
                  childAspectRatio = 0.75;
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
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                mouseCursor: SystemMouseCursors.click,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '$baseImageUrl/heroes/${snapshot.data[index].id}/hero.png'),
                                ),
                                title: Text(snapshot.data[index].name,
                                    style: const TextStyle(fontSize: 15)),
                                subtitle: Text(
                                  snapshot.data[index].description.length > 70
                                      ? snapshot.data[index].description
                                              .substring(0, 70) +
                                          "..."
                                      : snapshot.data[index].description,
                                ),
                                onTap: () => getHeroData(
                                        snapshot.data[index].id)
                                    .then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SingleHero(
                                                  singleHero: value,
                                                  heroId:
                                                      snapshot.data[index].id,
                                                )))),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              });
            }
          },
        ),
      ),
    );
  }
}
