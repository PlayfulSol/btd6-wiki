import 'package:btd6wiki/presentation/widgets/drawer_content.dart';
import 'package:flutter/material.dart';

import '/presentation/widgets/loader.dart';

import '/utilities/requests.dart';
import '/utilities/global_state.dart';
import '/utilities/themes.dart';
import '/utilities/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTD6 wiki',
      theme: GlobalState.currentTheme == Themes.darkTheme
          ? Themes.darkTheme
          : Themes.lightTheme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDarkThemeEnabled = true;

  void _toggleDarkTheme(val) {
    setState(() {
      isDarkThemeEnabled = val;
    });
    GlobalState.currentTheme =
        isDarkThemeEnabled ? Themes.darkTheme : Themes.lightTheme;
  }

  final PageStorageBucket bucket = PageStorageBucket();

  setLoading() async {
    setState(() {
      GlobalState.currentTitle = 'BTD6 wiki';
      GlobalState.isLoading = true;
    });
    await getTowers();
    await getHeroes();
    await getBloons();
    setState(() {
      GlobalState.isLoading = false;
      GlobalState.currentTitle = titles[GlobalState.currentPageIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    setLoading();
    pageController.addListener(() {
      // when GlobalState.currentPageIndex changes should change the page and the title
      if (pageController.page?.round() != GlobalState.currentPageIndex) {
        setState(() {
          GlobalState.currentPageIndex = pageController.page?.round() ?? 0;
          GlobalState.currentTitle = titles[GlobalState.currentPageIndex];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: isDarkThemeEnabled ? Themes.darkTheme : Themes.lightTheme,
        child: Scaffold(
          drawer: const Drawer(child: DrawerContent()),
          appBar: AppBar(
            title: Text(GlobalState.currentTitle),
            actions: [
              Switch(
                value: isDarkThemeEnabled,
                onChanged: _toggleDarkTheme,
              ),
            ],
          ),
          body: GlobalState.isLoading
              ? const Loader()
              : PageView(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
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
              setState(() {
                GlobalState.currentPageIndex = index;
                GlobalState.currentTitle = titles[index];
              });
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
        ));
  }
}
