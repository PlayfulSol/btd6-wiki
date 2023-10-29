import 'package:flutter/material.dart';

import 'package:btd6wiki/presentation/widgets/bloon_aid_widget.dart';
import '/models/bloons/single_bloon.dart';

import '/utilities/global_state.dart';
import '/utilities/images_url.dart';

class SingleBloon extends StatefulWidget {
  final SingleBloonModel bloon;

  const SingleBloon({super.key, required this.bloon});

  @override
  State<SingleBloon> createState() => _SingleBloonState();
}

class _SingleBloonState extends State<SingleBloon> {
  late String currentTitle;
  @override
  void initState() {
    super.initState();
    currentTitle = GlobalState.currentTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(bloonImage(widget.bloon.image)),
                width: 200,
                fit: BoxFit.scaleDown,
                // fit: BoxFit.fill,
                // fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
              BloonAidWidget(
                data: widget.bloon.rbe,
                title: "RBE (Red Bloon Equivalent)",
              ),
              const SizedBox(height: 15),
              const Text("Speed", style: TextStyle(fontSize: 22)),
              const SizedBox(height: 5),
              Text(
                "Relative (to red bloon) ${widget.bloon.speed.relative}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                "Absolute units: ${widget.bloon.speed.absolute}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              BloonAidWidget(
                data: widget.bloon.children,
                title: "Children",
              ),
              const SizedBox(height: 10),
              BloonAidWidget(
                data: widget.bloon.parents,
                title: "Parents",
              ),
              if (widget.bloon.variants.isNotEmpty) ...[
                const SizedBox(height: 10),
                ExpansionTile(
                    title: const Text("Variants",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal)),
                    children: widget.bloon.variants
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
                  children: widget.bloon.rounds.normal
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
                  children: widget.bloon.rounds.abr
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
