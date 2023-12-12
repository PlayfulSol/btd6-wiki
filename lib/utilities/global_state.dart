// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import '/analytics/analytics.dart';
import '/utilities/strings.dart';
import 'constants.dart';

class GlobalState with ChangeNotifier {
  int _currentPageIndex = 0;
  String _currentTitle = 'BTD6 Wiki';
  String _activeCategory = kTowers;
  bool _isSearchEnabled = false;
  Map<String, String> _currentOptionSelected = {};
  Map<String, String> _currentQuery = {};

  int get currentPageIndex => _currentPageIndex;
  bool get isSearchEnabled => _isSearchEnabled;
  String get currentTitle => _currentTitle;
  String get activeCategory => _activeCategory;
  String get currentOption => _currentOptionSelected[_activeCategory] ?? 'All';
  String get currentQuery => _currentQuery[_activeCategory] ?? '';

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
    _isSearchEnabled = !_isSearchEnabled;
    if (_isSearchEnabled) {
      logEvent('search', _activeCategory);
    } else {
      _currentQuery[_activeCategory] = '';
    }
    notifyListeners();
  }

  void resetTitle() {
    _currentTitle = 'BTD6 Wiki';
    notifyListeners();
  }

  void resetPageIndex() {
    _currentPageIndex = 0;
    notifyListeners();
  }
}
