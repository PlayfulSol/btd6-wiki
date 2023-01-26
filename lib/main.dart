import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '/presentation/widgets/loader.dart';
import '/presentation/screens/tower/towers.dart';

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

  PageController pageController = PageController();

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
      drawer: Drawer(
          child: Drawer(
              child: ListView(children: <Widget>[
        const SizedBox(
            height: 70,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text('Bloons TD 6 Wiki',
                    style: TextStyle(color: Colors.white, fontSize: 28)))),
        ExpansionTile(
          title: Text(titles[0], style: TextStyle(color: Colors.teal)),
          children: [
            ListView.builder(
              itemCount: GlobalState.towerTypes.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(GlobalState.towerTypes[index]),
                  onTap: () {
                    if (!GlobalState.isLoading) {
                      Navigator.pop(context);
                      GlobalState.currentTowerType =
                          GlobalState.towerTypes[index];
                      GlobalState.currentTitle = GlobalState.towerTypes[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Towers(
                                    towerType: GlobalState.towerTypes[index],
                                  )));
                    }
                  },
                );
              },
            ),
          ],
        ),
        ListTile(
            title: Text(titles[1]),
            onTap: () {
              if (!GlobalState.isLoading) {
                Navigator.pop(context);
                GlobalState.currentPageIndex = 1;
                if (GlobalState.currentTowerType != '') {
                  GlobalState.currentTowerType = '';
                }
                GlobalState.currentTitle = titles[1];
                pageController.animateToPage(
                  GlobalState.currentPageIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }),
        ListTile(
            title: Text(titles[2]),
            onTap: () {
              if (!GlobalState.isLoading) {
                Navigator.pop(context);
                GlobalState.currentPageIndex = 2;
                GlobalState.currentTowerType = '';
                GlobalState.currentTitle = titles[2];
                pageController.animateToPage(
                  GlobalState.currentPageIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }),
      ]))),
      appBar: AppBar(
        title: Text(getAppTitle()),
      ),
      body: GlobalState.isLoading
          ? const Loader()
          : PageView(
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() => GlobalState.currentPageIndex = index);
              },
              children: pages,
            ),
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        selectedIndex: GlobalState.currentPageIndex,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.cell_tower),
            title: Text(titles[0]),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: Text(titles[1]),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.nature),
            title: Text(titles[2]),
          ),
        ],
        onItemSelected: (index) => setState(() => {
              GlobalState.currentPageIndex = index,
              GlobalState.currentTowerType = '',
              GlobalState.currentTitle = titles[index],
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease)
            }),
      ),
    );
  }
}
