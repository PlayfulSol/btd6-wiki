import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/bloons/bloon/bloon.dart';
import '/presentation/widgets/bloons/bloon_aid_widget.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class SingleBloon extends StatefulWidget {
  const SingleBloon({
    super.key,
    required this.analyticsHelper,
    required this.bloonId,
  });
  final AnalyticsHelper analyticsHelper;
  final String bloonId;

  @override
  State<SingleBloon> createState() => _SingleBloonState();
}

class _SingleBloonState extends State<SingleBloon> {
  late final BloonModel bloon;
  bool loading = true;

  void loadBloon() async {
    var path = '${bloonsDataPath + widget.bloonId}.json';
    final data = await rootBundle.loadString(path);
    var jsonData = json.decode(data);
    bloon = BloonModel.fromJson(jsonData);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kBloonPagesClass,
      screenName: widget.bloonId,
    );
    loadBloon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !loading
          ? AppBar(
              title: Text(bloon.fullName),
              actions: [
                Consumer<FavoriteState>(
                  builder: (context, favoriteState, child) {
                    return IconButton(
                      onPressed: () => favoriteState.toggleFavoriteFunc(
                          context, favoriteState, bloon),
                      icon: favoriteState.isFavorite(bloon.type, bloon.id)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border_outlined),
                    );
                  },
                ),
              ],
            )
          : AppBar(),
      body: !loading
          ? SingleChildScrollView(
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
                      bloonId: bloon.id,
                      analyticsHelper: widget.analyticsHelper,
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
                      analyticsHelper: widget.analyticsHelper,
                      data: bloon.children,
                      title: "Children",
                      bloonId: bloon.id,
                    ),
                    const SizedBox(height: 10),
                    BloonAidWidget(
                      bloonId: bloon.id,
                      analyticsHelper: widget.analyticsHelper,
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
                          onExpansionChanged: (bool value) {
                            widget.analyticsHelper.logEvent(
                              name: widgetEngagement,
                              parameters: {
                                'screen': bloon.id,
                                'widget': expansionTile,
                                'value': 'variants_$value',
                              },
                            );
                          },
                          children: bloon.variants
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
                      onExpansionChanged: (bool value) {
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': bloon.id,
                            'widget': expansionTile,
                            'value': 'normal_rounds_$value',
                          },
                        );
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
                      onExpansionChanged: (bool value) {
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': bloon.id,
                            'widget': expansionTile,
                            'value': 'abr_rounds_$value',
                          },
                        );
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
            )
          : const CircularProgressIndicator(),
    );
  }
}
