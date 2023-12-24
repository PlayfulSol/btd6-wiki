import 'package:flutter/material.dart';
import '/models/towers/hero/hero_skins.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

class HeroSkins extends StatelessWidget {
  final String heroId;
  final List<Skins> heroSkins;
  final String heroName;

  const HeroSkins(
      {super.key,
      required this.heroId,
      required this.heroSkins,
      required this.heroName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$heroName - Skins'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: heroSkins.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(
                  heroSkins[index].name,
                  style: titleStyle.copyWith(color: Colors.teal),
                ),
                children: [
                  for (var value in heroSkins[index].value)
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
