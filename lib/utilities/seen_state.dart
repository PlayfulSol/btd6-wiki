import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Set to true when the seen-tracking feature is ready to ship.
const kTrackSeen = true;

class SeenState extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const _key = 'seen_changes';

  SeenState(this._prefs) {
    if (!kTrackSeen) _prefs.remove(_key);
  }

  bool isSeen(String id) {
    if (!kTrackSeen) return false;
    return Set<String>.from(_prefs.getStringList(_key) ?? []).contains(id);
  }

  void markSeen(String id) {
    if (!kTrackSeen) return;
    final ids = Set<String>.from(_prefs.getStringList(_key) ?? []);
    if (ids.add(id)) {
      _prefs.setStringList(_key, ids.toList());
      notifyListeners();
    }
  }

  static const _onboardingKey = 'has_seen_onboarding';

  // Set to false before shipping to enable one-time behaviour.
  static const kForceOnboarding = false;

  bool get shouldShowOnboarding =>
      kForceOnboarding || !(_prefs.getBool(_onboardingKey) ?? false);

  void markOnboardingSeen() {
    if (kForceOnboarding) return;
    if (_prefs.getBool(_onboardingKey) ?? false) return;
    _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }
}
