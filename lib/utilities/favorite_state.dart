import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/hive/favorite_model.dart';
import '/utilities/constants.dart';

const _categoryOrder = [
  'towers',
  'heroes',
  'bloons',
  'blimps',
  'bosses',
  'maps',
];

class FavoriteState extends ChangeNotifier {
  final SharedPreferences _prefs;
  final Map<String, List<FavoriteModel>> _cache = {};

  bool _isMultiSelectMode = false;
  bool draggableMode = false;

  FavoriteState(this._prefs);

  bool get isMultiSelectMode => _isMultiSelectMode;

  String _key(String type) => 'favorites_$type';

  List<FavoriteModel> getListOfType(String type) {
    return _cache.putIfAbsent(type, () {
      final json = _prefs.getString(_key(type));
      if (json == null) return [];
      return (jsonDecode(json) as List)
          .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  List<String> getActiveCategories() {
    return _categoryOrder
        .where((category) => getListOfType(category).isNotEmpty)
        .toList();
  }

  void _saveList(String type, List<FavoriteModel> items) {
    _cache[type] = items;
    _prefs.setString(
        _key(type), jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  void toggleMultiSelect(BuildContext context) {
    _isMultiSelectMode = !_isMultiSelectMode;
    String msg = _isMultiSelectMode
        ? 'Multi-Select mode is enabled.'
        : 'Multi-Select mode is disabled.';
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

  void toggleFavoriteFunc(BuildContext context, dynamic item) {
    String msg = toggleFavorite(item);
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

  String toggleFavorite(dynamic item) {
    FavoriteModel favItem = _createFavoriteItem(item);
    List<FavoriteModel> typeList = getListOfType(favItem.type);
    bool addedToFavorites;

    if (isFavorite(favItem.type, favItem.id)) {
      typeList.removeWhere((element) => element.id == favItem.id);
      addedToFavorites = false;
    } else {
      typeList.add(favItem);
      addedToFavorites = true;
    }

    _saveList(favItem.type, typeList);
    notifyListeners();
    return addedToFavorites ? 'Added to favorites!' : 'Removed from favorites.';
  }

  bool isFavorite(String type, String id) {
    return getListOfType(type).any((item) => item.id == id);
  }

  FavoriteModel _createFavoriteItem(dynamic item) {
    return FavoriteModel(item.id, item.name, item.image, item.type);
  }

  void updateIndexes(String type, List items) {
    _saveList(type, List<FavoriteModel>.from(items));
  }
}
