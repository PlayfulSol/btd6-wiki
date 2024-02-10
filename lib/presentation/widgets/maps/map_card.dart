import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/models/base/base_map.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';

class MapCard extends StatelessWidget {
  final BaseMap singleMap;

  const MapCard({super.key, required this.singleMap});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteState>(
      builder: (context, favoriteState, child) {
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
              ListTile(
                title: AutoSizeText(
                  capitalizeEveryWord(singleMap.name),
                  maxLines: 1,
                  style: bolderNormalStyle,
                ),
                subtitle: Text(singleMap.difficulty, style: subtitleStyle),
                trailing: favoriteState.isFavorite(singleMap.type, singleMap.id)
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
