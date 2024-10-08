import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/hive/favorite_model.dart';
import '/utilities/constants.dart';

class FavoriteState extends ChangeNotifier {
  late Box<List<dynamic>> _favoriteBox;

  bool _isMultiSelectMode = false;
  bool draggableMode = false;

  FavoriteState() {
    _favoriteBox = Hive.box<List<dynamic>>(kFavorite);
  }

  Box<List<dynamic>> get favoriteBox => _favoriteBox;
  bool get isMultiSelectMode => _isMultiSelectMode;

  List<FavoriteModel> getListOfType(String type) {
    if (_favoriteBox.containsKey(type)) {
      return List<FavoriteModel>.from(_favoriteBox.get(type)!);
    }

    return [];
  }

  List<String> getActiveCategories() {
    List<String> categories = List<String>.from(_favoriteBox.keys.toList());
    List<String> nonEmptyCategories = categories.where((category) {
      List<FavoriteModel> items = getListOfType(category);
      return items.isNotEmpty;
    }).toList();
    return nonEmptyCategories;
  }

  void toggleMultiSelect(BuildContext context) {
    _isMultiSelectMode = !_isMultiSelectMode;
    String msg;
    if (_isMultiSelectMode) {
      msg = 'Multi-Select mode is enabled.';
    } else {
      msg = 'Multi-Select mode is disabled.';
    }
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

  void toggleDrag(bool dragStatus) {
    draggableMode = dragStatus;
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
