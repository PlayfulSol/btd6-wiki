import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '/presentation/widgets/drawer_content.dart';
import '/presentation/widgets/loader.dart';

import '/utilities/requests.dart';
import '/utilities/global_state.dart';
import '/utilities/themes.dart';
import '/utilities/constants.dart';
import '/utilities/utils.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: Themes.lightTheme,
        dark: Themes.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              title: 'BTD6 wiki',
              home: const MyHomePage(),
              debugShowCheckedModeBanner: false,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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

    Future.wait([
      getTowers(),
      getHeroes(),
      getBloons(),
    ]).then((_) => setState(() {
          GlobalState.isLoading = false;
          GlobalState.currentTitle = titles[GlobalState.currentPageIndex];
        }));
  }

  @override
  void initState() {
    super.initState();
    setLoading();
    pageController.addListener(() {
      if (pageController.page?.round() != GlobalState.currentPageIndex &&
          !GlobalState.isLoading) {
        setState(() {
          GlobalState.currentPageIndex = pageController.page?.round() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerContent()),
      appBar: AppBar(
        title: Text(getAppTitle()),
      ),
      body: GlobalState.isLoading
          ? const Loader()
          : PageView(
              controller: pageController,
              // physics: const BouncingScrollPhysics(),
              children: pages,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.cell_tower),
            label: titles[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: titles[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.nature),
            label: titles[2],
          ),
        ],
        currentIndex: GlobalState.currentPageIndex,
        onTap: (index) {
          if (!GlobalState.isLoading) {
            setState(() {
              GlobalState.currentPageIndex = index;
              GlobalState.currentTowerType = '';
            });
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        },
      ),
    );
  }
}
