import 'package:flutter/material.dart';

import '/utilities/images_url.dart';

class HeroSkin extends StatelessWidget {
  final String heroId;
  final String skinId;
  final String skinName;
  final List<int> skinChange;

  const HeroSkin(
      {super.key,
      required this.heroId,
      required this.skinId,
      required this.skinName,
      required this.skinChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
            child: Column(children: [
          Text(skinName,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          const SizedBox(height: 15),
          ListView.separated(
            primary: false,
            itemCount: skinChange.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(
                      "Level ${skinChange[index]} ",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                        heroSkinLevelImage(heroId, skinId, skinChange[index]),
                        width: 200),
                    const SizedBox(height: 20),
                  ])
                ]),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
          const SizedBox(height: 50),
        ])),
      ],
    );
  }
}
