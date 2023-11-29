import 'package:flutter/material.dart';

class GlobalState with ChangeNotifier {
  String _currentTitle = '';
  String _currentOptionSelected = '';
  int _currentPageIndex = 0;

  String get currentTitle => _currentTitle;
  String get currentOptionSelected => _currentOptionSelected;
  int get currentPageIndex => _currentPageIndex;

  void updateCurrentTitle(String title) {
    _currentTitle = title;
    notifyListeners();
  }

  void updateCurrentOptionSelected(String option) {
    _currentOptionSelected = option;
    notifyListeners();
  }

  void updateCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
