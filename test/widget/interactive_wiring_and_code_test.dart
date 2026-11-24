import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/circuit_wiring_model.dart';
import 'package:monster_lab/domain/models/code_experiment_model.dart';
import 'package:monster_lab/presentation/features/lab/interactive_lab_screen.dart';
import 'package:monster_lab/presentation/features/lab/widgets/guided_code_lab_widget.dart';
import 'package:monster_lab/presentation/features/lab/widgets/interactive_breadboard_widget.dart';

void main() {
  group('Phase 14: Interactive Wiring and Code Lab Widget Tests', () {
    testWidgets(
        'InteractiveLabScreen renders navigation tabs and default breadboard',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: InteractiveLabScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('Interactive Wiring & Code Lab'), findsOneWidget);
      expect(find.text('Breadboard Wiring'), findsOneWidget);
      expect(find.text('Guided Code Lab'), findsOneWidget);

      // Verify breadboard wiring elements
      expect(find.byType(InteractiveBreadboardWidget), findsOneWidget);
      expect(find.byKey(const Key('verify_wiring_button')), findsOneWidget);
      expect(find.text('Placed Wires: 0 • Tap two pins to connect'),
          findsOneWidget);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Breadboard wiring verification detects incomplete circuit',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: InteractiveLabScreen(),
        ),
      );
      await tester.pump();

      // Tap verify button without placing wires
      final verifyBtn = find.byKey(const Key('verify_wiring_button'));
      await tester.ensureVisible(verifyBtn);
      await tester.tap(verifyBtn);
      await tester.pump();

      // Should display incomplete feedback
      expect(find.textContaining('Circuit Incomplete'), findsOneWidget);
      expect(find.textContaining('uninterrupted closed loop'), findsOneWidget);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Interactive breadboard wire placement, undo, and clear',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final preset = CircuitPresets.blinkLed;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: InteractiveBreadboardWidget(preset: preset),
            ),
          ),
        ),
      );
      await tester.pump();

      final gestureFinder =
          find.byKey(const Key('breadboard_gesture_detector'));
      expect(gestureFinder, findsOneWidget);

      final renderBox = tester.renderObject(gestureFinder) as RenderBox;
      final size = renderBox.size;

      // Pin coordinates from preset
      final p1 = preset.findPin('uno_d13')!;
      final p2 = preset.findPin('res_leg1')!;
      final pin1Offset = Offset(size.width * p1.x, size.height * p1.y);
      final pin2Offset = Offset(size.width * p2.x, size.height * p2.y);

      // Tap pin 1
      await tester.tapAt(tester.getTopLeft(gestureFinder) + pin1Offset);
      await tester.pump();

      // Tap pin 2
      await tester.tapAt(tester.getTopLeft(gestureFinder) + pin2Offset);
      await tester.pump();

      // Now 1 wire should be placed
      expect(find.text('Placed Wires: 1 • Tap two pins to connect'),
          findsOneWidget);

      // Tap Undo button
      await tester.tap(find.byKey(const Key('undo_wire_button')));
      await tester.pump();
      expect(find.text('Placed Wires: 0 • Tap two pins to connect'),
          findsOneWidget);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Switch to Guided Code Lab tab and view code viewer',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: InteractiveLabScreen(),
        ),
      );
      await tester.pump();

      // Switch to Guided Code Lab tab
      await tester.tap(find.text('Guided Code Lab'));
      await tester.pump();

      expect(find.byType(GuidedCodeLabWidget), findsOneWidget);
      expect(find.text('sketch.ino (Arduino C++)'), findsOneWidget);
      expect(find.text('Live Pin 13 LED State: LOW (OFF)'), findsOneWidget);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Guided Code Lab variable slider updates blink cycle',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuidedCodeLabWidget(preset: CodePresets.blinkExperiment),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify default variable label
      expect(find.byKey(const Key('variable_value_label')), findsOneWidget);
      expect(find.text('1000 ms'), findsOneWidget);

      // Drag the slider
      final sliderFinder = find.byKey(const Key('blink_delay_slider'));
      expect(sliderFinder, findsOneWidget);

      await tester.drag(sliderFinder, const Offset(-100, 0));
      await tester.pump();

      // After dragging to left, value should be lower than 1000 ms
      expect(find.text('1000 ms'), findsNothing);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets(
        'Guided Code Lab Compiler Error Decoder explains cryptic errors',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GuidedCodeLabWidget(preset: CodePresets.blinkExperiment),
            ),
          ),
        ),
      );
      await tester.pump();

      // Find the first error sample chip: "Missing Semicolon ;"
      final semicolonChip =
          find.byKey(const Key('error_sample_chip_err_semicolon'));
      expect(semicolonChip, findsOneWidget);

      // Tap the error chip
      await tester.ensureVisible(semicolonChip);
      await tester.tap(semicolonChip);
      await tester.pump();

      // Should display decoded explanation and the science
      expect(
          find.textContaining("expected ';' before 'delay'"), findsOneWidget);
      expect(
          find.textContaining(
              'In C++, a semicolon (;) is like a period at the end of a sentence'),
          findsOneWidget);
      expect(find.textContaining('The Science:'), findsOneWidget);

      // Clean up
      await tester.pumpWidget(const SizedBox());
    });
  });
}
