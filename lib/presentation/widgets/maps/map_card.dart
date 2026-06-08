import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/models/base/base_map.dart';
import '/presentation/widgets/common/app_image.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/strings.dart';

Color difficultyColor(String difficulty) {
  switch (difficulty) {
    case 'Beginner':
      return GameColors.military;
    case 'Intermediate':
      return GameColors.upgrade;
    case 'Advanced':
      return GameColors.support;
    case 'Expert':
      return GameColors.danger;
    default:
      return Colors.grey;
  }
}

const _kBadgeSize = 10.0;

class MapCard extends StatelessWidget {
  final BaseMap singleMap;
  final bool isFavorite;
  final bool showChangeBadge;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MapCard({
    super.key,
    required this.singleMap,
    required this.isFavorite,
    this.showChangeBadge = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(singleMap.difficulty);
    final colorScheme = Theme.of(context).colorScheme;

    final card = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AppImage(
                path: mapImage(singleMap.image),
                semanticLabel: singleMap.name,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
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
                        style: subtitleStyle.copyWith(fontSize: 10, color: color),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Icon(
                  isFavorite ? Icons.star : Icons.star_border_outlined,
                  size: 16,
                  color: isFavorite ? GameColors.favourite : null,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );

    if (!showChangeBadge) return card;

    return Stack(
      children: [
        card,
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: _kBadgeSize,
            height: _kBadgeSize,
            decoration: BoxDecoration(
              color: GameColors.danger,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
