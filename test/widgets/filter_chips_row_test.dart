import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:btd6wiki/presentation/widgets/common/filter_chips_row.dart';

const _options = ['All', 'Primary', 'Military', 'Magic'];

Widget _buildRow({
  required String selected,
  required ValueChanged<String> onSelect,
}) {
  return MaterialApp(
    home: Scaffold(
      body: FilterChipsRow(
        options: _options,
        selected: selected,
        onSelect: onSelect,
        colorForOption: (_, __) => Colors.blue,
      ),
    ),
  );
}

void main() {
  group('FilterChipsRow', () {
    testWidgets('renders all option labels', (tester) async {
      await tester.pumpWidget(_buildRow(selected: 'All', onSelect: (_) {}));

      for (final option in _options) {
        expect(find.text(option), findsOneWidget);
      }
    });

    testWidgets('correct chip is marked selected', (tester) async {
      await tester.pumpWidget(
          _buildRow(selected: 'Primary', onSelect: (_) {}));

      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      final selected = chips.where((c) => c.selected).toList();
      expect(selected, hasLength(1));
      expect((selected.first.label as Text).data, 'Primary');
    });

    testWidgets('tapping a chip calls onSelect with its value', (tester) async {
      String? tapped;
      await tester.pumpWidget(
          _buildRow(selected: 'All', onSelect: (v) => tapped = v));

      await tester.tap(find.text('Magic'));
      expect(tapped, 'Magic');
    });

    testWidgets('no chip is doubly selected when different option provided',
        (tester) async {
      await tester
          .pumpWidget(_buildRow(selected: 'Military', onSelect: (_) {}));

      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      final selected = chips.where((c) => c.selected).toList();
      expect(selected, hasLength(1));
      expect((selected.first.label as Text).data, 'Military');
    });

    testWidgets('rebuilding with new selected value updates highlighted chip',
        (tester) async {
      String current = 'All';
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return FilterChipsRow(
                  options: _options,
                  selected: current,
                  onSelect: (_) {},
                  colorForOption: (_, __) => Colors.blue,
                );
              },
            ),
          ),
        ),
      );

      // Initially 'All' is selected
      var chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      expect(chips.firstWhere((c) => c.selected).label,
          isA<Text>().having((t) => t.data, 'label', 'All'));

      // Change selected to 'Magic'
      rebuild(() => current = 'Magic');
      await tester.pump();

      chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      expect(chips.firstWhere((c) => c.selected).label,
          isA<Text>().having((t) => t.data, 'label', 'Magic'));
    });
  });
}
