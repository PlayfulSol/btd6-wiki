import 'package:flutter/material.dart';
import '/models/towers/hero/hero_skins.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

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
                  for (var value in widget.heroSkins[index].value)
                    Image(
                      image: AssetImage(heroImage(value)),
                      filterQuality: FilterQuality.high,
                      width: MediaQuery.of(context).size.width * 0.4,
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
