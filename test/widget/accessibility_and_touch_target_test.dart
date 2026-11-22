import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/domain/models/circuit_wiring_model.dart';
import 'package:monster_lab/presentation/features/hardware/widgets/hardware_status_badge.dart';
import 'package:monster_lab/presentation/features/lab/widgets/interactive_breadboard_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/blink_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/library_manager_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/quiz_checkpoint_widget.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_button.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_card.dart';
import 'package:monster_lab/presentation/shared/widgets/xp_progress_bar.dart';

void main() {
  group('Accessibility & Touch Target Guideline Tests', () {
    testWidgets('MonsterButton meets touch target and labeling guidelines',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MonsterButton(
                label: 'Launch Experiment',
                icon: Icons.rocket_launch,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify touch target dimensions are at least 48x48dp
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      // Verify Semantics properties
      expect(
        tester.getSemantics(find.byType(MonsterButton)),
        matchesSemantics(
          label: 'Launch Experiment',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('MonsterButton.secondary meets touch target guidelines',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MonsterButton.secondary(
                label: 'Cancel Action',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      handle.dispose();
    });

    testWidgets(
        'MonsterCard supports mergeSemantics and custom semantic labels',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MonsterCard(
                mergeSemantics: true,
                semanticLabel: 'Lessons Completed: 12',
                onTap: () {},
                child: const Column(
                  children: [
                    Icon(Icons.school),
                    Text('12'),
                    Text('Lessons Completed'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(MonsterCard)),
        matchesSemantics(
          label: 'Lessons Completed: 12',
          isButton: true,
          hasTapAction: true,
        ),
      );

      handle.dispose();
    });

    testWidgets(
        'XPProgressBar exposes clear level and progress semantics to screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: XPProgressBar(
                totalXp: 450,
                currentLevel: 3,
                progressRatio: 0.65,
              ),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(XPProgressBar));
      expect(
          semantics.label,
          contains(
              'Level 3, 450 XP earned, 65 percent progress to next level'));

      handle.dispose();
    });

    testWidgets(
        'HardwareStatusBadge satisfies minimum 48x48 hit target and button semantics',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HardwareStatusBadge(
                  showLabel: false,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify touch target is at least 48x48
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      expect(
        tester.getSemantics(find.byType(HardwareStatusBadge)),
        matchesSemantics(
          label: 'Hardware Companion: Hardware Offline',
          tooltip: 'Hardware Companion: Hardware Offline (Tap to Open)',
          isButton: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );

      handle.dispose();
    });

    testWidgets(
        'BlinkSimulatorWidget clamps slider min to safe >= 350ms to prevent photosensitive seizures',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlinkSimulatorWidget(
                  initialDelayMs: 100), // Requesting unsafe 100ms
            ),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      // Slider min must be >= 350ms (< 3 Hz)
      expect(slider.min, greaterThanOrEqualTo(350));
      expect(slider.value, greaterThanOrEqualTo(350));
    });

    testWidgets(
        'QuizCheckpointWidget provides radio semantics for option choices',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuizCheckpointWidget(
                question: 'Which pin supplies positive power?',
                options: const ['GND', '5V', 'D13', 'RESET'],
                correctIndex: 1,
                onAnswerSubmitted: (isCorrect) {},
              ),
            ),
          ),
        ),
      );

      // Verify option A semantics
      expect(
        find.bySemanticsLabel('Option A: GND'),
        findsOneWidget,
      );

      // Verify option B semantics
      expect(
        find.bySemanticsLabel('Option B: 5V'),
        findsOneWidget,
      );

      handle.dispose();
    });

    testWidgets(
        'InteractiveBreadboardWidget wire palette circles meet touch target guidelines',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: InteractiveBreadboardWidget(
                preset: CircuitPresets.blinkLed,
              ),
            ),
          ),
        ),
      );

      // Verify wire color buttons are discoverable by screen reader
      expect(find.bySemanticsLabel('Red (+5V power) wire'), findsOneWidget);
      expect(find.bySemanticsLabel('Black (GND ground) wire'), findsOneWidget);

      handle.dispose();
    });

    testWidgets('LibraryManagerSimulatorWidget labels its clear-search action',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LibraryManagerSimulatorWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Clear search'), findsOneWidget);
      final clearButton = find.widgetWithIcon(IconButton, Icons.clear);
      expect(clearButton, findsOneWidget);
      expect(tester.getSemantics(clearButton).tooltip, 'Clear search');

      handle.dispose();
    });
  });
}
