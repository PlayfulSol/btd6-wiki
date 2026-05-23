import 'package:flutter/material.dart';

const _placeholder = 'assets/images/placeholder.webp';

/// Standard asset image for the app.
///
/// Always renders at [FilterQuality.high] and falls back to [_placeholder]
/// on any load error, so callers never have to repeat that boilerplate.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.semanticLabel,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(path),
      filterQuality: FilterQuality.high,
      fit: fit,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      errorBuilder: (_, __, ___) => Image.asset(
        _placeholder,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
