import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final ExpansibleController  _towersExpansionTileController =
      ExpansibleController();
  final ExpansibleController _mapsExpansionTileController =
      ExpansibleController();
  final ExpansibleController _bloonsExpansionTileController =
      ExpansibleController();

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

    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        bottom: false,
        child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Text('BTD6 Wiki', style: titleStyle),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: 4),
          ExpansionTile(
            controller: _towersExpansionTileController,
            title: Text(capTitles[kTowersIndex],
                style: titleStyle.copyWith(color: colorScheme.primary)),
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
                    _bloonsExpansionTileController.collapse();
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
                        context.go('/towers');
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
              style: titleStyle.copyWith(color: colorScheme.primary),
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
              context.go('/heroes');
            },
          ),
          ExpansionTile(
            controller: _bloonsExpansionTileController,
            title: Text(capTitles[kBloonsIndex],
                style: titleStyle.copyWith(color: colorScheme.primary)),
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
                        context.go('/bloons');
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
                style: titleStyle.copyWith(color: colorScheme.primary)),
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
                    _bloonsExpansionTileController.collapse();
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
                        context.go('/maps');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AboutUsPopup(
                            analyticsHelper: widget.analyticsHelper),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
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
                          icon: const FaIcon(FontAwesomeIcons.googlePlay,
                              size: 14),
                          label: const Text('Rate Us'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Game version v$gameVersion',
                    style: subtitleStyle.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
