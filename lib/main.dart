import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '/firebase_options.dart';
import '/presentation/widgets/misc/drawer_content.dart';
import '/presentation/screens/tower/towers.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/maps/maps.dart';
import 'presentation/widgets/common/loader.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/requests.dart';
import '/utilities/router.dart';
import '/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final analytics = FirebaseAnalytics.instance;
  runApp(MyApp(analytics: analytics));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.analytics});
  final FirebaseAnalytics analytics;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  String? loadError;
  late Map<String, dynamic> baseEntities;
  late AppRouter appRouter;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadBaseData();
  }

  Future<void> _loadBaseData() async {
    try {
      final results = await Future.wait([
        SharedPreferences.getInstance(),
        loadBaseTowers(),
        loadBaseHeroes(),
        loadBaseMaps(),
        loadBaseBloons(),
        loadBaseBosses(),
      ]);
      _prefs = results[0] as SharedPreferences;
      baseEntities = {
        kTowers: results[1],
        kHeroes: results[2],
        kMaps: results[3],
        kBloons: results[4],
        kBosses: results[5],
      };
      appRouter = AppRouter(
        analytics: widget.analytics,
        baseEntities: baseEntities,
      );
    } catch (e) {
      setState(() {
        loadError = e.toString();
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Loader(),
        ),
      );
    }

    if (loadError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load app data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(loadError!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalState>(
          create: (BuildContext context) => GlobalState(),
        ),
        ChangeNotifierProvider<FavoriteState>(
          create: (BuildContext context) => FavoriteState(_prefs),
        ),
      ],
      child: AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp.router(
          theme: theme,
          darkTheme: darkTheme,
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.analyticsHelper,
    required this.baseEntities,
    required this.initialPageIndex,
  });
  final AnalyticsHelper analyticsHelper;
  final Map<String, dynamic> baseEntities;
  final int initialPageIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPageIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GlobalState>().updateCurrentPage(
        simpleTitles[widget.initialPageIndex],
        widget.initialPageIndex,
      );
    });
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPageIndex != widget.initialPageIndex) {
      if (pageController.hasClients) {
        pageController.jumpToPage(widget.initialPageIndex);
      }
      final globalState = context.read<GlobalState>();
      globalState.updateCurrentPage(
        simpleTitles[widget.initialPageIndex],
        widget.initialPageIndex,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<GlobalState>();
    return Scaffold(
      drawer: Drawer(
          child: DrawerContent(
        analyticsHelper: widget.analyticsHelper,
        pageController: pageController,
      )),
      appBar: AppBar(
        title: Consumer<GlobalState>(
          builder: (context, globalState, child) {
            return Text(globalState.displayTitle);
          },
        ),
        actions: [
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
                  widget.analyticsHelper.logEvent(
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
              IconData favIcon = favoriteState.isMultiSelectMode
                  ? Icons.add_task_sharp
                  : Icons.star;
              return GestureDetector(
                onLongPress: () {
                  favoriteState.toggleMultiSelect(context);
                },
                child: IconButton(
                  onPressed: () {
                    if (!favoriteState.isMultiSelectMode) {
                      widget.analyticsHelper.logScreenView(
                        screenClass: kFavoritesClass,
                        screenName: kFavoritesClass,
                      );
                      context.push('/favorites');
                    } else {
                      favoriteState.toggleMultiSelect(context);
                    }
                  },
                  icon: Icon(favIcon),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          Towers(
            analyticsHelper: widget.analyticsHelper,
            towers: widget.baseEntities[kTowers],
          ),
          Heroes(
            analyticsHelper: widget.analyticsHelper,
            heroes: widget.baseEntities[kHeroes],
          ),
          Bloons(
            analyticsHelper: widget.analyticsHelper,
            bloonsList: widget.baseEntities[kBloons],
            bossesList: widget.baseEntities[kBosses],
          ),
          Maps(
            analyticsHelper: widget.analyticsHelper,
            maps: widget.baseEntities[kMaps],
          )
        ],
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                globalState.updateCurrentPage(simpleTitles[index], index);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  final routes = ['/towers', '/heroes', '/bloons', '/maps'];
                  final router = GoRouter.of(context);
                  final currentLocation = router.routerDelegate.currentConfiguration.uri.path;
                  final targetRoute = routes[index];
                  if (currentLocation != targetRoute && !currentLocation.startsWith('$targetRoute/')) {
                    router.go(targetRoute);
                  }
                });
              },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: globalState.currentPageIndex,
        onDestinationSelected: (index) {
          widget.analyticsHelper.logEvent(
            name: widgetEngagement,
            parameters: {
              'screen': globalState.activeCategory,
              'widget': bottomNavBar,
              'value': simpleTitles[index],
            },
          );
          final routes = ['/towers', '/heroes', '/bloons', '/maps'];
          context.read<GlobalState>().updateCurrentPage(simpleTitles[index], index);
          context.go(routes[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cell_tower_outlined),
            selectedIcon: Icon(Icons.cell_tower),
            label: 'Towers',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Heroes',
          ),
          NavigationDestination(
            icon: Icon(Icons.bubble_chart_outlined),
            selectedIcon: Icon(Icons.bubble_chart),
            label: 'Bloons',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
      ),
    );
  }
}
