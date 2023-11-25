import 'package:btd6wiki/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '/presentation/widgets/drawer_content.dart';
import '/presentation/widgets/loader.dart';
import '/utilities/requests.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import '/utilities/analytics.dart';
import '/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logEvent('theme_used', AdaptiveThemeMode.system.toString());
  logPageView(titles[0]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              navigatorObservers: <NavigatorObserver>[observer],
              theme: theme,
              darkTheme: darkTheme,
              title: 'BTD6 Wiki',
              home: MyHomePage(
                analytics: analytics,
                observer: observer,
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
  bool isDarkThemeEnabled = true;

  final PageStorageBucket bucket = PageStorageBucket();

  setLoading() async {
    setState(() {
      GlobalState.currentTitle = 'BTD6 wiki';
      GlobalState.isLoading = true;
    });

    Future.wait([getTowers(), getBloonsData(), getMaps(), getHeroes()])
        .then((_) => setState(() {
              GlobalState.isLoading = false;
              GlobalState.currentTitle = titles[GlobalState.currentPageIndex];
            }));
  }

  Future<void> _logCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: titles[GlobalState.currentPageIndex],
      screenClassOverride: titles[GlobalState.currentPageIndex],
    );
  }

  @override
  void initState() {
    super.initState();
    setLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerContent()),
      appBar: AppBar(
        title: Text(GlobalState.currentTitle),
      ),
      body: GlobalState.isLoading
          ? const Loader()
          : PageView(
              controller: pageController,
              children: pages,
              onPageChanged: (index) {
                setState(() {
                  GlobalState.currentPageIndex = index;
                  GlobalState.currentTitle = titles[index];
                  logPageView(titles[index]);
                  _logCurrentScreen();
                });
              }),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75))
          ],
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.cell_tower),
                label: titles[0],
                tooltip: titles[0],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: titles[1],
                tooltip: titles[1],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.nature),
                label: titles[2],
                tooltip: titles[2],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_outlined),
                label: titles[3],
                tooltip: titles[3],
              ),
            ],
            currentIndex: GlobalState.currentPageIndex,
            onTap: (index) {
              logEvent('bottom_navigation', titles[index]);
              setState(() {
                GlobalState.currentTitle = titles[index];
                GlobalState.currentPageIndex = index;
                GlobalState.currentTowerType = '';
                GlobalState.currentMapDifficulty = '';
              });
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }),
      ),
    );
  }
}
