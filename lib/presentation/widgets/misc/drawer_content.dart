import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'about_us.dart';
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
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: {
        'screen': drawer,
        'widget': drawer,
        'value': drawerOpened,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.analyticsHelper.logEvent(
      name: widgetEngagement,
      parameters: {
        'screen': drawer,
        'widget': drawer,
        'value': drawerClosed,
      },
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
            onExpansionChanged: (bool value) {
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': drawer,
                  'widget': expansionTile,
                  'value': '${kTowers}_$value',
                },
              );
              setState(
                () {
                  if (value) {
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
                        Navigator.pop(context);
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': drawer,
                            'widget': listTile,
                            'value': '${kTowers}_${towerTypes[index]}',
                          },
                        );
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
              Navigator.pop(context);
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': drawer,
                  'widget': listTile,
                  'value': kHeroes,
                },
              );
              globalState.updateCurrentPage(
                  simpleTitles[kHeroesIndex], kHeroesIndex);
              widget.pageController.jumpToPage(kHeroesIndex);
            },
          ),
          ExpansionTile(
            controller: _bloonsExpansionTileControleer,
            title: Text(capTitles[kBloonsIndex],
                style: titleStyle.copyWith(color: Colors.teal)),
            onExpansionChanged: (bool value) {
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': drawer,
                  'widget': expansionTile,
                  'value': '${kBloons}_$value',
                },
              );
              setState(
                () {
                  if (value) {
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
                        Navigator.pop(context);
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': drawer,
                            'widget': listTile,
                            'value': '${kBloons}_${bloonTypes[index]}',
                          },
                        );
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
            onExpansionChanged: (bool value) {
              widget.analyticsHelper.logEvent(
                name: widgetEngagement,
                parameters: {
                  'screen': drawer,
                  'widget': expansionTile,
                  'value': '${kMaps}_$value',
                },
              );
              setState(
                () {
                  if (value) {
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
                        Navigator.pop(context);
                        widget.analyticsHelper.logEvent(
                          name: widgetEngagement,
                          parameters: {
                            'screen': drawer,
                            'widget': listTile,
                            'value': '${kMaps}_${mapDifficulties[index]}',
                          },
                        );
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
              AboutUsPopup(analyticsHelper: widget.analyticsHelper),
              ElevatedButton.icon(
                onPressed: () {
                  widget.analyticsHelper.logEvent(
                    name: buttonPress,
                    parameters: {
                      'screen': drawer,
                      'button': rateUsButton,
                      'value': buttonOpen,
                    },
                  );
                  openUrl(googleLink);
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
