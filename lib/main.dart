import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/firebase_options.dart';
import '/models/base/base_tower.dart';
import '/models/base/base_hero.dart';
import '/models/base/base_map.dart';
import '/models/base_model.dart';
import '/presentation/widgets/drawer_content.dart';
import '/presentation/screens/tower/towers.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/maps/maps.dart';
import '/presentation/widgets/loader.dart';
import '/analytics/analytics.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/requests.dart';
import '/utilities/strings.dart';
import '/utilities/utils.dart';
import '/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  logEvent('theme_used', savedThemeMode.toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    String screenWidth = MediaQuery.of(context).size.width.toStringAsFixed(1);
    logEvent('device_width', screenWidth);
    return AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              navigatorObservers: !kDebugMode
                  ? <NavigatorObserver>[
                      observer,
                    ]
                  : [],
              theme: theme,
              darkTheme: darkTheme,
              title: 'BTD6 Wiki',
              home: ChangeNotifierProvider(
                create: (BuildContext context) => GlobalState(),
                child: MyHomePage(
                  analytics: analytics,
                  observer: observer,
                ),
              ),
              debugShowCheckedModeBanner: false,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.analytics,
    required this.observer,
  });

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  Map<String, dynamic> baseEntities = {
    'towers': <BaseTower>[],
    'heroes': <BaseHero>[],
    'maps': <BaseMap>[],
    'bloons': <BaseModel>[],
    'bosses': <BaseModel>[],
  };

  loadBaseData() async {
    baseEntities[kTowers] = await loadBaseTowers();
    baseEntities[kHeroes] = await loadBaseHeroes();
    baseEntities[kMaps] = await loadBaseMaps();
    baseEntities[kBloons] = await loadBaseBloons();
    baseEntities[kBosses] = await loadBaseBosses();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _logCurrentScreen(int pageIndex) async {
    await widget.analytics.setCurrentScreen(
      screenName: titles[pageIndex],
      screenClassOverride: titles[pageIndex],
    );
  }

  @override
  void initState() {
    super.initState();
    // pageController.addListener(() {
    //   var _currentPage = pageController.page!.round();
    //   print(_currentPage);
    // });
    loadBaseData();
  }

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<GlobalState>();
    return Scaffold(
      drawer: const Drawer(child: DrawerContent()),
      appBar: AppBar(
        title: Consumer<GlobalState>(
          builder: (context, globalState, child) {
            return Text(globalState.currentTitle);
          },
        ),
        actions: [
          Consumer<GlobalState>(
            builder: (context, globalState, child) {
              List<String> options =
                  dropMenuOptions(globalState.currentPageIndex);
              return options.isNotEmpty
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list),
                      onSelected: (String? newValue) {
                        if (newValue != null) {
                          globalState.updateCurrentOptionSelected(
                              globalState.activeCategory, newValue);
                        }
                      },
                      itemBuilder: (context) =>
                          options.map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem<String>(
                          padding: const EdgeInsets.only(left: 16),
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      position: PopupMenuPosition.under,
                      offset: const Offset(30, 7),
                    )
                  : Container();
            },
          ),
          Consumer<GlobalState>(builder: (context, globalState, child) {
            return IconButton(
              onPressed: () {
                globalState.switchSearch();
                if (globalState.isSearchEnabled) {
                  logEvent('search', globalState.activeCategory);
                } else {
                  globalState.updateCurrentQuery('');
                }
              },
              icon: Icon(
                  !globalState.isSearchEnabled ? Icons.search : Icons.close),
            );
          })
        ],
      ),
      body: !isLoading
          ? PageView(
              controller: pageController,
              children: [
                Towers(towers: baseEntities[kTowers]),
                Heroes(heroes: baseEntities[kHeroes]),
                Bloons(
                    bloonsList: baseEntities[kBloons],
                    bossesList: baseEntities[kBosses]),
                Maps(maps: baseEntities[kMaps])
              ],
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                globalState.updateCurrentPage(titles[index], index);
                _logCurrentScreen(index);
              },
            )
          : const Loader(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          type: BottomNavigationBarType.fixed,
          items: [
            for (int i = 0; i < titles.length; i++)
              BottomNavigationBarItem(
                icon: icons[i],
                label: capitalize(titles[i]),
                tooltip: titles[i],
              ),
          ],
          currentIndex: globalState.currentPageIndex,
          onTap: (index) {
            logEvent('bottom_navigation', titles[index]);
            globalState.updateCurrentPage(titles[index], index);
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
