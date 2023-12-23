import 'package:flutter/material.dart';
import '../../analytics/analytics_constants.dart';
import '/models/bloons/common/relative_class.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/minion_bloon.dart';
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
      return listObject(
        bloonId,
        data as List<Relative>,
        title,
        context,
        analyticsHelper,
      );
    } else if (typeCheck == 'str') {
      List<String> newData = data.cast<String>();
      return listString(newData, title);
    } else {
      return Container();
    }
  }
}

Widget listObject(String bloonId, List<Relative> data, String title,
    BuildContext context, AnalyticsHelper analyticsHelper) {
  if (data[0].id != 'none') {
    return ExpansionTile(
      initiallyExpanded: title == 'Children',
      title: Text(
        title,
        style: smallTitleStyle.copyWith(color: Colors.teal),
      ),
      onExpansionChanged: (bool value) {
        analyticsHelper.logEvent(
          name: widgetEngagement,
          parameters: {
            'screen': bloonId,
            'widget': expanstionTile,
            'value': 'children_$value',
          },
        );
      },
      childrenPadding: const EdgeInsets.symmetric(vertical: 10),
      children: generateRelatives(context, data, analyticsHelper),
    );
  } else {
    return Container();
  }
}

Widget generateMinion(
    Relative relative, BuildContext context, AnalyticsHelper analyticsHelper) {
  if (relative.id == "N/A") {
    return Container();
  } else {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 5,
          shadowColor: Colors.black87,
          child: ListTile(
            leading: Image(
              semanticLabel: relative.name,
              image: AssetImage(minionImage(relative.image)),
            ),
            title: Text(
              relative.name,
              style: normalStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Spawn ${relative.value}',
              style: normalStyle,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MinionBloonPage(
                    analyticsHelper: analyticsHelper,
                    minionId: relative.id,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

List<Widget> generateRelatives(BuildContext context, List<Relative> data,
    AnalyticsHelper analyticsHelper) {
  List<Widget> items = [];

  for (int index = 0; index < data.length; index++) {
    Card card = Card(
      shadowColor: Colors.black87,
      child: ListTile(
        leading: Image(
          semanticLabel: data[index].name,
          image: AssetImage(bloonImage(data[index].image)),
        ),
        title: Text(
          data[index].name,
          style: normalStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Spawn ${data[index].value}',
          style: normalStyle,
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBloon(
                analyticsHelper: analyticsHelper,
                bloonId: data[index].id,
              ),
            ),
          );
        },
      ),
    );
    items.add(card);
  }
  return items;
}

Widget listString(List<String> data, String title) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: smallTitleStyle,
      ),
      const SizedBox(height: 5),
      ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              data[index],
              style: normalStyle,
            ),
          );
        },
      ),
    ],
  );
}

ExpansionTile gimmicks(AnalyticsHelper analyticsHelper, String id, String title,
    List<String> gimmicks, bool expand) {
  return ExpansionTile(
    initiallyExpanded: expand,
    title: Text(
      title,
      style: smallTitleStyle.copyWith(color: Colors.teal),
    ),
    onExpansionChanged: (bool value) {
      analyticsHelper.logEvent(
        name: widgetEngagement,
        parameters: {
          'screen': id,
          'widget': expanstionTile,
          'value': 'gimmicks_$value',
        },
      );
    },
    children: gimmicks
        .map<Widget>(
          (item) => ListTile(
            title: Text(
              "- $item",
              style: normalStyle,
            ),
          ),
        )
        .toList(),
  );
}
