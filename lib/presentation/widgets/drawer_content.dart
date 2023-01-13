import 'package:btd6wiki/utilities/global_state.dart';
import 'package:flutter/material.dart';

import 'package:btd6wiki/utilities/constants.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      const DrawerHeader(
        child: Text('Bloons TD 6 Wiki By Asaf Hadad'),
      ),
      // ...pages.map(
      //   (page) => ListTile(
      //       title: Text(titles[pages.indexOf(page)]),
      //       onTap: () {
      //         Navigator.pop(context);
      //         GlobalState.currentPageIndex = pages.indexOf(page);
      //         pageController.animateToPage(
      //           GlobalState.currentPageIndex,
      //           duration: const Duration(milliseconds: 500),
      //           curve: Curves.easeInOut,
      //         );
      //       }),
      // ),
      ExpansionTile(
        title: Text(titles[0]),
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: GlobalState.towerTypes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(GlobalState.towerTypes[index]),
                onTap: () {
                  Navigator.pop(context);
                  GlobalState.currentPageIndex = 0;
                  GlobalState.currentTitle = titles[0];
                  pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
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
            pageController.animateToPage(
              GlobalState.currentPageIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }),
    ]));
  }
}
