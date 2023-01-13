import 'package:flutter/material.dart';

import '/models/bloons/bloon_hierarchy.dart';

import '/presentation/screens/bloon/single_bloon.dart';

import '/utilities/images_url.dart';
import '/utilities/requests.dart';

class BloonHierarchy extends StatelessWidget {
  final List<BloonHierarchyModel> bloons;

  const BloonHierarchy({super.key, required this.bloons});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        mainAxisExtent: 150,
      ),
      shrinkWrap: true,
      itemCount: bloons.length,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            getBloonData(bloons[index].id).then((value) => {
                  Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleBloon(
                                bloon: value,
                              )))
                });
          },
          child: Column(children: [
            Image.network(
              bloonImage(bloons[index].id),
              width: 50,
            ),
            if (bloons[index].count != null) ...[
              Text("Count: ${bloons[index].count}"),
              const SizedBox(height: 10)
            ],
            if (bloons[index].type != "" && bloons[index].type != null) ...[
              Text("Type: ${bloons[index].type}", textAlign: TextAlign.center),
              const SizedBox(height: 10)
            ],
          ]),
        );
      },
    );
  }
}
