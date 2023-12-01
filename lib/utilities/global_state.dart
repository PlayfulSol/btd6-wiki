import 'package:btd6wiki/utilities/strings.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class GlobalState with ChangeNotifier {
  String _currentTitle = 'BTD6 Wiki';
  String _activeCategory = towers;
  // ignore: prefer_final_fields
  Map<String, String> _currentOptionSelected = {
    towers: 'All',
    bloons: 'All',
    maps: 'All',
  };
  int _currentPageIndex = 0;

  String get currentTitle => _currentTitle;
  String get activeCategory => _activeCategory;
  Map<String, String> get currentOptionSelected => _currentOptionSelected;
  int get currentPageIndex => _currentPageIndex;

  void updateCurrentPage(String pageName) {
    _currentTitle = capitalize(pageName);
    _activeCategory = pageName;
    notifyListeners();
  }

  void updateCurrentOptionSelected(String category, String option) {
    _currentOptionSelected[category] = option;
    notifyListeners();
  }

  void updateCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void resetOption(String category) {
    _currentOptionSelected[category] = 'All';
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
