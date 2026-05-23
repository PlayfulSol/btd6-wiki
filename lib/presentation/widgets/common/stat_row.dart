import 'package:flutter/material.dart';
import '/utilities/constants.dart';

/// Label + value in a flex 2:3 row. Caller is responsible for vertical spacing between rows.
class StatRow extends StatelessWidget {
  final String label;
  final String value;

  const StatRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
          child: Text(value, style: normalStyle.copyWith(fontSize: 14)),
        ),
      ],
    );
  }
}
