import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/hive/favorite_model.dart';
import '/utilities/constants.dart';

class FavoriteState extends ChangeNotifier {
  late Box<List<dynamic>> _favoriteBox;

  FavoriteState() {
    _favoriteBox = Hive.box<List<dynamic>>(kFavorite);
  }

  Box<List<dynamic>> get favoriteBox => _favoriteBox;

  List<FavoriteModel> getListOfType(String type) {
    if (_favoriteBox.containsKey(type)) {
      return List<FavoriteModel>.from(_favoriteBox.get(type)!);
    }

    return [];
  }

  void toggleFavorite(var item) {
    FavoriteModel favItem = _createFavoriteItem(item);

    if (!_favoriteBox.containsKey(favItem.type)) {
      _favoriteBox.put(favItem.type, [favItem]);
    } else {
      List<FavoriteModel> typeList =
          List<FavoriteModel>.from(_favoriteBox.get(favItem.type)!);
      if (isFavorite(favItem.type, favItem.id)) {
        typeList.removeWhere((element) => element.id == favItem.id);
      } else {
        typeList.add(favItem);
      }
      _favoriteBox.put(favItem.type, typeList);
    }
    notifyListeners();
  }

  bool isFavorite(String type, String id) {
    if (!_favoriteBox.containsKey(type)) return false;
    List<FavoriteModel> typeList =
        List<FavoriteModel>.from(_favoriteBox.get(type)!);
    for (FavoriteModel item in typeList) {
      if (item.id == id) return true;
    }

    return false;
  }

  int _getLastIndexOfType(String type) {
    if (!_favoriteBox.containsKey(type)) {
      return 0;
    } else {
      var favorites = _favoriteBox.get(type)!;
      return favorites.length;
    }
  }

  FavoriteModel _createFavoriteItem(var item) {
    return FavoriteModel(
      item.id,
      item.name,
      item.image,
      item.type,
      _getLastIndexOfType(item.type),
    );
  }

  void updateIndexes(String type, List items) {
    // TODO implement updating indexes of all the items of the type
    // this comes after implementing moveable grid to show the items and change their order
    _favoriteBox.put(type, items);
  }
}
