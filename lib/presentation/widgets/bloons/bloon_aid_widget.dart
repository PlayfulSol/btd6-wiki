import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/bloons/common/relative_class.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/property_card.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

class BloonAidWidget extends StatelessWidget {
  const BloonAidWidget({
    super.key,
    required this.bloonId,
    required this.analyticsHelper,
    required this.data,
    required this.title,
  });

  final AnalyticsHelper analyticsHelper;
  final dynamic data;
  final String title;
  final String bloonId;

  @override
  Widget build(BuildContext context) {
    String? typeCheck = extractItemTypeFromList(data);
    if (typeCheck == 'obj') {
      return _listObject(
        bloonId,
        data as List<Relative>,
        title,
        context,
        analyticsHelper,
      );
    } else if (typeCheck == 'str') {
      List<String> newData = data.cast<String>();
      return _listString(newData, title);
    } else {
      return const SizedBox.shrink();
    }
  }
}

Widget _listObject(String bloonId, List<Relative> data, String title,
    BuildContext context, AnalyticsHelper analyticsHelper) {
  if (data[0].id != 'none') {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: title == 'Children',
        title: Text(
          title,
          style: smallTitleStyle.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        onExpansionChanged: (bool value) {
          analyticsHelper.logEvent(
            name: widgetEngagement,
            parameters: {
              'screen': bloonId,
              'widget': expansionTile,
              'value': 'children_$value',
            },
          );
        },
        childrenPadding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
        children: _generateRelatives(context, data, analyticsHelper),
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}


List<Widget> _generateRelatives(BuildContext context, List<Relative> data,
    AnalyticsHelper analyticsHelper) {
  final colorScheme = Theme.of(context).colorScheme;
  return data.map((item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => context.go('/bloons/${item.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: AppImage(path: bloonImage(item.image)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item.name,
                    style: normalStyle.copyWith(fontWeight: FontWeight.w600)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '×${item.value}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }).toList();
}

Widget _listString(List<String> data, String title) {
  return PropertyCard(
    title: title,
    children: data.map((item) => Text(item, style: normalStyle)).toList(),
  );
}

class GimmicksWidget extends StatelessWidget {
  const GimmicksWidget({
    super.key,
    required this.analyticsHelper,
    required this.id,
    required this.title,
    required this.gimmicks,
    required this.expand,
  });

  final AnalyticsHelper analyticsHelper;
  final String id;
  final String title;
  final List<String> gimmicks;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: expand,
      title: Text(
        title,
        style: smallTitleStyle.copyWith(
            color: Theme.of(context).colorScheme.primary),
      ),
      onExpansionChanged: (bool value) {
        analyticsHelper.logEvent(
          name: widgetEngagement,
          parameters: {
            'screen': id,
            'widget': expansionTile,
            'value': 'gimmicks_$value',
          },
        );
      },
      children: gimmicks
          .map<Widget>(
            (item) => ListTile(
              title: Text('- $item', style: normalStyle),
            ),
          )
          .toList(),
    );
  }
}
