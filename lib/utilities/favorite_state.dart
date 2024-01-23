import 'package:btd6wiki/utilities/constants.dart';
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

  void fillList(String category, List<BaseModel> baseObjects) {
    loadFavoriteBox();
    if (favoriteBox.get(category.toString()) != null) {
      List favoritesIds = favoriteBox.get(category.toString());

      for (var baseObj in baseObjects) {
        if (favoritesIds.contains(baseObj.id)) {
          BaseModel item = BaseModel(
            baseObj.id,
            baseObj.name,
            baseObj.image,
            baseObj.type,
          );
          _addToList(category, item);
        }
      }
    } else {
      print('$category is empty');
      favoriteBox.get(category.toString(), defaultValue: []);
    }
  }

  bool isInFavorites(String category, String itemId) {
    switch (category) {
      case kTowers:
        return towers.any((tower) => tower.id == itemId);
      case kHeroes:
        return heroes.any((hero) => hero.id == itemId);
      case kBloons:
        return bloons.any((bloon) => bloon.id == itemId);
      case kBosses:
        return bosses.any((boss) => boss.id == itemId);
      case kMaps:
        return maps.any((map) => map.id == itemId);
    }
    return false;
  }

  void _addToList(String category, BaseModel item) {
    switch (category) {
      case kTowers:
        towers.add(item);
        break;
      case kHeroes:
        heroes.add(item);
        break;
      case kBloons:
        bloons.add(item);
        break;
      case kBosses:
        bosses.add(item);
        break;
      case kMaps:
        maps.add(item);
        break;
    }
    notifyListeners();
  }

  void _removeFromList(String category, String itemId) {
    switch (category) {
      case kTowers:
        towers.removeWhere((tower) => tower.id == itemId);
        break;
      case kHeroes:
        heroes.removeWhere((hero) => hero.id == itemId);
        break;
      case kBloons:
        bloons.removeWhere((bloon) => bloon.id == itemId);
        break;
      case kBosses:
        bosses.removeWhere((boss) => boss.id == itemId);
        break;
      case kMaps:
        maps.removeWhere((map) => map.id == itemId);
        break;
    }
    notifyListeners();
  }

  void addFavorite(String category, BaseModel item) {
    _addToList(category, item);
  }

  void removeFavorite(String category, String itemId) {
    _removeFromList(category, itemId);
  }
}
