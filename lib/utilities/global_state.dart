import 'package:flutter/material.dart';
import '/models/maps/map.dart';
import '/models/towers/hero.dart';
import '/models/towers/tower.dart';
import '../models/base/basic_bloon.dart';

class GlobalState with ChangeNotifier {
  String currentTitle = '';
  String currentOption = '';
  int currentPageIndex = 0;
  bool isLoading = false;
}
