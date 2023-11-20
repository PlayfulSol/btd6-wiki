import 'package:flutter/material.dart';

import '/models/bloons/boss_bloon.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';

class BossBloon extends StatelessWidget {
  final BossBloonModel bloon;

  const BossBloon({super.key, required this.bloon});

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
                    image: AssetImage(
                      bossImage(
                        bloon.images["normal"]!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(bloon.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Type: ${bloon.description}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ),
        ));
  }
}
