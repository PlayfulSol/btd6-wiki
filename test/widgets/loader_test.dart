import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:btd6wiki/presentation/widgets/common/loader.dart';

void main() {
  group('Loader', () {
    testWidgets('renders a CircularProgressIndicator centered on screen',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Loader())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
    });
  });
}
