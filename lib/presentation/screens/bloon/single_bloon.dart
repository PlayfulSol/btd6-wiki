import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/presentation/widgets/bloon_aid_widget.dart';
import '/models/bloons/bloon/bloon.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';
import '/utilities/images_url.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';

class SingleBloon extends StatefulWidget {
  const SingleBloon({
    super.key,
    required this.bloonId,
  });
  final String bloonId;

  @override
  State<SingleBloon> createState() => _SingleBloonState();
}

class _SingleBloonState extends State<SingleBloon> {
  late final BloonModel bloon;
  @override
  Future<void> initState() async {
    super.initState();
    var path = '${bloonsDataPath + widget.bloonId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    bloon = BloonModel.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bloon.fullName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                semanticLabel: bloon.fullName,
                image: AssetImage(bloonImage(bloon.image)),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.35,
                filterQuality: FilterQuality.high,
              ),
              Text(
                bloon.fullName,
                style: bigTitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Divider(
                thickness: 2,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 15),
              BloonAidWidget(
                data: bloon.rbe,
                title: "RBE (Red Bloon Equivalent)",
              ),
              const SizedBox(height: 15),
              const Text(
                "Speed",
                style: titleStyle,
              ),
              const SizedBox(height: 5),
              Text(
                "Relative (to red bloon): ${bloon.speed.relative}",
                style: normalStyle,
              ),
              const SizedBox(height: 5),
              Text(
                "Absolute units: ${bloon.speed.absolute}",
                style: normalStyle,
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 2,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 10),
              BloonAidWidget(
                data: bloon.children,
                title: "Children",
              ),
              const SizedBox(height: 10),
              BloonAidWidget(
                data: bloon.parents,
                title: "Parents",
              ),
              if (bloon.variants.isNotEmpty) ...[
                const SizedBox(height: 10),
                ExpansionTile(
                    title: Text(
                      "Variants",
                      style: smallTitleStyle.copyWith(color: Colors.teal),
                    ),
                    onExpansionChanged: (value) {
                      logEvent(bloonConst, 'variants');
                    },
                    children: bloon.variants
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ListTile(
                                title: Text(
                                  e.name,
                                  style: normalStyle.copyWith(
                                      fontWeight: FontWeight.w600),
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
                onExpansionChanged: (value) {
                  logEvent(bloonConst, 'rounds');
                },
                children: bloon.rounds.normal
                    .map((e) => ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: separateString(e)[0],
                                    style: normalStyle.copyWith(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: separateString(e)[1],
                                  style: normalStyle,
                                ),
                              ],
                            ),
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
                onExpansionChanged: (value) {
                  logEvent(bloonConst, 'ABR');
                },
                children: bloon.rounds.abr
                    .map((e) => ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: separateString(e)[0],
                                    style: normalStyle.copyWith(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: separateString(e)[1],
                                  style: normalStyle,
                                ),
                              ],
                            ),
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
