import 'package:auto_size_text/auto_size_text.dart';
import 'package:btd6wiki/models/base/base_map.dart';
import 'package:flutter/material.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';

class MapCard extends StatelessWidget {
  final BaseMap singleMap;

  const MapCard({super.key, required this.singleMap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image(
              semanticLabel: singleMap.name,
              image: AssetImage(mapImage(singleMap.image)),
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  capitalizeEveryWord(singleMap.name),
                  maxLines: 1,
                  style: bolderNormalStyle,
                ),
                const SizedBox(height: 5),
                Text(singleMap.difficulty, style: subtitleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
