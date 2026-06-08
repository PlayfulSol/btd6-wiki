import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/presentation/widgets/common/image_outline.dart';
import '/utilities/constants.dart';

const _kBadgeSize = 14.0;

/// Canonical card for every entity list (towers, heroes, bloons, MOAB, bosses).
/// Maps use MapCard instead because they need cover-crop photo layout.
///
/// Layout: sprite image (top, with ImageOutliner) + bottom bar with
/// 4 px accent bar · name · subtitle · star.
class ListItemCard extends StatefulWidget {
  final String imagePath;
  final String imageName;
  final String name;
  final String subtitle;
  final Color accentColor;
  final bool isFavorite;
  final bool showChangeBadge;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  /// Called after the badge dismiss animation completes. If null, badge is not tappable.
  final VoidCallback? onDismissChangeBadge;

  const ListItemCard({
    super.key,
    required this.imagePath,
    required this.imageName,
    required this.name,
    required this.subtitle,
    required this.accentColor,
    required this.isFavorite,
    this.showChangeBadge = false,
    required this.onTap,
    required this.onLongPress,
    this.onDismissChangeBadge,
  });

  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeOpacity;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    // Pop up briefly, then shrink to nothing.
    _badgeScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 75,
      ),
    ]).animate(_badgeController);

    _badgeOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 75,
      ),
    ]).animate(_badgeController);
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  void _dismissBadge() {
    _badgeController.forward().then((_) {
      widget.onDismissChangeBadge?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final card = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
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
                      imagePath: widget.imagePath,
                      imageName: widget.imageName,
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
                      color: widget.accentColor,
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
                          widget.name,
                          maxLines: 1,
                          minFontSize: 10,
                          style: bolderNormalStyle.copyWith(fontSize: 12),
                        ),
                        Text(
                          widget.subtitle,
                          style: subtitleStyle.copyWith(
                              fontSize: 10, color: widget.accentColor),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    widget.isFavorite
                        ? Icons.star
                        : Icons.star_border_outlined,
                    size: 16,
                    color: widget.isFavorite ? GameColors.favourite : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.showChangeBadge) return card;

    return Stack(
      children: [
        card,
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: widget.onDismissChangeBadge != null ? _dismissBadge : null,
            behavior: HitTestBehavior.opaque,
            child: ScaleTransition(
              scale: _badgeScale,
              child: FadeTransition(
                opacity: _badgeOpacity,
                child: Container(
                  width: _kBadgeSize,
                  height: _kBadgeSize,
                  decoration: BoxDecoration(
                    color: GameColors.danger,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: colorScheme.surface, width: 1.35),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
