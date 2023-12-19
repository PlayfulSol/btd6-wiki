import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  final FirebaseAnalytics analytics;

  const AnalyticsHelper(this.analytics);

  void logScreenView(
      {required String screenClass, required String screenName}) {
    analytics.logScreenView(screenClass: screenClass, screenName: screenName);
  }

  void logEvent({required String name, Map<String, dynamic>? parameters}) {
    analytics.logEvent(name: name, parameters: parameters);
  }

  void logSelectContent({required String contentType, required String itemId}) {
    analytics.logSelectContent(contentType: contentType, itemId: itemId);
  }
}
