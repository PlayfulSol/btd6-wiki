import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> logPageView(String pageName) async {
  await FirebaseAnalytics.instance.logScreenView(screenName: pageName);
}

Future<void> logInnerPageView(String pageName) async {
  await FirebaseAnalytics.instance.logScreenView(screenName: pageName);
}
