// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:btd6wiki/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // verify that the title is correct and the theme is dark
//     expect(find.text('BTD6 wiki'), findsOneWidget);
//     expect(find.byIcon(Icons.brightness_4), findsOneWidget);

//     // verify that can switch to light theme
//     await tester.tap(find.byIcon(Icons.brightness_4));
//     await tester.pumpAndSettle();
//     expect(find.byIcon(Icons.brightness_7), findsOneWidget);

//     // verify that can switch to dark theme
//     await tester.tap(find.byIcon(Icons.brightness_7));
//     await tester.pumpAndSettle();
//     expect(find.byIcon(Icons.brightness_4), findsOneWidget);

//     // verify that the page is correct
//     expect(find.text('Towers'), findsOneWidget);
//   });
// }
