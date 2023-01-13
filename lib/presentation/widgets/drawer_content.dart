import 'package:btd6wiki/utilities/global_state.dart';
import 'package:flutter/material.dart';

import 'package:btd6wiki/utilities/constants.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text('Bloons TD 6 Wiki By Asaf Hadad'),
          ),
          ...pages.map(
            (page) => ListTile(
                title: Text(titles[pages.indexOf(page)]),
                onTap: () {
                  Navigator.pop(context);
                  GlobalState.currentPageIndex = pages.indexOf(page);
                  pageController.animateToPage(
                    GlobalState.currentPageIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
