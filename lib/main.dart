import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

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
              title: 'BTD6 Wiki',
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

    Future.wait([getTowers(), getBloons(), getMaps()]).then((_) => setState(() {
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
              setState(() {
                GlobalState.currentPageIndex = index;
                GlobalState.currentTowerType = '';
                GlobalState.currentTitle = titles[index];
              });
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }),
      ),
    );
  }
}
