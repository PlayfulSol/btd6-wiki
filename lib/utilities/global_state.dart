import 'package:flutter/material.dart';

class GlobalState with ChangeNotifier {
  String _currentTitle = 'BTD6 Wiki';
  String _currentOptionSelected = 'All';
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

  void resetOption() {
    _currentOptionSelected = 'All';
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
