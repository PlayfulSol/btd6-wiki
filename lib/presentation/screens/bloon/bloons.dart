import 'package:flutter/material.dart';

import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/boss_bloon.dart';
import '/presentation/widgets/loader.dart';

import '/utilities/global_state.dart';
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
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          const Text("Bloons", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 15),
          FutureBuilder(
            future: Future.value(GlobalState.bloons),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Loader();
              } else {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisExtent: 100,
                    ),
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListTile(
                                mouseCursor: SystemMouseCursors.click,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      bloonImage(snapshot.data[index].id)),
                                ),
                                title: Text(snapshot.data[index].name,
                                    style: const TextStyle(fontSize: 14)),
                                subtitle: Text(snapshot.data[index].type),
                                onTap: () {
                                  if (!GlobalState.isLoading) {
                                    getBloonData(snapshot.data[index].id).then(
                                        (value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleBloon(
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
          const SizedBox(height: 30),
          const Text("Bosses", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 15),
          FutureBuilder(
            future: Future.value(GlobalState.bosses),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Loader();
              } else {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisExtent: 100,
                    ),
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListTile(
                                mouseCursor: SystemMouseCursors.click,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      bloonImage(snapshot.data[index].id)),
                                ),
                                title: Text(snapshot.data[index].name,
                                    style: const TextStyle(fontSize: 14)),
                                subtitle: Text(snapshot.data[index].type),
                                onTap: () {
                                  if (!GlobalState.isLoading) {
                                    getBloonData(snapshot.data[index].id)
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BossBloon(
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
        ]),
      ),
    ));
  }
}
