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

    testWidgets(
        'QuizCheckpointWidget handles multi-question carousel and deck completion',
        (tester) async {
      final results = <bool>[];

      final questionsList = [
        {
          'question': 'What is a microcontroller?',
          'options': ['A small computer', 'A battery'],
          'correctIndex': 0,
          'explanation': 'Microcontrollers run embedded code.',
        },
        {
          'question': 'Is an LED an input or output?',
          'options': ['Input', 'Output'],
          'correctIndex': 1,
          'explanation': 'LEDs produce light so they are outputs.',
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuizCheckpointWidget(
              question: 'Fallback Q',
              options: const ['A', 'B'],
              correctIndex: 0,
              questions: questionsList,
              onAnswerSubmitted: (val) => results.add(val),
            ),
          ),
        ),
      );

      // Verify Question 1 of 2
      expect(find.text('Question 1 of 2'), findsOneWidget);
      expect(find.text('What is a microcontroller?'), findsOneWidget);

      // Answer Question 1 correctly
      await tester.tap(find.text('A small computer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit Answer'));
      await tester.pumpAndSettle();

      expect(results.last, isTrue);
      expect(find.text('Spot on! Microcontrollers run embedded code.'),
          findsOneWidget);
      expect(find.text('Next Question'), findsOneWidget);

      // Advance to Question 2
      await tester.tap(find.text('Next Question'));
      await tester.pumpAndSettle();

      // Verify Question 2 of 2
      expect(find.text('Question 2 of 2'), findsOneWidget);
      expect(find.text('Is an LED an input or output?'), findsOneWidget);

      // Answer Question 2 correctly
      await tester.tap(find.text('Output'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit Answer'));
      await tester.pumpAndSettle();

      expect(results.last, isTrue);
      expect(find.text('Finish Assessment'), findsOneWidget);

      // Finish assessment
      await tester.tap(find.text('Finish Assessment'));
      await tester.pumpAndSettle();

      expect(find.text('Assessment Complete! All 2 Questions Answered.'),
          findsOneWidget);
      expect(results.last, isTrue);
    });

    testWidgets(
        'QuizCheckpointWidget resets state cleanly when questions change via didUpdateWidget',
        (tester) async {
      final questionsDeck1 = [
        {
          'question': 'Deck 1 Q1',
          'options': ['Opt A', 'Opt B'],
          'correctIndex': 0,
        },
      ];

      final questionsDeck2 = [
        {
          'question': 'Deck 2 Q1',
          'options': ['New A', 'New B'],
          'correctIndex': 1,
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuizCheckpointWidget(
              question: 'Deck 1 Q1',
              options: const ['Opt A', 'Opt B'],
              correctIndex: 0,
              questions: questionsDeck1,
              onAnswerSubmitted: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Deck 1 Q1'), findsOneWidget);

      // Submit Deck 1 Q1
      await tester.tap(find.text('Opt A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit Answer'));
      await tester.pumpAndSettle();
      expect(find.text('Finish Assessment'), findsOneWidget);

      // Re-pump with questionsDeck2
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuizCheckpointWidget(
              question: 'Deck 2 Q1',
              options: const ['New A', 'New B'],
              correctIndex: 1,
              questions: questionsDeck2,
              onAnswerSubmitted: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Deck 2 Q1'), findsOneWidget);
      expect(find.text('Submit Answer'), findsOneWidget);
    });
  });
}
