import 'package:flutter/material.dart';
import '/utilities/constants.dart';

/// Card with a tinted header strip containing the section title, and
/// a padded content area below it for child widgets.
class PropertyCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PropertyCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              title,
              style: bolderNormalStyle.copyWith(
                fontSize: 19,
                color: colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
