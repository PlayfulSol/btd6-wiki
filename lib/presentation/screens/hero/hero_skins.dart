import 'package:flutter/material.dart';

import '/models/hero.dart';

import '/presentation/widgets/hero_skin.dart';

class HeroSkins extends StatelessWidget {
  final String heroId;
  final List<Skins> heroSkins;
  final List<int> skinChange;
  final String heroName;

  const HeroSkins(
      {super.key,
      required this.heroId,
      required this.heroSkins,
      required this.skinChange,
      required this.heroName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" $heroName Skins"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  ListView.builder(
                      primary: false,
                      itemCount: heroSkins.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => HeroSkin(
                          heroId: heroId,
                          skinId: heroSkins[index].id,
                          skinName: heroSkins[index].name,
                          skinChange: skinChange)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
