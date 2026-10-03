import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_markdown.dart';
import 'package:monster_lab/presentation/features/learn/widgets/visual_flow_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/input_output_classification_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/interactive_board_inspector_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/board_label_drag_drop_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/ground_troubleshooting_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/decision_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/code_deconstruction_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/engineering_prediction_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/real_world_system_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/interactive_troubleshooting_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/mini_quiz_widget.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';

void main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  void setupScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('MonsterMarkdown Widget Tests', () {
    testWidgets('renders markdown headings, lists, and code blocks cleanly',
        (tester) async {
      setupScreen(tester);
      const markdown = '''
# Heading 1
## Heading 2
- Bullet 1
- Bullet 2

Here is inline `pinMode(13, OUTPUT)` code.

```cpp
void setup() {
  digitalWrite(13, HIGH);
}
```
''';

      await tester.pumpWidget(wrapWithMaterial(
        const MonsterMarkdown(data: markdown),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Heading 1'), findsOneWidget);
      expect(find.text('Heading 2'), findsOneWidget);
      expect(find.text('Bullet 1'), findsOneWidget);
      expect(find.byType(MonsterMarkdown), findsOneWidget);
    });
  });

  group('VisualFlowDiagramWidget Tests', () {
    testWidgets('renders flow nodes and triggers signal pulse', (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        VisualFlowDiagramWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SENSE'), findsWidgets);
      expect(find.textContaining('TRANSMIT'), findsWidgets);
      expect(find.textContaining('DECIDE'), findsWidgets);
      expect(find.textContaining('ACT'), findsWidgets);

      // Tap on a node
      await tester.tap(find.textContaining('DECIDE'));
      await tester.pumpAndSettle();
      expect(find.textContaining('C++ sketch evaluates'), findsOneWidget);

      // Tap Test Signal Pulse
      await tester.tap(find.text('Test Signal Pulse ➔'));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('FLOW TESTED'), findsOneWidget);
    });
  });

  group('InputOutputClassificationWidget Tests', () {
    testWidgets('classifies pushbutton as input and shows feedback',
        (tester) async {
      setupScreen(tester);
      await tester.pumpWidget(wrapWithMaterial(
        const InputOutputClassificationWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Pushbutton'), findsOneWidget);
      expect(find.textContaining('INPUT'), findsWidgets);
      expect(find.textContaining('OUTPUT'), findsWidgets);

      // Tap INPUT button
      await tester.tap(find.textContaining('INPUT\n(Sense Info)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('CORRECT! INPUT'), findsOneWidget);
      expect(find.textContaining('Next Component'), findsOneWidget);
    });
  });

  group('InteractiveBoardInspectorWidget Tests', () {
    testWidgets('toggles digital switch and answers prediction',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        InteractiveBoardInspectorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('1. Digital Signal (Pin 13)'), findsOneWidget);
      expect(find.text('2. Analog Signal (Pin A0)'), findsOneWidget);

      // Toggle digital switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.text('HIGH (5.0V)'), findsOneWidget);

      // Select prediction: "Change gradually"
      await tester.tap(find.textContaining('Change gradually and smoothly'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('EXPLORED'), findsOneWidget);
    });
  });

  group('BoardLabelDragDropWidget Tests', () {
    testWidgets('matches landmark badge to target slot', (tester) async {
      setupScreen(tester);
      await tester.pumpWidget(wrapWithMaterial(
        const BoardLabelDragDropWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('USB Connection'), findsWidgets);
      expect(
          find.textContaining('Landmarks Identified: 0 / 8'), findsOneWidget);

      // Select USB Connection badge in the tray
      await tester.tap(find.text('USB Connection').first);
      await tester.pumpAndSettle();

      // Tap the USB slot via 'Tap to Match'
      await tester.tap(find.text('Tap to Match').first);
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Landmarks Identified: 1 / 8'), findsOneWidget);
      expect(find.text('✓ USB Connection'), findsOneWidget);
    });
  });

  group('GroundTroubleshootingWidget Tests', () {
    testWidgets('switches scenarios and reveals short circuit alert',
        (tester) async {
      setupScreen(tester);
      await tester.pumpWidget(wrapWithMaterial(
        const GroundTroubleshootingWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('1. Complete Circuit'), findsOneWidget);
      expect(find.text('STATUS: NORMAL & HEALTHY'), findsOneWidget);

      // Tap Short Circuit scenario
      await tester.tap(find.text('4. Short Circuit (Direct Bridge)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('SAFETY ALERT'), findsWidgets);
      expect(find.textContaining('850 mA'), findsOneWidget);
    });
  });

  group('DecisionSimulatorWidget Tests', () {
    testWidgets('toggles lock to simulate condition-decision-action',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        DecisionSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('HOLD TO PRESS BUTTON'), findsOneWidget);
      expect(find.textContaining('LED: OFF'), findsOneWidget);

      // Tap Toggle Lock
      await tester.tap(find.textContaining('Toggle Lock'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('BUTTON PRESSED (HIGH)'), findsOneWidget);
      expect(find.textContaining('LED: SHINING BRIGHT'), findsOneWidget);
    });
  });

  group('CodeDeconstructionWidget Tests', () {
    testWidgets('inspects tokens and executes simulation', (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        CodeDeconstructionWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('digitalWrite'), findsWidgets);
      expect(find.text('HIGH'), findsWidgets);

      // Select prediction: Command LED ON
      await tester.tap(find.textContaining('Command the LED ON'));
      await tester.pumpAndSettle();

      // Tap Simulate Instruction
      await tester.tap(find.textContaining('Simulate Instruction'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.textContaining('Prediction Verified!'), findsOneWidget);
    });
  });

  group('EngineeringPredictionWidget Tests', () {
    testWidgets('hypothesizes LOW state and confirms observation',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        EngineeringPredictionWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('digitalWrite(13, LOW);'), findsOneWidget);

      // Select OFF prediction
      await tester.tap(find.textContaining('Turn completely OFF'));
      await tester.pumpAndSettle();

      // Tap Upload & Observe
      await tester.tap(find.textContaining('Upload & Observe LED'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.textContaining('Hypothesis Confirmed!'), findsOneWidget);
    });
  });

  group('RealWorldSystemDiagramWidget Tests', () {
    testWidgets('triggers automated system response', (tester) async {
      setupScreen(tester);
      await tester.pumpWidget(wrapWithMaterial(
        const RealWorldSystemDiagramWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Robot Vacuum'), findsOneWidget);

      // Trigger Wall Obstacle
      await tester.tap(find.textContaining('Simulate Wall 15cm Ahead'));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Obstacle detected 15cm ahead!'), findsOneWidget);
    });
  });

  group('InteractiveTroubleshootingWidget Tests', () {
    testWidgets('diagnoses pin mismatch and moves wire to fix LED',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        InteractiveTroubleshootingWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('WIRE IN PIN 12 (MISMATCH!)'), findsOneWidget);

      // Select correct diagnosis
      await tester
          .tap(find.textContaining('Pin Mismatch: Code commands Pin 13'));
      await tester.pumpAndSettle();

      // Tap Move Wire
      await tester.tap(find.textContaining('Move Wire from Pin 12'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('BUG FIXED'), findsOneWidget);
      expect(find.textContaining('LED IS LIT!'), findsOneWidget);
    });
  });

  group('MiniQuizWidget Tests', () {
    testWidgets('submits answer and shows explanation', (tester) async {
      setupScreen(tester);
      await tester.pumpWidget(wrapWithMaterial(
        const MiniQuizWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('In robotics, what is the role of an Input'),
          findsOneWidget);

      // Tap option 1: Senses the environment
      await tester.tap(find.textContaining('Senses the environment'));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Inputs (sensors and buttons) feed real-world'),
          findsOneWidget);
      expect(find.textContaining('Next Question'), findsOneWidget);
    });
  });

  group('ActivityRegistry Tests', () {
    testWidgets('resolves registered interactive activity builders',
        (tester) async {
      expect(ActivityRegistry.hasActivity('visualFlowDiagram'), isTrue);
      expect(ActivityRegistry.hasActivity('boardLabelDragDrop'), isTrue);
      expect(
          ActivityRegistry.hasActivity('interactiveTroubleshooting'), isTrue);
      expect(ActivityRegistry.hasActivity('unknownActivity'), isFalse);
    });
  });
}
