import 'package:flutter/material.dart';
import '/utilities/constants.dart';

/// Drop-in replacement for [RichText] that inherits the ambient [DefaultTextStyle]
/// color — the same behaviour [Text] has — so inline spans stay readable in
/// both light and dark mode without each caller having to manually thread a color
/// through the root [TextSpan].
class ThemedRichText extends StatelessWidget {
  const ThemedRichText({
    super.key,
    required this.children,
    this.baseStyle = normalStyle,
    this.textAlign,
  });

  final List<InlineSpan> children;

  /// Base [TextStyle] applied to the root [TextSpan]. Child spans may override
  /// individual properties (weight, size, etc.) but the color always comes from
  /// [DefaultTextStyle] — callers should not set a color here.
  final TextStyle baseStyle;

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color;
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        style: baseStyle.copyWith(color: color),
        children: children,
      ),
    );
  }
}
