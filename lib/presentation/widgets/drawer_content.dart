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
  const DrawerContent({
    super.key,
    required this.analyticsHelper,
    required this.pageController,
  });

  final AnalyticsHelper analyticsHelper;
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
  void initState() {
    super.initState();
    var parameters = {
      'screen': drawer,
      'widget': drawer,
      'value': drawerOpened,
    };
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: parameters,
    );
  }

  @override
  void dispose() {
    super.dispose();
    var parameters = {
      'screen': drawer,
      'widget': drawer,
      'value': drawerClosed,
    };
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: parameters,
    );
  }

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
            title: Text(capTitles[kTowersIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              var parameters = {
                'screen': drawer,
                'widget': expanstionTile,
                'value': '${kTowers}_$expended',
              };
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: parameters,
              );
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
                          category: kTowers,
                          option: towerTypes[index],
                        );
                        globalState.updateCurrentPage(
                            simpleTitles[kTowersIndex], kTowersIndex);
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
              capTitles[kHeroesIndex],
              style: titleStyle,
            ),
            onTap: () {
              // logEvent(drawrConst, 'heroes');
              Navigator.pop(context);
              globalState.updateCurrentPage(
                  simpleTitles[kHeroesIndex], kHeroesIndex);
              widget.pageController.jumpToPage(kHeroesIndex);
            },
          ),
          ExpansionTile(
            controller: _bloonsExpansionTileControleer,
            title: Text(capTitles[kBloonsIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              var parameters = {
                'screen': drawer,
                'widget': expanstionTile,
                'value': '${kBloons}_$expended',
              };
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: parameters,
              );
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
                          category: kBloons,
                          option: bloonTypes[index],
                        );
                        globalState.updateCurrentPage(
                            simpleTitles[kBloonsIndex], kBloonsIndex);
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
            title: Text(capTitles[kMapsIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool expended) {
              var parameters = {
                'screen': drawer,
                'widget': expanstionTile,
                'value': '${kMaps}_$expended',
              };
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: parameters,
              );
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
                          category: kMaps,
                          option: mapDifficulties[index],
                        );
                        globalState.updateCurrentPage(
                            simpleTitles[kMapsIndex], kMapsIndex);
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
