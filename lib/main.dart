import 'package:btd6wiki/firebase_options.dart';
import 'package:btd6wiki/models/base_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import '/presentation/widgets/drawer_content.dart';
import '/utilities/requests.dart';
import '/utilities/global_state.dart';
import '/utilities/constants.dart';
import 'analytics/analytics.dart';
import '/themes/themes.dart';
import 'models/base/base_hero.dart';
import 'models/base/base_map.dart';
import 'models/base/base_tower.dart';
import 'utilities/utils.dart';

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
    logEvent(
        'device_width', MediaQuery.of(context).size.width.toStringAsFixed(1));

    return AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              navigatorObservers: <NavigatorObserver>[
                observer,
              ],
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
  Map<String, dynamic> baseEntities = {
    'towers': <BaseTower>[],
    'heroes': <BaseHero>[],
    'maps': <BaseMap>[],
    'bloons': <BaseModel>[],
    'bosses': <BaseModel>[],
  };

  loadBaseData() async {
    baseEntities[towers] = await loadBaseTowers();
    baseEntities[heroes] = await loadBaseHeroes();
    baseEntities[maps] = await loadBaseMaps();
    baseEntities[bloons] = await loadBaseBloons();
    baseEntities[bosses] = await loadBaseBosses();
  }

  // Future<void> _logCurrentScreen() async {
  //   await widget.analytics.setCurrentScreen(
  //     screenName: titles[GlobalState.currentPageIndex],
  //     screenClassOverride: titles[GlobalState.currentPageIndex],
  //   );
  // }

  @override
  void initState() {
    super.initState();
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
          Consumer<GlobalState>(builder: (context, globalState, child) {
            return DropdownMenu<String>(
              leadingIcon: const Icon(Icons.filter_list),
              onSelected: (String? newValue) {
                globalState.updateCurrentOptionSelected(newValue!);
                //TODO - filter the current page
              },
              dropdownMenuEntries: dropmenuOptions(globalState.currentPageIndex)
                  .map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            );
          }),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (index) {
          globalState.updateCurrentPageIndex(index);
          globalState.updateCurrentTitle(titles[index]);
        },
      ),
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
                label: titles[i],
                tooltip: titles[i],
              ),
          ],
          currentIndex: globalState.currentPageIndex,
          onTap: (index) {
            logEvent('bottom_navigation', titles[index]);
            globalState.updateCurrentPageIndex(index);
            globalState.updateCurrentTitle(titles[index]);
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
      ),
    );
  }
}
