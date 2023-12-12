import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/presentation/widgets/about_us.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

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
    int towersIndex = 0;
    int heroesIndex = 1;
    int bloonsIndex = 2;
    int mapsIndex = 3;

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
                      globalState.updateCurrentOptionSelected(
                          kTowers, towerTypes[index]);
                      globalState.updateCurrentPage(
                          titles[towersIndex], towersIndex);
                      pageController.jumpToPage(towersIndex);
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
              globalState.updateCurrentPage(titles[heroesIndex], heroesIndex);
              pageController.jumpToPage(heroesIndex);
            }),
        ListTile(
            title: Text(
              drawrTitles[2],
              style: titleStyle,
            ),
            onTap: () {
              logEvent(drawrConst, 'bloons');
              Navigator.pop(context);
              globalState.updateCurrentPage(titles[bloonsIndex], bloonsIndex);
              pageController.jumpToPage(bloonsIndex);
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
                      globalState.updateCurrentOptionSelected(
                          kMaps, mapDifficulties[index]);
                      globalState.updateCurrentPage(
                          titles[mapsIndex], mapsIndex);
                      pageController.jumpToPage(mapsIndex);
                    },
                  );
                },
              ),
            ),
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
