import 'package:btd6wiki/utilities/global_state.dart';
import 'package:flutter/material.dart';

import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/presentation/widgets/loader.dart';

import '/utilities/images_url.dart';
import '/utilities/requests.dart';

class Bloons extends StatefulWidget {
  const Bloons({super.key});

  @override
  State<Bloons> createState() => _BloonsState();
}

class _BloonsState extends State<Bloons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.value(GlobalState.bloons),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Loader();
            } else {
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisExtent: 100,
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
                                    bloonImage(snapshot.data[index].id)),
                              ),
                              title: Text(snapshot.data[index].name,
                                  style: const TextStyle(fontSize: 14)),
                              subtitle: Text(snapshot.data[index].type),
                              onTap: () {
                                if (snapshot.data[index].type == "boss") {
                                  getBloonData(snapshot.data[index].id)
                                      .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BossBloon(
                                                    bloon: value,
                                                  ))));
                                } else if (snapshot.data[index].type ==
                                        "bloon" ||
                                    snapshot.data[index].type == "moab") {
                                  getBloonData(snapshot.data[index].id)
                                      .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SingleBloon(
                                                    bloon: value,
                                                  ))));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
