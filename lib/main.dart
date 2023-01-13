import 'package:flutter/material.dart';

import '/presentation/screens/tower/towers.dart';
import '/presentation/screens/hero/heroes.dart';
import '/presentation/screens/bloon/bloons.dart';
import '/presentation/widgets/loader.dart';

import '/utilities/requests.dart';
import '/utilities/global_state.dart';
import '/utilities/themes.dart';

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
  int _selectedIndex = 0;
  bool isDarkThemeEnabled = true;

  void _toggleDarkTheme(val) {
    setState(() {
      isDarkThemeEnabled = val;
    });
    GlobalState.currentTheme =
        isDarkThemeEnabled ? Themes.darkTheme : Themes.lightTheme;
  }

  final PageController _pageController = PageController();

  final List<String> titles = [
    'Towers',
    'Heroes',
    'Bloons',
  ];

  final List<Widget> pages = [
    const Towers(key: PageStorageKey<String>('Towers')),
    const Heroes(key: PageStorageKey<String>('Heroes')),
    const Bloons(key: PageStorageKey<String>('Bloons')),
  ];

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
      GlobalState.currentTitle = titles[_selectedIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    setLoading();
    _pageController.addListener(() {
      var page = _pageController.page!.floor();
      setState(() {
        _selectedIndex = page;
        GlobalState.currentTitle = titles[page];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: isDarkThemeEnabled ? Themes.darkTheme : Themes.lightTheme,
        child: Scaffold(
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
                  controller: _pageController,
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
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                GlobalState.currentTitle = titles[index];
              });
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
        ));
  }
}
