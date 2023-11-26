import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/bloons/single_bloon.dart';
import '/models/bloons/minion_bloon.dart';
import '/presentation/screens/bloon/single_bloon.dart';
import '/presentation/screens/bloon/minion_bloon.dart';
import '/utilities/constants.dart';
import '/utilities/global_state.dart';
import '/utilities/images_url.dart';
import '/utilities/utils.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';

class BloonAidWidget extends StatelessWidget {
  const BloonAidWidget({super.key, required this.data, required this.title});

  final dynamic data;
  final String title;

  @override
  Widget build(BuildContext context) {
    String? typeCheck = extractItemTypeFromList(data);
    if (typeCheck == 'obj') {
      return listObject(data, title, context);
    } else if (typeCheck == 'str') {
      List<String> newData = data.cast<String>();
      return listString(newData, title);
    } else {
      return Container();
    }
  }
}

Widget listObject(List<dynamic> data, String title, BuildContext context) {
  return ExpansionTile(
    initiallyExpanded: title == 'Children',
    title: Text(
      title,
      style: smallTitleStyle.copyWith(color: Colors.teal),
    ),
    onExpansionChanged: (value) {
      logEvent(bloonAidConst, 'expand_children');
    },
    childrenPadding: const EdgeInsets.symmetric(vertical: 10),
    children: generateChildren(data, context),
  );
}

Widget generateMinion(Relative relative, BuildContext context) {
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
            onTap: () async {
              var id = relative.id;
              var path = '${minionsDataPath + id}.json';
              final data = await rootBundle.loadString(path);
              var jsonData = json.decode(data);
              logInnerPageView(relative.name);
              MinionBloon bloonData = MinionBloon.fromJson(jsonData);
              GlobalState.currentTitle = bloonData.name;
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MinionBloonPage(minion: bloonData),
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

List<Widget> generateChildren(List<dynamic> data, BuildContext context) {
  List<Widget> items = [];

  for (int index = 0; index < data.length; index++) {
    Relative relative = Relative(
      id: data[index]['id'],
      name: data[index]['name'],
      image: data[index]['image'],
      value: data[index]['value'],
    );
    Card card = Card(
      shadowColor: Colors.black87,
      child: ListTile(
        leading: Image(
          semanticLabel: relative.name,
          image: AssetImage(bloonImage(relative.image)),
        ),
        title: Text(
          relative.name,
          style: normalStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Spawn ${relative.value}',
          style: normalStyle,
        ),
        onTap: () async {
          var id = relative.id;
          var path = '${bloonsDataPath + id}.json';
          final data = await rootBundle.loadString(path);
          var jsonData = json.decode(data);
          SingleBloonModel bloonData = SingleBloonModel.fromJson(jsonData);
          GlobalState.currentTitle = bloonData.name;
          logPageView(relative.name);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBloon(bloon: bloonData),
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

ExpansionTile gimmicks(String title, List<String> gimmicks, bool expand) {
  return ExpansionTile(
    initiallyExpanded: expand,
    title: Text(
      title,
      style: smallTitleStyle.copyWith(color: Colors.teal),
    ),
    onExpansionChanged: (value) {
      logEvent(bloonAidConst, 'expand_gimmicks');
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
