import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_button.dart';

void main() {
  group('MonsterButton Widget Tests', () {
    testWidgets('Renders label and triggers callback on tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonsterButton(
              label: 'Launch Robot',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Launch Robot'), findsOneWidget);

      await tester.tap(find.text('Launch Robot'));
      expect(tapped, isTrue);
    });

    testWidgets('Meets minimum 52dp height for kid ergonomics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonsterButton(
              label: 'Test Touch Target',
              onPressed: () {},
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(MonsterButton);
      final size = tester.getSize(buttonFinder);
      expect(size.height, greaterThanOrEqualTo(52.0));
    });
  });
}
