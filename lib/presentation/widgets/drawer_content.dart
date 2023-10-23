import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/presentation/screens/maps/maps.dart';
import '/presentation/screens/tower/towers.dart';

import '/utilities/constants.dart';
import '/utilities/global_state.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      const SizedBox(
        width: double.infinity,
        child: SizedBox(
          height: 100,
          child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Bloons TD 6 Wiki',
                  style: TextStyle(color: Colors.white, fontSize: 28))),
        ),
      ),
      ExpansionTile(
        title: Text(titles[0], style: const TextStyle(color: Colors.teal)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: GlobalState.towerTypes.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(GlobalState.towerTypes[index]),
                  onTap: () {
                    if (!GlobalState.isLoading) {
                      Navigator.pop(context);
                      GlobalState.currentTowerType =
                          GlobalState.towerTypes[index];
                      GlobalState.currentTitle = GlobalState.towerTypes[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Towers(
                                    towerType: GlobalState.towerTypes[index],
                                  )));
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
        ],
      ),
      ListTile(
          title: Text(titles[1]),
          onTap: () {
            if (!GlobalState.isLoading) {
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
            }
          }),
      ListTile(
          title: Text(titles[2]),
          onTap: () {
            if (!GlobalState.isLoading) {
              Navigator.pop(context);
              GlobalState.currentPageIndex = 2;
              GlobalState.currentTowerType = '';
              GlobalState.currentTitle = titles[2];
              pageController.animateToPage(
                GlobalState.currentPageIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }),
      ExpansionTile(
        title: Text(titles[3], style: const TextStyle(color: Colors.teal)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: GlobalState.mapDifficulties.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(GlobalState.mapDifficulties[index]),
                  onTap: () {
                    if (!GlobalState.isLoading) {
                      Navigator.pop(context);
                      GlobalState.currentMapDifficulty =
                          GlobalState.mapDifficulties[index];
                      GlobalState.currentTitle =
                          GlobalState.mapDifficulties[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Maps(
                                    mapDifficulty:
                                        GlobalState.mapDifficulties[index],
                                    key: UniqueKey(),
                                  )));
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
      Expanded(
        child: Container(),
      ),
      ListTile(
        leading: const Image(
          image: AssetImage('assets/github_logo.png'),
          width: 24,
          height: 24,
          fit: BoxFit.fill,
        ),
        title: Text(
          'To contribute, visit our GitHub ',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
        onTap: () async {
          final Uri url =
              Uri.parse('https://github.com/PlayfulSol/flutter-btd6-wiki');
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        },
      ),
    ])));
  }
}
