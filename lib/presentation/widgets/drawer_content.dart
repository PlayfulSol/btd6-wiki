import 'package:flutter/material.dart';

import '/presentation/screens/tower/towers.dart';

import '/utilities/constants.dart';
import '/utilities/global_state.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      const DrawerHeader(
        child: Text('Bloons TD 6 Wiki By Asaf Hadad'),
      ),
      ExpansionTile(
        title: Text(titles[0]),
        children: [
          ListView.builder(
            itemCount: GlobalState.towerTypes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(GlobalState.towerTypes[index]),
                onTap: () {
                  Navigator.pop(context);
                  GlobalState.currentTowerType = GlobalState.towerTypes[index];
                  GlobalState.currentTitle = GlobalState.towerTypes[index];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Towers(
                                towerType: GlobalState.towerTypes[index],
                              )));
                },
              );
            },
          ),
        ],
      ),
      ListTile(
          title: Text(titles[1]),
          onTap: () {
            Navigator.pop(context);
            GlobalState.currentPageIndex = 1;
            if (GlobalState.currentTowerType != '') {
              GlobalState.currentTowerType = '';
            }
            GlobalState.currentTitle = titles[1];
            pageController.animateToPage(
              GlobalState.currentPageIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),
      ListTile(
          title: Text(titles[2]),
          onTap: () {
            Navigator.pop(context);
            GlobalState.currentPageIndex = 2;
            GlobalState.currentTowerType = '';
            GlobalState.currentTitle = titles[2];
            pageController.animateToPage(
              GlobalState.currentPageIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),
    ]));
  }
}