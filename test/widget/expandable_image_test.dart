import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/expandable_lesson_image.dart';
import 'package:monster_lab/presentation/shared/widgets/full_screen_image_viewer.dart';

void main() {
  group('ExpandableLessonImage Widget Tests', () {
    testWidgets('Renders inline image and semantics label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpandableLessonImage(
              assetPath: 'assets/images/components/uno.png',
              semanticsLabel: 'Arduino Uno R3 development board',
              caption: 'Figure 1.1: Uno Board Layout',
            ),
          ),
        ),
      );

      expect(find.text('Figure 1.1: Uno Board Layout'), findsOneWidget);
      expect(find.text('Tap to expand'), findsOneWidget);
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('Tapping image opens FullScreenImageViewer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpandableLessonImage(
              assetPath: 'assets/images/components/uno.png',
              semanticsLabel: 'Arduino Uno R3',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap to expand'));
      await tester.pumpAndSettle();

      expect(find.byType(FullScreenImageViewer), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tapping close button dismisses viewer
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(FullScreenImageViewer), findsNothing);
    });
  });
}
