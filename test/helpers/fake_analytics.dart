import 'package:btd6wiki/analytics/analytics.dart';

class FakeAnalyticsHelper implements AnalyticsHelper {
  @override
  void logScreenView({required String screenClass, required String screenName}) {}

  @override
  void logEvent({required String name, Map<String, Object>? parameters}) {}

  @override
  void logSelectContent({required String contentType, required String itemId}) {}
}
