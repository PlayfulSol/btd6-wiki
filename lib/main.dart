import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/firebase_options.dart';
import '/hive/favorite_model.dart';
import '/models/base/base_tower.dart';
import '/models/base/base_hero.dart';
import '/models/base/base_map.dart';
import '/models/base_model.dart';
import '/presentation/screens/misc/favorite_screen.dart';
import '/presentation/widgets/misc/drawer_content.dart';
import '/presentation/screens/tower/towers.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/maps/maps.dart';
import '/presentation/widgets/misc/loader.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
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
  final analytics = FirebaseAnalytics.instance;
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteModelAdapter());
  await Hive.openBox<List<dynamic>>(
    kFavorite,
    keyComparator: desiredCategoryOrder,
  );
  runApp(MyApp(analytics: analytics));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.analytics});
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalState>(
          create: (BuildContext context) => GlobalState(),
        ),
        ChangeNotifierProvider<FavoriteState>(
          create: (BuildContext context) => FavoriteState(),
        ),
      ],
      child: AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: MyHomePage(
            analytics: analytics,
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.analytics,
  });
  final FirebaseAnalytics analytics;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AnalyticsHelper analyticsHelper;
  late final PageController pageController;

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

  @override
  void initState() {
    super.initState();
    loadBaseData();
    analyticsHelper = AnalyticsHelper(widget.analytics);
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<GlobalState>();
    return Scaffold(
      drawer: Drawer(
          child: DrawerContent(
        analyticsHelper: analyticsHelper,
        pageController: pageController,
      )),
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
                              option: newValue);
                          analyticsHelper.logEvent(
                            name: widgetEngagement,
                            parameters: {
                              'screen': globalState.activeCategory,
                              'widget': appBarFilter,
                              'value': newValue,
                            },
                          );
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
          Consumer<GlobalState>(
            builder: (context, globalState, child) {
              return IconButton(
                onPressed: () {
                  globalState.switchSearch();
                  String value;
                  if (globalState.isSearchEnabled) {
                    value = searchOn;
                  } else {
                    globalState.updateCurrentQuery('');
                    value = searchOff;
                  }
                  analyticsHelper.logEvent(
                    name: widgetEngagement,
                    parameters: {
                      'screen': globalState.activeCategory,
                      'widget': searchButton,
                      'value': value,
                    },
                  );
                },
                icon: Icon(
                    !globalState.isSearchEnabled ? Icons.search : Icons.close),
              );
            },
          ),
          Consumer<FavoriteState>(
            builder: (context, favoriteState, child) {
              IconData favIcon =
                  favoriteState.multiSelect ? Icons.add_task_sharp : Icons.star;
              return GestureDetector(
                onLongPress: () {
                  favoriteState.toggleMultiSelect();
                },
                child: IconButton(
                  onPressed: () {
                    if (!favoriteState.multiSelect) {
                      analyticsHelper.logScreenView(
                        screenClass: kFavoritesClass,
                        screenName: kFavoritesClass,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoriteScreen(
                            analyticsHelper: analyticsHelper,
                          ),
                        ),
                      );
                    } else {
                      favoriteState.toggleMultiSelect();
                    }
                  },
                  icon: Icon(favIcon),
                ),
              );
            },
          ),
        ],
      ),
      body: !isLoading
          ? PageView(
              controller: pageController,
              children: [
                Towers(
                  analyticsHelper: analyticsHelper,
                  towers: baseEntities[kTowers],
                ),
                Heroes(
                  analyticsHelper: analyticsHelper,
                  heroes: baseEntities[kHeroes],
                ),
                Bloons(
                  analyticsHelper: analyticsHelper,
                  bloonsList: baseEntities[kBloons],
                  bossesList: baseEntities[kBosses],
                ),
                Maps(
                  analyticsHelper: analyticsHelper,
                  maps: baseEntities[kMaps],
                )
              ],
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                globalState.updateCurrentPage(simpleTitles[index], index);
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
            for (int i = 0; i < simpleTitles.length; i++)
              BottomNavigationBarItem(
                icon: icons[i],
                label: capitalize(simpleTitles[i]),
                tooltip: simpleTitles[i],
              ),
          ],
          currentIndex: globalState.currentPageIndex,
          onTap: (index) {
            analyticsHelper.logEvent(
              name: widgetEngagement,
              parameters: {
                'screen': globalState.activeCategory,
                'widget': bottomNavBar,
                'value': simpleTitles[index],
              },
            );
            globalState.updateCurrentPage(simpleTitles[index], index);
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
