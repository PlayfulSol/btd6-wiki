import 'package:btd6wiki/utilities/constants.dart';
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
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.35,
                filterQuality: FilterQuality.high,
              ),
              Text(
                widget.bloon.fullName,
                style: bigTitleStyle,
              ),
              const SizedBox(height: 5),
              Divider(
                thickness: 2,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 15),
              BloonAidWidget(
                data: widget.bloon.rbe,
                title: "RBE (Red Bloon Equivalent)",
              ),
              const SizedBox(height: 15),
              const Text(
                "Speed",
                style: titleStyle,
              ),
              const SizedBox(height: 5),
              Text(
                "Relative (to red bloon) ${widget.bloon.speed.relative}",
                style: normalStyle,
              ),
              const SizedBox(height: 5),
              Text(
                "Absolute units: ${widget.bloon.speed.absolute}",
                style: normalStyle,
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 2,
                color: Colors.grey[600],
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
                    title: Text(
                      "Variants",
                      style: smallTitleStyle.copyWith(color: Colors.teal),
                    ),
                    children: widget.bloon.variants
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ListTile(
                                title: Text(
                                  e.name,
                                  style: normalStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  e.appearances,
                                  style: normalStyle,
                                ),
                                leading: SizedBox(
                                  width: 50,
                                  child: Image.asset(
                                    bloonImage(e.image),
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
                const SizedBox(height: 10)
              ],
              const SizedBox(height: 10),
              const Text("Rounds", style: titleStyle),
              ExpansionTile(
                title: Text(
                  "Normal",
                  style: smallTitleStyle.copyWith(color: Colors.teal),
                ),
                children: widget.bloon.rounds.normal
                    .map((e) => ListTile(
                          title: Text(
                            e,
                            style: normalStyle,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                title: Text(
                  "ABR",
                  style: smallTitleStyle.copyWith(color: Colors.teal),
                ),
                children: widget.bloon.rounds.abr
                    .map((e) => ListTile(
                          title: Text(
                            e,
                            style: normalStyle,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
