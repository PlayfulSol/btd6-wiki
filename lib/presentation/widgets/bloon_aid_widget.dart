import 'package:flutter/material.dart';

import '../../models/bloons/single_bloon.dart';
import '../../utilities/images_url.dart';
import '../../utilities/utils.dart';

class BloonAidWidget extends StatelessWidget {
  const BloonAidWidget({super.key, required this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    String? typeCheck = extractItemTypeFromList(data);
    bool objectType = typeCheck == 'obj' ? true : false;
    bool stringType = typeCheck == 'str' ? true : false;
    // bool mixType = typeCheck == 'mix' ? true : false;
    if (objectType) {
      return listObject(data);
    } else if (stringType) {
      List<String> newData = data.cast<String>();

      return listString(newData);
    } else {
      return const Text('Something went wrong');
    }
  }
}

Widget listString(List<String> data) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data.length,
    itemBuilder: (context, index) {
      return Text(data[index]);
    },
  );
}

Widget listObject(List<dynamic> data) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data.length,
    itemBuilder: (context, index) {
      Relative relative = Relative(
        id: data[index]['id'],
        name: data[index]['name'],
        image: data[index]['image'],
        value: data[index]['value'],
      );

      return ListTile(
        leading: Image(
          image: AssetImage(bloonImage(relative.image)),
        ),
        title: Text(relative.name),
        subtitle: Text(relative.value),
      );
    },
  );
}
