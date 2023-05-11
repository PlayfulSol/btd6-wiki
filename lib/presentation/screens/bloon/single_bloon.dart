import 'package:flutter/material.dart';

import '/models/bloons/single_bloon.dart';

import '/presentation/widgets/bloon_hierarchy.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class SingleBloon extends StatelessWidget {
  final SingleBloonModel bloon;

  const SingleBloon({super.key, required this.bloon});

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
                  Image.network(bloonImage(bloon.id), width: 200),
                  const SizedBox(height: 10),
                  Text("Speed: ${bloon.speed}"),
                  const SizedBox(height: 10),
                  Text("Type: ${bloon.type}"),
                  const SizedBox(height: 10),
                  Text("RBE (Red Bloon Equivalent): ${bloon.rbe}"),
                  const SizedBox(height: 10),
                  if (bloon.hp != null) ...[
                    Text("HP: ${bloon.hp}"),
                    const SizedBox(height: 10)
                  ],
                  if (bloon.initialRound != null) ...[
                    Text("Initial Round: ${bloon.initialRound}"),
                    const SizedBox(height: 10)
                  ],
                  if (bloon.initialRoundABR != null) ...[
                    Text("Initial Round ABR: ${bloon.initialRoundABR}"),
                    const SizedBox(height: 10)
                  ],
                  // if (bloon.immunities.isNotEmpty) ...[
                  //   Text("Immunities: ${bloon.immunities.join(", ")}"),
                  //   const SizedBox(height: 10)
                  // ],
                  if (bloon.variants.isNotEmpty) const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text("Variants",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal)),
                    children: // should be a grid with multiple items in a row of coumns with the image and text
                        [
                      ListTile(
                        title: const Text("Camo"),
                        subtitle: Text("${bloon.variants['camo']}"),
                      ),
                      ListTile(
                        title: const Text("Regrow"),
                        subtitle: Text("${bloon.variants['regrow']}"),
                      ),
                      ListTile(
                        title: const Text("Fortified"),
                        subtitle: Text("${bloon.variants['fortified']}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (bloon.children.isNotEmpty) ...[
                    const Text("Children:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Center(
                      child: BloonHierarchy(
                        bloons: bloon.children,
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                  if (bloon.parents.isNotEmpty) ...[
                    const Text("Parents:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    BloonHierarchy(
                      bloons: bloon.parents,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ));
  }
}
