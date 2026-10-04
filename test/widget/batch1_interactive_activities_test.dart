import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';
import 'package:monster_lab/presentation/features/learn/widgets/port_selector_bench_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/ide_lifecycle_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/port_troubleshooting_bench_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/esd_safety_check_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/library_concept_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/library_manager_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/include_syntax_deconstruction_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/lcd_contrast_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/missing_library_troubleshooting_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/syntax_error_debugger_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/serial_monitor_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/execution_speed_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/serial_print_experiment_widget.dart';

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

  group('ActivityRegistry Batch 1 Registration Tests', () {
    test(
        'verifies all 13 Batch 1 activities + foundation activities are registered',
        () {
      expect(ActivityRegistry.hasActivity('priorKnowledgeCheck'), isTrue);
      expect(
          ActivityRegistry.hasActivity('compilationPipelineSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('portSelectorBench'), isTrue);
      expect(ActivityRegistry.hasActivity('ideLifecycleSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('portTroubleshootingBench'), isTrue);
      expect(ActivityRegistry.hasActivity('esdSafetyCheck'), isTrue);
      expect(ActivityRegistry.hasActivity('libraryConceptDiagram'), isTrue);
      expect(ActivityRegistry.hasActivity('libraryManagerSimulator'), isTrue);
      expect(
          ActivityRegistry.hasActivity('includeSyntaxDeconstruction'), isTrue);
      expect(ActivityRegistry.hasActivity('lcdContrastSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('missingLibraryTroubleshooting'),
          isTrue);
      expect(ActivityRegistry.hasActivity('syntaxErrorDebugger'), isTrue);
      expect(ActivityRegistry.hasActivity('serialMonitorSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('executionSpeedVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('serialPrintExperiment'), isTrue);
    });
  });

  group('Lesson 02 Interactive Activity Widgets', () {
    testWidgets(
        'PortSelectorBenchWidget verifies board connection and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        PortSelectorBenchWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Port Selector Bench'), findsOneWidget);
      expect(find.text('Arduino Uno'), findsOneWidget);
      expect(find.text('COM3 (Arduino Uno)'), findsOneWidget);

      // Tap Connect & Test
      await tester.tap(find.byKey(const Key('port_selector_test_button')));
      await tester.pump();
      // Pump through the simulated handshake timer steps
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('VERIFIED'), findsOneWidget);
      expect(
          find.textContaining('Hardware handshaking verified'), findsOneWidget);
    });

    testWidgets(
        'IdeLifecycleSimulatorWidget steps through lifecycle and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        IdeLifecycleSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('setup() vs loop() Orbit'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);

      // Select 2.0x speed
      await tester.tap(find.byKey(const Key('speed_chip_2.0x')));
      await tester.pumpAndSettle();

      // Step 1: Run setup()
      await tester.tap(find.byKey(const Key('lifecycle_step_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('RUNNING NOW'), findsOneWidget);
      expect(find.text('Step: 1'), findsOneWidget);
      expect(find.text('Total Steps: 1'), findsOneWidget);

      // Step 2: setup() completes, enters loop step 1
      await tester.tap(find.byKey(const Key('lifecycle_step_button')));
      await tester.pumpAndSettle();
      expect(find.text('1x EXECUTED'), findsOneWidget);
      expect(find.text('Step: 2'), findsOneWidget);

      // Advance through cycle 1 steps
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byKey(const Key('lifecycle_step_button')));
        await tester.pumpAndSettle();
      }

      // Cycle 2 step 1
      await tester.tap(find.byKey(const Key('lifecycle_step_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('ORBIT MASTERED'), findsOneWidget);
      expect(find.text('Total Steps: 7'), findsOneWidget);
    });

    testWidgets('PortTroubleshootingBenchWidget fixes all 4 diagnostic checks',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        PortTroubleshootingBenchWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Port Not Found! 4-Step Diagnostic Triage'),
          findsOneWidget);
      expect(find.text('0/4 RESOLVED'), findsOneWidget);

      // Fix Check 1
      await tester.tap(find.byKey(const Key('toggle_fix_usb_cable')));
      await tester.pumpAndSettle();

      // Switch to Check 2 and fix
      await tester.tap(find.text('Check 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle_fix_wrong_port')));
      await tester.pumpAndSettle();

      // Switch to Check 3 and fix
      await tester.tap(find.text('Check 3'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle_fix_missing_driver')));
      await tester.pumpAndSettle();

      // Switch to Check 4 and fix
      await tester.tap(find.text('Check 4'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle_fix_disconnected_board')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('PORT OPERATIONAL'), findsOneWidget);
    });

    testWidgets(
        'EsdSafetyCheckWidget completes 3 grounding rules and drops static volts to 0',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        EsdSafetyCheckWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('ESD Grounding'), findsOneWidget);
      expect(find.text('4500 Volts'), findsOneWidget);

      // Step 1: Touch metal
      await tester.tap(find.byKey(const Key('esd_step_metal')));
      await tester.pumpAndSettle();
      expect(find.text('2500 Volts'), findsOneWidget);

      // Step 2: Surface check
      await tester.tap(find.byKey(const Key('esd_step_surface')));
      await tester.pumpAndSettle();
      expect(find.text('1000 Volts'), findsOneWidget);

      // Step 3: Edge grip
      await tester.tap(find.byKey(const Key('esd_step_edges')));
      await tester.pumpAndSettle();

      expect(find.text('0 Volts'), findsOneWidget);
      expect(find.text('ESD SAFE'), findsOneWidget);
      expect(completed, isTrue);
    });
  });

  group('Lesson 03 Interactive Activity Widgets', () {
    testWidgets(
        'LibraryConceptDiagramWidget toggles between both tabs and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        LibraryConceptDiagramWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Raw Registers vs Clean Abstraction'),
          findsOneWidget);
      expect(
          find.textContaining('500+ lines of low-level hardware register code'),
          findsOneWidget);

      // Switch to With Library tab
      await tester.tap(find.byKey(const Key('library_tab_with')));
      await tester.pumpAndSettle();

      expect(find.textContaining('LiquidCrystal_I2C lcd(0x27, 16, 2);'),
          findsOneWidget);
      expect(completed, isTrue);
      expect(find.text('CONCEPT MASTERED'), findsOneWidget);
    });

    testWidgets(
        'LibraryManagerSimulatorWidget installs LiquidCrystal_I2C with progress',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        LibraryManagerSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('LiquidCrystal I2C'), findsOneWidget);
      expect(find.text('INSTALL'), findsOneWidget);

      // Tap Install
      await tester.tap(find.byKey(const Key('library_install_button')));
      await tester.pump();
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('INSTALLED'), findsOneWidget);
      expect(find.textContaining('READY TO #INCLUDE'), findsOneWidget);
    });

    testWidgets(
        'IncludeSyntaxDeconstructionWidget inspects all 4 syntax tokens',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        IncludeSyntaxDeconstructionWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('#include <LiquidCrystal_I2C.h>'),
          findsOneWidget);
      expect(find.text('1/4 EXPLORED'), findsOneWidget);

      // Tap token 1: include
      await tester.tap(find.byKey(const Key('syntax_chip_include')));
      await tester.pumpAndSettle();

      // Tap token 2: < >
      await tester.tap(find.byKey(const Key('syntax_chip_< >')));
      await tester.pumpAndSettle();

      // Tap token 3: .h
      await tester.tap(find.byKey(const Key('syntax_chip_.h')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('DECONSTRUCTED'), findsOneWidget);
    });

    testWidgets(
        'LcdContrastSimulatorWidget adjusts trimmer pot to optimal contrast',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        LcdContrastSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('1602A I2C DISPLAY'), findsOneWidget);
      expect(find.text('TOO LOW'), findsOneWidget);

      // Adjust slider into optimal 0.50 sweet spot
      final slider = find.byKey(const Key('lcd_contrast_slider'));
      expect(slider, findsOneWidget);

      // Drag slider to the center
      await tester.drag(slider, const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('CONTRAST TUNED'), findsOneWidget);
      expect(find.text('SWEET SPOT'), findsOneWidget);
    });

    testWidgets(
        'MissingLibraryTroubleshootingWidget installs missing library and recompiles',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        MissingLibraryTroubleshootingWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'fatal error: LiquidCrystal_I2C.h: No such file or directory'),
          findsOneWidget);
      expect(find.text('BUILD FAILED'), findsOneWidget);

      // Click fix button
      await tester.tap(find.byKey(const Key('fix_missing_library_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('ERROR RESOLVED'), findsOneWidget);
      expect(find.textContaining('Compilation finished successfully'),
          findsOneWidget);
    });
  });

  group('Lesson 04 Interactive Activity Widgets', () {
    testWidgets('SyntaxErrorDebuggerWidget fixes all 3 code syntax bugs',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SyntaxErrorDebuggerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('0/3 BUGS FIXED'), findsOneWidget);

      // Bug 1: Missing semicolon
      await tester.tap(find.byKey(const Key('bug_line_semicolon')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apply_fix_semicolon')));
      await tester.pumpAndSettle();
      expect(find.text('1/3 BUGS FIXED'), findsOneWidget);

      // Bug 2: Lowercase digitalwrite
      await tester.tap(find.byKey(const Key('bug_line_casing')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apply_fix_casing')));
      await tester.pumpAndSettle();
      expect(find.text('2/3 BUGS FIXED'), findsOneWidget);

      // Bug 3: Missing brace
      await tester.tap(find.byKey(const Key('bug_line_brace')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('apply_fix_brace')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('CLEAN BUILD'), findsOneWidget);
    });

    testWidgets(
        'SerialMonitorSimulatorWidget synchronizes baud rates and reveals clean telemetry',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SerialMonitorSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('MISMATCH'), findsOneWidget);
      expect(find.textContaining('BAUD MISMATCH WARNING'), findsOneWidget);

      // Select 9600 baud
      await tester.tap(find.byKey(const Key('baud_chip_9600')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('SYNC MATCH'), findsOneWidget);
      expect(find.text('BAUD SYNCED'), findsOneWidget);
      expect(find.textContaining('ALL SYSTEMS NOMINAL'), findsOneWidget);
    });

    testWidgets(
        'ExecutionSpeedVisualizerWidget switches modes and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ExecutionSpeedVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('16,000,000 Hz'), findsOneWidget);

      // Switch to with delay(1000) mode
      await tester.tap(find.byKey(const Key('speed_mode_withdelay')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('SPEED MASTERED'), findsOneWidget);
      expect(find.textContaining('1 Hz (Regulated)'), findsOneWidget);
    });

    testWidgets(
        'SerialPrintExperimentWidget toggles print vs println and sends burst',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SerialPrintExperimentWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('MONSTERLABMONSTERLAB'), findsOneWidget);

      // Switch to println mode
      await tester.tap(find.byKey(const Key('println_mode_chip')));
      await tester.pumpAndSettle();

      // Tap Send Data Ping
      await tester.tap(find.byKey(const Key('send_burst_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('FORMAT MASTERED'), findsOneWidget);
      expect(find.text('ONLINE'), findsOneWidget);
    });
  });

  group('Responsive Small-Screen & Large Text Scale Tests', () {
    testWidgets(
        'widgets render on narrow 320px screen with 1.5x text scale without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // 1. LcdContrastSimulatorWidget
      await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(320, 600),
            textScaler: TextScaler.linear(1.5),
          ),
          child: Scaffold(
            body: SingleChildScrollView(child: LcdContrastSimulatorWidget()),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 2. ExecutionSpeedVisualizerWidget
      await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(320, 600),
            textScaler: TextScaler.linear(1.5),
          ),
          child: Scaffold(
            body:
                SingleChildScrollView(child: ExecutionSpeedVisualizerWidget()),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 3. SerialMonitorSimulatorWidget
      await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(320, 600),
            textScaler: TextScaler.linear(1.5),
          ),
          child: Scaffold(
            body: SingleChildScrollView(child: SerialMonitorSimulatorWidget()),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
