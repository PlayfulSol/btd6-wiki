import 'package:flutter/material.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class SingleMap extends StatelessWidget {
  final dynamic map;

  const SingleMap({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GlobalState.currentTitle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(mapImage(map['image'])),
                    width: 300,
                  ),
                  const SizedBox(height: 10),
                  Text("Mame: ${map['name']}"),
                  const SizedBox(height: 10),
                  Text("Difficulty: ${map['difficulty']}"),
                  const SizedBox(height: 10),
                  Text("Entrances: ${map['entrances']}"),
                  const SizedBox(height: 10),
                  Text("Exits: ${map['exits']}"),
                  const SizedBox(height: 10),
                  Text("Length: ${map['length']}"),
                  const SizedBox(height: 10),
                  Text("Music: ${map['music']}"),
                  const SizedBox(height: 10),
                  Text("Terrain: ${map['terrain']}"),
                  const SizedBox(height: 10),
                  Text("Water: ${map['water']}"),
                  const SizedBox(height: 10),
                  Text("Removable Objects: ${map['removableObject']}"),
                  const SizedBox(height: 10),
                  Text("Highground: ${map['highground']}"),
                  const SizedBox(height: 10),
                  Text("Sight Blocker: ${map['sightBlocker']}"),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ));
  }
}
