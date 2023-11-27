import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> logPageView(String pageName) async {
  await FirebaseAnalytics.instance.logScreenView(screenName: pageName);
}

Future<void> logEvent(String eventName, String eventValue) async {
  await FirebaseAnalytics.instance.logEvent(
    name: eventName,
    parameters: <String, dynamic>{
      'eventValue': eventValue,
      'timestamp': DateTime.now().toString(),
      'value': eventValue
    },
  );
}
