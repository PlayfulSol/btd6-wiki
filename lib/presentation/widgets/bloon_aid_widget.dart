import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/bloons/single_bloon.dart';
import '../../utilities/constants.dart';
import '../../utilities/global_state.dart';
import '../../utilities/images_url.dart';
import '../../utilities/utils.dart';
import '../screens/bloon/single_bloon.dart';

class BloonAidWidget extends StatelessWidget {
  const BloonAidWidget({super.key, required this.data, required this.title});

  final dynamic data;
  final String title;

  @override
  Widget build(BuildContext context) {
    String? typeCheck = extractItemTypeFromList(data);
    bool objectType = typeCheck == 'obj' ? true : false;
    bool stringType = typeCheck == 'str' ? true : false;
    // bool mixType = typeCheck == 'mix' ? true : false;
    if (objectType) {
      return listObject(data, title, context);
    } else if (stringType) {
      List<String> newData = data.cast<String>();
      return listString(newData, title);
    } else {
      return Container();
    }
  }
}

Widget listObject(List<dynamic> data, String title, BuildContext context) {
  return ExpansionTile(
    initiallyExpanded: (title == 'Children') ? true : false,
    title: Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.teal)),
    children: generateChildren(data, context),
  );
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
    ListTile tile = ListTile(
      leading: Image(
        image: AssetImage(bloonImage(relative.image)),
      ),
      title: Text(relative.name),
      subtitle: Text('Spawn ${relative.value}'),
      onTap: () async {
        var id = relative.id;
        var path = '${bloonsDataPath + id}.json';
        final data = await rootBundle.loadString(path);
        var jsonData = json.decode(data);
        SingleBloonModel bloonData = SingleBloonModel.fromJson(jsonData);
        GlobalState.currentTitle = bloonData.name;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SingleBloon(bloon: bloonData),
          ),
        );
      },
    );
    items.add(tile);
  }

  return items;
}

Widget listString(List<String> data, String title) {
  return Column(
    children: [
      Text(title, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 5),
      ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              data[index],
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    ],
  );
}
