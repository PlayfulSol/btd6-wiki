import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/hive/favorite_model.dart';
import '/utilities/constants.dart';

class FavoriteState extends ChangeNotifier {
  late Box<List<dynamic>> _favoriteBox;

  bool _multiSelect = false;

  FavoriteState() {
    _favoriteBox = Hive.box<List<dynamic>>(kFavorite);
  }

  Box<List<dynamic>> get favoriteBox => _favoriteBox;
  bool get multiSelect => _multiSelect;

  List<FavoriteModel> getListOfType(String type) {
    if (_favoriteBox.containsKey(type)) {
      return List<FavoriteModel>.from(_favoriteBox.get(type)!);
    }

    return [];
  }

  void toggleMultiSelect() {
    _multiSelect = !_multiSelect;
    notifyListeners();
  }

  void toggleFavoriteFunc(
      BuildContext context, FavoriteState favoriteState, var item) {
    String msg = favoriteState.toggleFavorite(item);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(msg)),
        duration: snackBarDuration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
    notifyListeners();
  }

  String toggleFavorite(var item) {
    bool addedToFavorites = false;
    FavoriteModel favItem = _createFavoriteItem(item);

    if (!_favoriteBox.containsKey(favItem.type)) {
      _favoriteBox.put(favItem.type, [favItem]);
      addedToFavorites = true;
    } else {
      List<FavoriteModel> typeList =
          List<FavoriteModel>.from(_favoriteBox.get(favItem.type)!);
      if (isFavorite(favItem.type, favItem.id)) {
        typeList.removeWhere((element) => element.id == favItem.id);
        addedToFavorites = false;
      } else {
        typeList.add(favItem);
        addedToFavorites = true;
      }
      _favoriteBox.put(favItem.type, typeList);
    }
    notifyListeners();
    return addedToFavorites ? 'Added to favorites!' : 'Removed from favorites.';
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
    );
  }

  void updateIndexes(String type, List items) {
    _favoriteBox.put(type, items);
  }
}
