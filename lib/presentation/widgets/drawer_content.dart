import 'package:btd6wiki/presentation/widgets/about_us.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '/presentation/screens/maps/maps.dart';
import '/presentation/screens/tower/towers.dart';

import '/utilities/constants.dart';
import '/utilities/global_state.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final ExpansionTileController _towersExpansionTileController =
      ExpansionTileController();
  final ExpansionTileController _mapsExpansionTileController =
      ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
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
          controller: _towersExpansionTileController,
          title: Text(titles[0], style: const TextStyle(color: Colors.teal)),
          onExpansionChanged: (bool expended) {
            setState(() {
              if (expended) {
                _mapsExpansionTileController.collapse();
              }
            });
          },
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
                        GlobalState.currentTitle =
                            GlobalState.towerTypes[index];
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
                GlobalState.currentTowerType = '';
                GlobalState.currentMapDifficulty = '';
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
                GlobalState.currentMapDifficulty = '';
                GlobalState.currentTitle = titles[2];
                pageController.animateToPage(
                  GlobalState.currentPageIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }),
        ExpansionTile(
          controller: _mapsExpansionTileController,
          title: Text(titles[3], style: const TextStyle(color: Colors.teal)),
          onExpansionChanged: (bool expended) {
            setState(() {
              if (expended) {
                _towersExpansionTileController.collapse();
              }
            });
          },
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
                        GlobalState.currentPageIndex = 3;
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
        Row(children: [
          const AboutUsPopup(),
          ElevatedButton.icon(
              onPressed: null,
              icon: FaIcon(FontAwesomeIcons.googlePlay),
              label: Text('Rate Us'))
        ])
      ],
    ));
  }
}
