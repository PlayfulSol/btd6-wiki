import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsHelper {
  factory AnalyticsHelper(FirebaseAnalytics analytics) = _AnalyticsHelperImpl;

  void logScreenView({required String screenClass, required String screenName});
  void logEvent({required String name, Map<String, Object>? parameters});
  void logSelectContent({required String contentType, required String itemId});
}

class _AnalyticsHelperImpl implements AnalyticsHelper {
  final FirebaseAnalytics analytics;

  const _AnalyticsHelperImpl(this.analytics);

  @override
  void logScreenView(
      {required String screenClass, required String screenName}) async {
    await analytics.logScreenView(
        screenClass: screenClass, screenName: screenName);
  }

  @override
  void logEvent(
      {required String name, Map<String, Object>? parameters}) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  void logSelectContent({required String contentType, required String itemId}) {
    analytics.logSelectContent(contentType: contentType, itemId: itemId);
  }
}
