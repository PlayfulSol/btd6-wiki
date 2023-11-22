import 'package:btd6wiki/models/bloons/minion_bloon.dart';
import 'package:flutter/material.dart';

class MinionBloonPage extends StatelessWidget {
  final MinionBloon minion;

  const MinionBloonPage({super.key, required this.minion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(minion.name),
      ),
      body: const SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      )),
    );
  }
}
