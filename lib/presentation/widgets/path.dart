import 'package:flutter/material.dart';

import '/models/tower.dart';

import '/utilities/utils.dart';
import '/utilities/images_url.dart';

class MonkeyPath extends StatelessWidget {
  final List<MonkeyPathModel> path;
  final String pathKey;
  final String monkeyId;

  const MonkeyPath(
      {super.key,
      required this.path,
      required this.pathKey,
      required this.monkeyId});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(getPathTitleFromKey(pathKey),
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: path.length,
            itemBuilder: (context, index) => Column(
              children: [
                Text(path[index].name, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Image.network(towerPathImage(monkeyId, pathKey, index),
                    width: 200),
                const SizedBox(height: 10),
                Text(
                  path[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                const Text("Cost:"),
                Text(
                  costToString(path[index].cost),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // a closed list of all the effects
                if (path[index].effects.isNotEmpty) ...[
                  ExpansionTile(
                    title: const Text("Effects:"),
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: path[index].effects.length,
                          itemBuilder: (context, effectIndex) => Column(
                                children: [
                                  Text(
                                    path[index].effects[effectIndex],
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              )),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ]);
  }
}
