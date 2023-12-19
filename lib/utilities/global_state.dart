// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import '/utilities/strings.dart';
import 'constants.dart';

class GlobalState with ChangeNotifier {
  int _currentPageIndex = kTowersIndex;
  String _currentTitle = titles[kTowersIndex];
  String _activeCategory = kTowers;
  Map<String, bool> _isSearchEnabled = {};
  Map<String, String> _currentOptionSelected = {};
  Map<String, String> _currentQuery = {};

  int get currentPageIndex => _currentPageIndex;
  bool get isSearchEnabled => _isSearchEnabled[_activeCategory] ?? false;
  String get currentTitle => _currentTitle;
  String get currentOption => _currentOptionSelected[_activeCategory] ?? 'All';
  String get currentQuery => _currentQuery[_activeCategory] ?? '';
  String get activeCategory => _activeCategory;

  void updateCurrentPage(String pageName, int index) {
    _currentTitle = capitalize(pageName);
    _currentPageIndex = index;
    _activeCategory = pageName;
    notifyListeners();
  }

  void updateCurrentOptionSelected(String category, String option) {
    _currentOptionSelected[category] = option;
    notifyListeners();
  }

  void updateCurrentQuery(String query) {
    _currentQuery[_activeCategory] = query;
    notifyListeners();
  }

  void switchSearch() {
    if (_isSearchEnabled[_activeCategory] == null) {
      _isSearchEnabled[_activeCategory] = true;
    } else {
      _isSearchEnabled[_activeCategory] = !_isSearchEnabled[_activeCategory]!;
    }
    notifyListeners();
  }
}
