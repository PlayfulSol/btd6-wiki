import 'package:flutter/material.dart';
import '/utilities/strings.dart';
import 'constants.dart';

class GlobalState with ChangeNotifier {
  int _currentPageIndex = kTowersIndex;
  String _currentTitle = capTitles[kTowersIndex];
  String _activeCategory = kTowers;
  final Map<String, bool> _isSearchEnabled = {};
  final Map<String, String> _currentOptionSelected = {};
  final Map<String, String> _currentQuery = {};

  int get currentPageIndex => _currentPageIndex;
  bool get isSearchEnabled => _isSearchEnabled[_activeCategory] ?? false;
  String get currentTitle => _currentTitle;
  String get currentOption => _currentOptionSelected[_activeCategory] ?? 'All';
  String optionForCategory(String category) => _currentOptionSelected[category] ?? 'All';
  String get currentQuery => _currentQuery[_activeCategory] ?? '';
  String get activeCategory => _activeCategory;

  String get displayTitle {
    final option = currentOption;
    if (option == 'All') return _currentTitle;
    if (_activeCategory == kHeroes) return '$_currentTitle — $option Start';
    return '$_currentTitle — $option';
  }

  void updateCurrentPage(String pageName, int index) {
    _currentTitle = capitalize(pageName);
    _currentPageIndex = index;
    _activeCategory = pageName;
    notifyListeners();
  }

  void updateCurrentOptionSelected({String? category, required String option}) {
    _currentOptionSelected[category ?? _activeCategory] = option;
    notifyListeners();
  }

  void updateCurrentQuery(String query) {
    _currentQuery[_activeCategory] = query;
    notifyListeners();
  }

  void switchSearch() {
    _isSearchEnabled[_activeCategory] = !(_isSearchEnabled[_activeCategory] ?? false);
    notifyListeners();
  }
}
