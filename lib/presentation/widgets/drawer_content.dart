import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/presentation/screens/maps/maps.dart';
import '/presentation/screens/tower/towers.dart';
import '/presentation/widgets/about_us.dart';
import '/utilities/utils.dart';
import '/utilities/constants.dart';
import '/utilities/global_state.dart';
import '/analytics/analytics.dart';
import '/analytics/analytics_constants.dart';

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
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 50, 0, 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Bloons TD 6 Wiki',
              style: bigTitleStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
        ExpansionTile(
          controller: _towersExpansionTileController,
          title:
              Text(drawrTitles[0], style: const TextStyle(color: Colors.teal)),
          onExpansionChanged: (bool expended) {
            logEvent(drawrConst, 'towers_expanded');
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
                      logEvent(
                          'menu_tower_type', GlobalState.towerTypes[index]);
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
            title: Text(drawrTitles[1]),
            onTap: () {
              logEvent(drawrConst, 'heroes');
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
            title: Text(drawrTitles[2]),
            onTap: () {
              logEvent(drawrConst, 'bloons');
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
          title:
              Text(drawrTitles[3], style: const TextStyle(color: Colors.teal)),
          onExpansionChanged: (bool expended) {
            logEvent(drawrConst, 'maps_expanded');
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
                      logEvent('menu_map_difficulty',
                          GlobalState.mapDifficulties[index]);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const AboutUsPopup(),
            ElevatedButton.icon(
              onPressed: () => {
                logEvent('rate_us', 'rate_us'),
                openUrl(
                    'https://play.google.com/store/apps/details?id=asafhadad.btd6wiki')
              },
              icon: const FaIcon(FontAwesomeIcons.googlePlay),
              label: const Text('Rate Us'),
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ));
  }
}
