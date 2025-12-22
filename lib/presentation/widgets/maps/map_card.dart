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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            capitalizeEveryWord(singleMap.name),
                            maxLines: 1,
                            minFontSize: 10,
                            style: bolderNormalStyle.copyWith(fontSize: 12),
                          ),
                          Text(
                            singleMap.difficulty,
                            style: subtitleStyle.copyWith(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      favoriteState.isFavorite(singleMap.type, singleMap.id)
                          ? Icons.star
                          : Icons.star_border_outlined,
                      size: 16,
                      color: favoriteState.isFavorite(
                              singleMap.type, singleMap.id)
                          ? Colors.amber
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
