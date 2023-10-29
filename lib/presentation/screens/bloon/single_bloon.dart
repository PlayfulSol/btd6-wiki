import 'package:flutter/material.dart';

import 'package:btd6wiki/presentation/widgets/bloon_aid_widget.dart';
import '/models/bloons/single_bloon.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(bloonImage(bloon.image)),
                width: 130,
                // fit: BoxFit.scaleDown,
                // fit: BoxFit.fill,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                "RBE (Red Bloon Equivalent)",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Center(child: BloonAidWidget(data: bloon.rbe)),
              const SizedBox(height: 10),
              const Text("Speed", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 5),
              Text("Relative (to red bloon) ${bloon.speed.relative}"),
              const SizedBox(height: 5),
              Text("Absolute units: ${bloon.speed.absolute}"),
              const SizedBox(height: 10),
              const Text("Children", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Center(child: BloonAidWidget(data: bloon.children)),
              const SizedBox(height: 20),
              const Text("Parents", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Center(child: BloonAidWidget(data: bloon.parents)),
              if (bloon.variants.isNotEmpty) ...[
                const SizedBox(height: 10),
                ExpansionTile(
                    title: const Text("Variants",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal)),
                    children: bloon.variants
                        .map((e) => ListTile(
                              title: Text(e.name),
                              subtitle: Text(e.appearances),
                              leading: SizedBox(
                                width: 50,
                                child: Image.asset(
                                  bloonImage(e.image),
                                ),
                              ),
                            ))
                        .toList()),
                const SizedBox(height: 10)
              ],
              const SizedBox(height: 10),
              const Text("Rounds", style: TextStyle(fontSize: 20)),
              ExpansionTile(
                  title: const Text("Normal",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.teal)),
                  children: bloon.rounds.normal
                      .map((e) => ListTile(
                            title: Text(e),
                          ))
                      .toList()),
              const SizedBox(height: 10),
              ExpansionTile(
                  title: const Text("ABR",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.teal)),
                  children: bloon.rounds.abr
                      .map((e) => ListTile(
                            title: Text(e),
                          ))
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
