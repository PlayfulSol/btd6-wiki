import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/presentation/widgets/common/image_outline.dart';
import '/utilities/constants.dart';

/// Canonical card for every entity list (towers, heroes, bloons, MOAB, bosses).
/// Maps use MapCard instead because they need cover-crop photo layout.
///
/// Layout: sprite image (top, with ImageOutliner) + bottom bar with
/// 4 px accent bar · name · subtitle · star.
class ListItemCard extends StatelessWidget {
  final String imagePath;
  final String imageName;
  final String name;
  final String subtitle;
  final Color accentColor;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ListItemCard({
    super.key,
    required this.imagePath,
    required this.imageName,
    required this.name,
    required this.subtitle,
    required this.accentColor,
    required this.isFavorite,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: ColoredBox(
                  // Subtle tinted background so white sprites stay readable.
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ImageOutliner(
                      imagePath: imagePath,
                      imageName: imageName,
                    ),
                  ),
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
                      color: accentColor,
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
                          name,
                          maxLines: 1,
                          minFontSize: 10,
                          style: bolderNormalStyle.copyWith(fontSize: 12),
                        ),
                        Text(
                          subtitle,
                          style: subtitleStyle.copyWith(
                              fontSize: 10, color: accentColor),
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
  }
}
