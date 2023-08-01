import 'package:btd6wiki/models/map.dart';
import 'package:flutter/material.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class SingleMap extends StatelessWidget {
  final MapModel map;

  const SingleMap({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GlobalState.currentTitle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                    image: AssetImage(mapImage(map.image)),
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  Text("Name: ${map.name}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Difficulty: ${map.difficulty}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Entrances: ${map.entrances}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text('Exits: ${map.exits}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      const Text("Terrain:", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.terrain ?? ''),
                      const SizedBox(height: 10),
                      const Text("Water:", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.water ?? ''),
                      const SizedBox(height: 10),
                      const Text("Removable Objects:",
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.removableObject ?? ''),
                      const SizedBox(height: 10),
                      const Text("Highground:", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.highground ?? ''),
                      const SizedBox(height: 10),
                      const Text("Sight Blocker:",
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.sightBlocker ?? ''),
                      const SizedBox(height: 10),
                      const Text("Music:", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.music ?? ''),
                      const SizedBox(height: 10),
                      const Text("Length:", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(map.length ?? '')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
