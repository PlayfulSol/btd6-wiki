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
  const DrawerContent({super.key, required this.pageController});

  final PageController pageController;
  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final ExpansionTileController _towersExpansionTileController =
      ExpansionTileController();
  final ExpansionTileController _mapsExpansionTileController =
      ExpansionTileController();
  final ExpansionTileController _bloonsExpansionTileControleer =
      ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);

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
            title: Text(titles[kTowersIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              // logEvent(drawrConst, 'towers_expanded');
              setState(
                () {
                  if (expended) {
                    _mapsExpansionTileController.collapse();
                    _bloonsExpansionTileControleer.collapse();
                  }
                },
              );
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
                        // logEvent('menu_tower_type', towerTypes[index]);
                        Navigator.pop(context);
                        globalState.updateCurrentOptionSelected(
                            kTowers, towerTypes[index]);
                        globalState.updateCurrentPage(
                            titles[kTowersIndex], kTowersIndex);
                        widget.pageController.jumpToPage(kTowersIndex);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              titles[kHeroesIndex],
              style: titleStyle,
            ),
            onTap: () {
              // logEvent(drawrConst, 'heroes');
              Navigator.pop(context);
              globalState.updateCurrentPage(titles[kHeroesIndex], kHeroesIndex);
              widget.pageController.jumpToPage(kHeroesIndex);
            },
          ),
          ExpansionTile(
            controller: _bloonsExpansionTileControleer,
            title: Text(titles[kBloonsIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              // logEvent(drawrConst, 'bloons_expanded');
              setState(
                () {
                  if (expended) {
                    _towersExpansionTileController.collapse();
                    _mapsExpansionTileController.collapse();
                  }
                },
              );
            },
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: bloonTypes.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        bloonTypes[index],
                        style: bolderNormalStyle,
                      ),
                      onTap: () {
                        // logEvent('bloon_type', bloonTypes[index]);
                        Navigator.pop(context);
                        globalState.updateCurrentOptionSelected(
                            kBloons, bloonTypes[index]);
                        globalState.updateCurrentPage(
                            titles[kBloonsIndex], kBloonsIndex);
                        widget.pageController.jumpToPage(kBloonsIndex);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          ExpansionTile(
            controller: _mapsExpansionTileController,
            title: Text(titles[kMapsIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              // logEvent(drawrConst, 'maps_expanded');
              setState(
                () {
                  if (expended) {
                    _bloonsExpansionTileControleer.collapse();
                    _towersExpansionTileController.collapse();
                  }
                },
              );
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
                        // logEvent('menu_map_difficulty', mapDifficulties[index]);
                        Navigator.pop(context);
                        globalState.updateCurrentOptionSelected(
                            kMaps, mapDifficulties[index]);
                        globalState.updateCurrentPage(
                            titles[kMapsIndex], kMapsIndex);
                        widget.pageController.jumpToPage(kMapsIndex);
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
                  // logEvent('rate_us', 'rate_us'),
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
      ),
    );
  }
}
