import "package:btd6wiki/models/maps/map.dart";
import '/models/bloons/basic_bloon.dart';
import 'package:btd6wiki/models/towers/hero.dart';
import 'package:btd6wiki/models/towers/tower.dart';

class GlobalState {
  GlobalState._();

  static String currentTitle = '';
  static int currentPageIndex = 0;
  static String currentTowerType = '';
  static bool isLoading = false;
  static List<TowerModel> towers = [];
  static List<String> towerTypes = [];
  static List<HeroModel> heroes = [];
  static List<MenuHeroModel> menuHeroes = [];
  static List<BasicBloonModel> bloons = [];
  static List<BasicBloonModel> bosses = [];
  static List<MapModel> maps = [];
  static String currentMapDifficulty = '';
  static List<String> mapDifficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
}
