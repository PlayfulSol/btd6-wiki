import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '/models/base_model.dart';

class FavoriteState with ChangeNotifier {
  var favoriteBox;
  List<BaseModel> towers = [];
  List<BaseModel> heroes = [];
  List<BaseModel> bloons = [];
  List<BaseModel> bosses = [];
  List<BaseModel> maps = [];

  void loadFavoriteBox() {
    favoriteBox = Hive.box('favorite');
  }

  void fillList(String category, List baseObjects) {
    loadFavoriteBox();
    List favoritesIds = favoriteBox.get(category);

    for (var baseObj in baseObjects) {
      if (favoritesIds.contains(baseObj.id)) {
        BaseModel item = BaseModel(
          baseObj.id,
          baseObj.name,
          baseObj.image,
          baseObj.type,
        );
        towers.add(item);
      }
    }
  }

  bool isFavoriteTower(String towerId) {
    return towers.any((tower) => tower.id == towerId);
  }

  void addFavoriteTower(BaseModel tower) {
    towers.add(tower);
    notifyListeners();
  }

  void removeFavoriteTower(String towerId) {
    towers.removeWhere((tower) => tower.id == towerId);
    notifyListeners();
  }

  void addFavoriteHero(BaseModel hero) {
    heroes.add(hero);
    notifyListeners();
  }

  void removeFavoriteHero(BaseModel hero) {
    heroes.remove(hero);
    notifyListeners();
  }

  void addFavoriteBloon(BaseModel bloon) {
    bloons.add(bloon);
    notifyListeners();
  }

  void removeFavoriteBloon(BaseModel bloon) {
    bloons.remove(bloon);
    notifyListeners();
  }

  void addFavoriteBoss(BaseModel boss) {
    bosses.add(boss);
    notifyListeners();
  }

  void removeFavoriteBoss(BaseModel boss) {
    bosses.remove(boss);
    notifyListeners();
  }

  void addFavoriteMap(BaseModel map) {
    maps.add(map);
    notifyListeners();
  }

  void removeFavoriteMap(BaseModel map) {
    maps.remove(map);
    notifyListeners();
  }
}
