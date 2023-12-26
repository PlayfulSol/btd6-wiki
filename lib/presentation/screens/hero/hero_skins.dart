import 'package:flutter/material.dart';
import '/models/towers/hero/hero_skins.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class HeroSkins extends StatefulWidget {
  final String heroId;
  final String heroName;
  final List<Skins> heroSkins;
  final AnalyticsHelper analyticsHelper;

  const HeroSkins({
    super.key,
    required this.heroId,
    required this.heroSkins,
    required this.heroName,
    required this.analyticsHelper,
  });

  @override
  State<HeroSkins> createState() => _HeroSkinsState();
}

class _HeroSkinsState extends State<HeroSkins> {
  String extractLevel(String value) {
    RegExp regex = RegExp(r'\d+');
    RegExpMatch? firstMatch = regex.firstMatch(value);

    // Use the null-aware operator to check for no match
    return firstMatch?.group(0) ?? '1';
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: widget.heroId,
      screenName: kHeroSkinsPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraintsValues = selectSizePreset(
      kBloons,
      MediaQuery.of(context).size,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.heroName} - Skins'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: widget.heroSkins.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(
                  widget.heroSkins[index].name,
                  style: titleStyle.copyWith(color: Colors.teal),
                ),
                onExpansionChanged: (bool value) {
                  widget.analyticsHelper.logEvent(
                    name: widgetEngagement,
                    parameters: {
                      'screen': kHeroSkinsPage,
                      'widget': expansionTile,
                      'value':
                          '${widget.heroId}_${widget.heroSkins[index].name}_$value',
                    },
                  );
                },
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraintsValues["crossAxisCount"],
                      childAspectRatio: 0.75,
                    ),
                    itemCount: widget.heroSkins[index].value.length,
                    itemBuilder: (context, imageIndex) {
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                child: Image(
                                  image: AssetImage(
                                    heroImage(
                                      widget.heroSkins[index].value[imageIndex],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Level ${extractLevel(widget.heroSkins[index].value[imageIndex])}',
                                style: titleStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
