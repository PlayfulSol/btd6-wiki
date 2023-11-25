import 'package:flutter/material.dart';
import '/models/towers/tower.dart';
import '/utilities/constants.dart';
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
        title: Text(pathsDictionary[pathKey]!,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemCount: path.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image(
                    image: AssetImage(
                      towerImage(path[index].image),
                    ),
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    path[index].name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  path[index].upgradeBody,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Cost:",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  costToString(path[index].cost),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ]);
  }
}
