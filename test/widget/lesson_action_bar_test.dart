import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/lesson_action_bar.dart';

void main() {
  group('LessonActionBar Widget Tests', () {
    testWidgets('Renders label, icon, and responds to taps', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LessonActionBar(
              label: 'Next Step',
              icon: Icons.arrow_forward,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Next Step'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      await tester.tap(find.text('Next Step'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('Disables interaction when enabled is false', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LessonActionBar(
              label: 'Saving Progress...',
              icon: Icons.celebration,
              enabled: false,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Saving Progress...'), findsOneWidget);
      await tester.tap(find.text('Saving Progress...'));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('Wraps content in a SafeArea with bottom=true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: LessonActionBar(
              label: 'Next Step',
              icon: Icons.arrow_forward,
            ),
          ),
        ),
      );

      final safeAreaFinder = find.byType(SafeArea);
      expect(safeAreaFinder, findsOneWidget);

      final safeArea = tester.widget<SafeArea>(safeAreaFinder);
      expect(safeArea.bottom, isTrue);
    });
  });
}
