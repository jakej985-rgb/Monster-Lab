import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';
import 'package:monster_lab/presentation/features/learn/widgets/floating_pin_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/internal_pullup_circuit_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/switch_bounce_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/active_low_logic_checker_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/i2c_bus_timing_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/i2c_daisy_chain_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/i2c_address_scanner_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/i2c_pullup_checker_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/spi_full_duplex_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/chip_select_arbitrator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/spi_vs_i2c_comparison_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/spi_clock_polarity_phase_lab_widget.dart';

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

  group('ActivityRegistry Batch 3 Registration Tests', () {
    test('verifies all 12 Batch 3 activities are registered', () {
      expect(ActivityRegistry.hasActivity('floatingPinSimulator'), isTrue);
      expect(
          ActivityRegistry.hasActivity('internalPullupCircuitDiagram'), isTrue);
      expect(ActivityRegistry.hasActivity('switchBounceVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('activeLowLogicChecker'), isTrue);
      expect(ActivityRegistry.hasActivity('i2cBusTimingDiagram'), isTrue);
      expect(ActivityRegistry.hasActivity('i2cDaisyChainSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('i2cAddressScanner'), isTrue);
      expect(ActivityRegistry.hasActivity('i2cPullupChecker'), isTrue);
      expect(ActivityRegistry.hasActivity('spiFullDuplexVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('chipSelectArbitrator'), isTrue);
      expect(ActivityRegistry.hasActivity('spiVsI2cComparison'), isTrue);
      expect(ActivityRegistry.hasActivity('spiClockPolarityPhaseLab'), isTrue);
    });
  });

  group('Lesson 08 Interactive Activity Widgets', () {
    testWidgets(
        'FloatingPinSimulatorWidget switches modes and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        FloatingPinSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Floating Pin Simulator'), findsOneWidget);

      // Tap noise button
      await tester.tap(find.byKey(const Key('induce_noise_button')));
      await tester.pump(const Duration(milliseconds: 150));

      // Switch to Pull-Up
      await tester.tap(find.byKey(const Key('pin_mode_pullup')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('PIN STABILIZED'), findsOneWidget);

      // Switch to Pull-Down
      await tester.tap(find.byKey(const Key('pin_mode_pulldown')));
      await tester.pumpAndSettle();
      expect(find.textContaining('PULLED LOW'), findsOneWidget);
    });

    testWidgets(
        'InternalPullupCircuitDiagramWidget toggles modes and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        InternalPullupCircuitDiagramWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Internal Pull-Up Circuit'), findsOneWidget);

      // Toggle button in default pull-up mode
      await tester.tap(find.byKey(const Key('toggle_pushbutton')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('ACTIVE-LOW VERIFIED'), findsOneWidget);

      // Toggle pullup off
      await tester.tap(find.byKey(const Key('toggle_pullup_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('pinMode: INPUT'), findsOneWidget);
    });

    testWidgets(
        'SwitchBounceVisualizerWidget tests chatter and debounce filter',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SwitchBounceVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Switch Bounce Visualizer'), findsOneWidget);

      // Press button in raw mode
      await tester.tap(find.byKey(const Key('switch_bounce_press_button')));
      await tester.pump(const Duration(milliseconds: 500));

      // Turn debounce on
      await tester.tap(find.byKey(const Key('toggle_debounce_mode')));
      await tester.pumpAndSettle();

      // Adjust slider
      await tester.drag(
          find.byKey(const Key('debounce_slider')), const Offset(50, 0));
      await tester.pumpAndSettle();

      // Press button again in debounced mode
      await tester.tap(find.byKey(const Key('switch_bounce_press_button')));
      await tester.pump(const Duration(milliseconds: 500));

      expect(completed, isTrue);
      expect(find.text('DEBOUNCE MASTERED'), findsOneWidget);
    });

    testWidgets(
        'ActiveLowLogicCheckerWidget verifies active-low trigger and calls onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ActiveLowLogicCheckerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Active-Low Logic Checker'), findsOneWidget);

      // Press button
      await tester.tap(find.byKey(const Key('active_low_press_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('LOGIC VERIFIED'), findsOneWidget);
      expect(find.text('LIT (HIGH)'), findsOneWidget);

      // Toggle logic mode
      await tester.tap(find.byKey(const Key('toggle_logic_mode')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Mode: Active-High'), findsOneWidget);
    });
  });

  group('Lesson 09 Interactive Activity Widgets', () {
    testWidgets(
        'I2cBusTimingDiagramWidget steps through packet frame and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        I2cBusTimingDiagramWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('I2C Bus Timing Diagram'), findsOneWidget);

      // Step through all 11 steps
      for (int i = 0; i < 11; i++) {
        await tester.tap(find.byKey(const Key('i2c_step_button')));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('TIMING MASTERED'), findsOneWidget);

      // Reset
      await tester.tap(find.byKey(const Key('i2c_reset_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Step 1 / 12'), findsOneWidget);
    });

    testWidgets(
        'I2cDaisyChainSimulatorWidget detects and resolves bus collisions',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        I2cDaisyChainSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('I2C Daisy-Chain Bus Builder'), findsOneWidget);

      // Attach second RTC (duplicate 0x68) -> triggers collision
      await tester.tap(find.byKey(const Key('toggle_device_second_rtc')));
      await tester.pumpAndSettle();
      expect(find.textContaining('CRITICAL BUS CONFLICT'), findsOneWidget);

      // Disconnect duplicate RTC -> resolves collision
      await tester.tap(find.byKey(const Key('toggle_device_second_rtc')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('BUS INTEGRITY VERIFIED'), findsOneWidget);

      // Toggle OLED
      await tester.tap(find.byKey(const Key('toggle_device_oled')));
      await tester.pumpAndSettle();
      expect(find.textContaining('OLED (0x3C)'), findsOneWidget);
    });

    testWidgets(
        'I2cAddressScannerWidget scans bus addresses and discovers devices',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        I2cAddressScannerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('I2C Address Scanner'), findsOneWidget);

      // Run scan
      await tester.tap(find.byKey(const Key('run_i2c_scan_button')));
      await tester.pump();

      // Pump timer steps until scan finishes
      for (int i = 0; i < 70; i++) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('DEVICES DISCOVERED'), findsOneWidget);
      expect(find.textContaining('0x27 (16x2 LCD Display)'), findsOneWidget);
      expect(find.textContaining('0x68 (DS3231 RTC Module)'), findsOneWidget);
    });

    testWidgets(
        'I2cPullupCheckerWidget evaluates pullup resistor values and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        I2cPullupCheckerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('I2C Open-Drain Architecture'), findsOneWidget);

      // Test missing
      await tester.tap(find.byKey(const Key('pullup_select_missing')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('OPEN-DRAIN MASTERED'), findsOneWidget);
      expect(find.textContaining('BUS DEAD'), findsOneWidget);

      // Test weak 100k
      await tester.tap(find.byKey(const Key('pullup_select_weak')));
      await tester.pumpAndSettle();
      expect(find.textContaining('DISTORTED RC'), findsOneWidget);

      // Restore proper 4.7k
      await tester.tap(find.byKey(const Key('pullup_select_proper')));
      await tester.pumpAndSettle();
      expect(find.textContaining('CRISP SQUARE WAVE'), findsOneWidget);
    });
  });

  group('Lesson 10 Interactive Activity Widgets', () {
    testWidgets(
        'SpiFullDuplexVisualizerWidget executes 8-bit full-duplex transfer',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SpiFullDuplexVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SPI Full-Duplex Shift Register'),
          findsOneWidget);

      // Step through 8 clock ticks
      for (int i = 0; i < 8; i++) {
        await tester.tap(find.byKey(const Key('spi_clock_tick_button')));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('FULL-DUPLEX VERIFIED'), findsOneWidget);

      // Reset
      await tester.tap(find.byKey(const Key('spi_reset_button')));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'ChipSelectArbitratorWidget manages CS pins and prevents contention',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ChipSelectArbitratorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SPI Chip Select Arbitrator'), findsOneWidget);

      // Toggle CS2 (Matrix)
      await tester.tap(find.byKey(const Key('toggle_cs2_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('ARBITRATION MASTERED'), findsOneWidget);
      expect(find.textContaining('BUS CONTENTION HAZARD'), findsOneWidget);

      // Turn CS1 off (standby)
      await tester.tap(find.byKey(const Key('toggle_cs1_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Device 2 Active'), findsOneWidget);
    });

    testWidgets(
        'SpiVsI2cComparisonWidget solves architecture trade-off challenges',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SpiVsI2cComparisonWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SPI vs. I2C Engineering'), findsOneWidget);

      // Scenario 1: Flash Storage -> Choose SPI
      await tester.tap(find.byKey(const Key('scenario_select_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('choose_spi_button')));
      await tester.pumpAndSettle();

      // Scenario 2: Multi-Sensor -> Choose I2C
      await tester.tap(find.byKey(const Key('scenario_select_2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('choose_i2c_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('DECISION MATRIX MASTERED'), findsOneWidget);
    });

    testWidgets('SpiClockPolarityPhaseLabWidget explores SPI Modes 0, 1, 2, 3',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        SpiClockPolarityPhaseLabWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('SPI Clock Polarity (CPOL) & Phase'),
          findsOneWidget);

      // Select Mode 1
      await tester.tap(find.byKey(const Key('spi_mode_1_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('MODES MASTERED'), findsOneWidget);
      expect(find.textContaining('SPI_MODE1'), findsWidgets);

      // Select Mode 2
      await tester.tap(find.byKey(const Key('spi_mode_2_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Idle HIGH'), findsOneWidget);

      // Select Mode 3
      await tester.tap(find.byKey(const Key('spi_mode_3_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('SPI_MODE3'), findsWidgets);
    });
  });

  group('Responsive Small-Screen (360px Mobile) Tests', () {
    void setupMobile(WidgetTester tester) {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    testWidgets('1. FloatingPinSimulatorWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const FloatingPinSimulatorWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('2. InternalPullupCircuitDiagramWidget on 360px',
        (tester) async {
      setupMobile(tester);
      await tester.pumpWidget(
          wrapWithMaterial(const InternalPullupCircuitDiagramWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('3. SwitchBounceVisualizerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const SwitchBounceVisualizerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('4. ActiveLowLogicCheckerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const ActiveLowLogicCheckerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('5. I2cBusTimingDiagramWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const I2cBusTimingDiagramWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('6. I2cDaisyChainSimulatorWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const I2cDaisyChainSimulatorWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('7. I2cAddressScannerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const I2cAddressScannerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('8. I2cPullupCheckerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester.pumpWidget(wrapWithMaterial(const I2cPullupCheckerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('9. SpiFullDuplexVisualizerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const SpiFullDuplexVisualizerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('10. ChipSelectArbitratorWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const ChipSelectArbitratorWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('11. SpiVsI2cComparisonWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const SpiVsI2cComparisonWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('12. SpiClockPolarityPhaseLabWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const SpiClockPolarityPhaseLabWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
