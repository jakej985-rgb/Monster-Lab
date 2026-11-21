import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/app_metadata.dart';
import 'package:monster_lab/presentation/features/parent/about_screen.dart';

void main() {
  group('About & Release Readiness Screen Tests', () {
    testWidgets(
        'AboutScreen renders version, offline safety notice, and scope statistics',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // App Title and Version
      expect(find.text('Monster Lab'), findsWidgets);
      expect(find.text(appVersionDisplay), findsOneWidget);

      // 100% Offline & Child-Safe notice
      expect(find.text('100% Offline & Child-Safe'), findsOneWidget);
      expect(find.textContaining('zero cloud telemetry'), findsOneWidget);

      // Curriculum statistics
      expect(find.text('12 Step-by-Step Lessons'), findsOneWidget);
      expect(find.text('54 Kit Components'), findsOneWidget);
      expect(find.text('20 Guided Projects'), findsOneWidget);
      expect(find.text('24 Circuit Challenges'), findsOneWidget);
      expect(find.text('20 Mastery Badges'), findsOneWidget);

      // Scroll down to action buttons
      await tester.scrollUntilVisible(
        find.byKey(const Key('open_licenses_button')),
        100,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Action buttons
      expect(find.byKey(const Key('open_licenses_button')), findsOneWidget);
      expect(find.byKey(const Key('privacy_policy_dialog_button')),
          findsOneWidget);
    });

    testWidgets(
        'Tapping View Detailed Privacy Policy opens dialog with COPPA details',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to Privacy Dialog button
      await tester.scrollUntilVisible(
        find.byKey(const Key('privacy_policy_dialog_button')),
        100,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Tap Privacy Dialog button
      await tester.tap(find.byKey(const Key('privacy_policy_dialog_button')));
      await tester.pumpAndSettle();

      // Dialog content
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.textContaining('100% Offline Storage'), findsOneWidget);
      expect(find.textContaining('COPPA & FERPA'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Privacy Policy'), findsNothing);
    });
  });
}
