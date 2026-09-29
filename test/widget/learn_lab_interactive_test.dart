import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/widgets/blink_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/potentiometer_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/rgb_mixer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/board_inspector_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/quiz_checkpoint_widget.dart';

void main() {
  group('Phase 07: Learn Lab Interactive Simulators', () {
    testWidgets(
        'BlinkSimulatorWidget renders and responds to speed slider adjustments',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BlinkSimulatorWidget(initialDelayMs: 1000),
          ),
        ),
      );

      expect(find.text('Virtual Blink Simulator'), findsOneWidget);
      expect(find.text('delay(1000);'), findsWidgets);

      // Adjust slider
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      await tester.tap(find.byIcon(Icons.pause_circle_filled));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
    });

    testWidgets(
        'PotentiometerSimulatorWidget converts rotational ADC value to voltage',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PotentiometerSimulatorWidget(initialValue: 512),
          ),
        ),
      );

      expect(find.text('10-Bit ADC Potentiometer Dial'), findsOneWidget);
      expect(find.text('512'), findsOneWidget);
      expect(find.text('2.50 Volts'), findsOneWidget);
      expect(find.textContaining('analogRead(A0) -> 512'), findsOneWidget);
    });

    testWidgets('RgbMixerWidget mixes additive colors and selects presets',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RgbMixerWidget()),
          ),
        ),
      );

      expect(find.text('RGB LED PWM Color Studio'), findsOneWidget);

      // Tap "Cyan" preset chip
      final cyanChip = find.widgetWithText(ActionChip, 'Cyan');
      expect(cyanChip, findsOneWidget);
      await tester.tap(cyanChip);
      await tester.pumpAndSettle();

      expect(find.text('RGB(0, 255, 255)'), findsOneWidget);
      expect(find.textContaining('analogWrite(RED_PIN,   0);'), findsOneWidget);
      expect(
          find.textContaining('analogWrite(GREEN_PIN, 255);'), findsOneWidget);
      expect(
          find.textContaining('analogWrite(BLUE_PIN,  255);'), findsOneWidget);
    });

    testWidgets(
        'BoardInspectorWidget displays explanations and real-world analogies',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: BoardInspectorWidget()),
          ),
        ),
      );

      expect(find.text('Interactive Board Inspector'), findsOneWidget);
      expect(find.text('USB Type-B Port'), findsWidgets);

      // Tap Chip for Pin 13 LED
      final ledChip = find.widgetWithText(ChoiceChip, 'Pin 13 Built-in LED');
      expect(ledChip, findsOneWidget);
      await tester.tap(ledChip);
      await tester.pumpAndSettle();

      expect(find.textContaining('surface-mount amber LED'), findsOneWidget);
      expect(find.textContaining('blinking eye'), findsOneWidget);
    });

    testWidgets('QuizCheckpointWidget evaluates answers and triggers callback',
        (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuizCheckpointWidget(
              question: 'What is Ground (GND)?',
              options: const [
                'An infinite battery',
                'The return path for electric current',
                'A dirt depth sensor',
              ],
              correctIndex: 1,
              onAnswerSubmitted: (val) => result = val,
            ),
          ),
        ),
      );

      expect(find.text('Knowledge Checkpoint'), findsOneWidget);
      expect(find.text('What is Ground (GND)?'), findsOneWidget);

      // Tap correct option (B)
      await tester.tap(find.text('The return path for electric current'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Submit Answer'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
      expect(find.text('Spot on! You nailed this concept.'), findsOneWidget);
    });
  });
}
