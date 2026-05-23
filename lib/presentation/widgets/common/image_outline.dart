import 'package:flutter/material.dart';

/// Renders a sprite with a theme-aware outline so it's readable on both
/// light and dark backgrounds (e.g. White Bloon, Ice Monkey).
///
/// Bottom layer: the image colorFiltered to a contrasting color (black on
/// light, white on dark) fills the full bounds.
/// Top layer: the real image is inset by 2 px so the outline peeks through.
class ImageOutliner extends StatelessWidget {
  final String imageName;
  final String imagePath;

  // Legacy params — accepted so existing call sites don't break, but the
  // parent widget controls sizing via its own constraints.
  final double? width;
  final double? height;

  const ImageOutliner({
    super.key,
    required this.imageName,
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outlineColor = isDark ? Colors.white : Colors.black;
    final outlineOpacity = isDark ? 0.45 : 0.30;

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        // Outline layer — fills the full bounds
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            outlineColor.withValues(alpha: outlineOpacity),
            BlendMode.srcIn,
          ),
          child: Image(
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            semanticLabel: imageName,
            image: AssetImage(imagePath),
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
        // Main image — 2 px inset so the outline is visible around edges
        Padding(
          padding: const EdgeInsets.all(2),
          child: Image(
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            semanticLabel: imageName,
            image: AssetImage(imagePath),
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      ],
    );
  }
}
