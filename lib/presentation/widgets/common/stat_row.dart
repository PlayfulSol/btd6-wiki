import 'package:flutter/material.dart';
import '/utilities/constants.dart';

/// Renders [text] with ` -> ` replaced by a centered arrow icon so the Roboto
/// unicode glyph baseline doesn't misalign the surrounding text. Falls back to
/// a plain [Text] when no separator is found.
Widget arrowText(BuildContext context, String text, TextStyle style,
    {double iconSize = 14}) {
  final idx = text.indexOf(' -> ');
  if (idx == -1) return Text(text, style: style);
  final before = text.substring(0, idx);
  final after = text.substring(idx + 4);
  return Text.rich(
    TextSpan(
      style: style,
      children: [
        TextSpan(text: before),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(Icons.arrow_forward, size: iconSize, color: style.color),
        ),
        TextSpan(text: after),
      ],
    ),
  );
}

/// A standalone label-above-value tile. Label is accent-coloured (primary),
/// value is neutral weight. Used for single items outside a grid context.
class StatTile extends StatelessWidget {
  final String label;
  final String value;

  const StatTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          arrowText(
            context,
            value,
            normalStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// Two-column grid of label+value pairs. Accent-coloured labels above values.
/// Uses explicit Row/Column with Container dividers to avoid TableBorder intersection gaps.
class StatTileGrid extends StatelessWidget {
  final List<(String, String)> items;

  const StatTileGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dividerColor = colorScheme.outlineVariant;

    final padded = List<(String, String)>.from(items);
    if (padded.length.isOdd) padded.add(('', ''));

    final rows = <Widget>[];
    for (int i = 0; i < padded.length; i += 2) {
      if (i > 0) {
        rows.add(Container(height: 0.5, color: dividerColor));
      }
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _cell(context, colorScheme, padded[i].$1, padded[i].$2)),
            Container(width: 0.5, color: dividerColor),
            Expanded(child: _cell(context, colorScheme, padded[i + 1].$1, padded[i + 1].$2)),
          ],
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  Widget _cell(BuildContext context, ColorScheme cs, String label, String value) {
    if (label.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary),
          ),
          const SizedBox(height: 3),
          arrowText(
            context,
            value,
            normalStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// Label + value in a side-by-side row. Used for change diffs.
class StatRow extends StatelessWidget {
  final String label;
  final String value;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final valueStyle = normalStyle.copyWith(fontSize: 14);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: bolderNormalStyle.copyWith(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: arrowText(context, value, valueStyle),
        ),
      ],
    );
  }
}
