import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import '/utilities/requests.dart';

import '/presentation/screens/tower/single_tower.dart';
import '/presentation/widgets/loader.dart';

class Towers extends StatefulWidget {
  const Towers({super.key});

  @override
  State<Towers> createState() => _TowersState();
}

class _TowersState extends State<Towers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getTowers(),
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

                if (constraints.maxWidth < 345) {
                  crossAxisCount = 1;
                  childAspectRatio = 2;
                  cardHeight = 80;
                } else if (constraints.maxWidth < 450) {
                  crossAxisCount = 2;
                  childAspectRatio = 1.5;
                  titleFontSize = 18;
                  subtitleFontSize = 14;
                  cardHeight = 150;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 3;
                  childAspectRatio = 1;
                  titleFontSize = 20;
                  subtitleFontSize = 16;
                } else {
                  crossAxisCount = 4;
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
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListTile(
                                mouseCursor: SystemMouseCursors.click,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '$baseImageUrl/towers/${snapshot.data[index].id}/tower.png'),
                                ),
                                title: Text(snapshot.data[index].name,
                                    style: TextStyle(fontSize: titleFontSize)),
                                subtitle: Text(
                                  snapshot.data[index].description.length > 60
                                      ? snapshot.data[index].description
                                              .substring(0, 60) +
                                          "..."
                                      : snapshot.data[index].description,
                                  style: TextStyle(fontSize: subtitleFontSize),
                                ),
                                onTap: () => getTowerData(
                                        snapshot.data[index].id)
                                    .then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SingleTower(
                                                  towerData: value,
                                                  towerId:
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
