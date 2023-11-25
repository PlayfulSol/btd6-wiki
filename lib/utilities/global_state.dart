import '/models/maps/map.dart';
import '/models/towers/hero.dart';
import '/models/towers/tower.dart';
import '/models/bloons/basic_bloon.dart';

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
