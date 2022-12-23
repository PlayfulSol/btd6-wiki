import 'package:flutter/material.dart';

import '/models/bloons/single_bloon.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/requests.dart';

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
                  if (bloon.immunities.isNotEmpty) ...[
                    Text("Immunities: ${bloon.immunities.join(", ")}"),
                    const SizedBox(height: 10)
                  ],
                  if (bloon.variants.isNotEmpty) ...[
                    Text("Variants: ${bloon.variants.join(", ")}",
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10)
                  ],
                  if (bloon.children.isNotEmpty) ...[
                    const Text("Children:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    Center(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 80,
                        ),
                        shrinkWrap: true,
                        itemCount: bloon.children.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              getBloonData(bloon.children[index].id)
                                  .then((value) =>
                                      // push instead of the current page
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SingleBloon(
                                                    bloon: value,
                                                  ))));
                            },
                            child: Column(children: [
                              Image.network(
                                bloonImage(bloon.children[index].id),
                                width: 50,
                              ),
                              Text("Count: ${bloon.children[index].count}"),
                            ]),
                          );
                        },
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
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                        mainAxisExtent: 60,
                      ),
                      shrinkWrap: true,
                      itemCount: bloon.parents.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            getBloonData(bloon.parents[index].id)
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleBloon(
                                              bloon: value,
                                            ))));
                          },
                          child: Column(children: [
                            Image.network(
                              bloonImage(bloon.parents[index].id),
                              width: 50,
                            ),
                          ]),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ));
  }
}
