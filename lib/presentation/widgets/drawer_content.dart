import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    int towersPage = 0;
    int heroesPage = 1;
    int bloonsPage = 2;
    int mapsPage = 3;

    return Drawer(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 50, 0, 10),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Bloons TD 6 Wiki',
              style: bigTitleStyle,
            ),
          ),
        ),
        ExpansionTile(
          controller: _towersExpansionTileController,
          title: Text(drawrTitles[0],
              style: titleStyle.copyWith(color: Colors.teal)),
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
                itemCount: towerTypes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      towerTypes[index],
                      style: bolderNormalStyle,
                    ),
                    onTap: () {
                      logEvent('menu_tower_type', towerTypes[index]);
                      Navigator.pop(context);
                      globalState
                          .updateCurrentOptionSelected(towerTypes[index]);
                      globalState.updateCurrentTitle(titles[towersPage]);
                      globalState.updateCurrentPageIndex(towersPage);
                      pageController.jumpToPage(towersPage);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        ListTile(
            title: Text(
              drawrTitles[1],
              style: titleStyle,
            ),
            onTap: () {
              logEvent(drawrConst, 'heroes');
              Navigator.pop(context);
              globalState.updateCurrentTitle(titles[heroesPage]);
              globalState.updateCurrentPageIndex(heroesPage);
              pageController.jumpToPage(heroesPage);
            }),
        ListTile(
            title: Text(
              drawrTitles[2],
              style: titleStyle,
            ),
            onTap: () {
              logEvent(drawrConst, 'bloons');
              Navigator.pop(context);
              globalState.updateCurrentTitle(titles[bloonsPage]);
              globalState.updateCurrentPageIndex(bloonsPage);
              pageController.jumpToPage(bloonsPage);
            }),
        ExpansionTile(
          controller: _mapsExpansionTileController,
          title: Text(drawrTitles[3],
              style: titleStyle.copyWith(color: Colors.teal)),
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
                itemCount: mapDifficulties.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      mapDifficulties[index],
                      style: bolderNormalStyle,
                    ),
                    onTap: () {
                      logEvent('menu_map_difficulty', mapDifficulties[index]);
                      Navigator.pop(context);
                      globalState
                          .updateCurrentOptionSelected(mapDifficulties[index]);
                      globalState.updateCurrentTitle(titles[mapsPage]);
                      globalState.updateCurrentPageIndex(mapsPage);
                      pageController.jumpToPage(mapsPage);
                    },
                  );
                },
              ),
            )
          ],
        ),
        const Spacer(),
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
