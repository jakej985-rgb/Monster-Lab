import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';
import 'package:monster_lab/presentation/features/learn/widgets/uart_frame_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/tx_rx_cross_wire_checker_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/bluetooth_at_command_terminal_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/baud_rate_mismatch_demo_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/inductive_kickback_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/h_bridge_direction_switch_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/servo_pulse_width_modulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/external_motor_power_lab_widget.dart';

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

  group('ActivityRegistry Batch 4 Registration Tests', () {
    test('verifies all 8 Batch 4 activities are registered', () {
      expect(ActivityRegistry.hasActivity('uartFrameVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('txRxCrossWireChecker'), isTrue);
      expect(
          ActivityRegistry.hasActivity('bluetoothAtCommandTerminal'), isTrue);
      expect(ActivityRegistry.hasActivity('baudRateMismatchDemo'), isTrue);
      expect(
          ActivityRegistry.hasActivity('inductiveKickbackSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('hBridgeDirectionSwitch'), isTrue);
      expect(ActivityRegistry.hasActivity('servoPulseWidthModulator'), isTrue);
      expect(ActivityRegistry.hasActivity('externalMotorPowerLab'), isTrue);
    });

    test('buildActivity instantiates Batch 4 widgets correctly', () {
      final context = _MockBuildContext();
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'uartFrameVisualizer',
        ),
        isA<UartFrameVisualizerWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'txRxCrossWireChecker',
        ),
        isA<TxRxCrossWireCheckerWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'bluetoothAtCommandTerminal',
        ),
        isA<BluetoothAtCommandTerminalWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'baudRateMismatchDemo',
        ),
        isA<BaudRateMismatchDemoWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'inductiveKickbackSimulator',
        ),
        isA<InductiveKickbackSimulatorWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'hBridgeDirectionSwitch',
        ),
        isA<HBridgeDirectionSwitchWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'servoPulseWidthModulator',
        ),
        isA<ServoPulseWidthModulatorWidget>(),
      );
      expect(
        ActivityRegistry.buildActivity(
          context: context,
          activityType: 'externalMotorPowerLab',
        ),
        isA<ExternalMotorPowerLabWidget>(),
      );
    });
  });

  group('Lesson 11 Interactive Activity Widgets', () {
    testWidgets(
        'UartFrameVisualizerWidget steps through bits and triggers onComplete',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        UartFrameVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('UART Frame & Waveform Visualizer'),
          findsOneWidget);

      // Select a preset character 'M'
      await tester.tap(find.byKey(const Key('char_preset_M')));
      await tester.pumpAndSettle();

      // Change baud rate to 19200
      await tester.tap(find.byKey(const Key('baud_chip_19200')));
      await tester.pumpAndSettle();

      // Enable even parity
      await tester.tap(find.byKey(const Key('parity_even')));
      await tester.pumpAndSettle();

      // Step forward through bits multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('step_bit_button')));
        await tester.pumpAndSettle();
      }

      expect(completed, isTrue);
      expect(find.text('FRAME MASTERED'), findsOneWidget);

      // Reset bit cursor
      await tester.tap(find.byKey(const Key('reset_bit_button')));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'TxRxCrossWireCheckerWidget verifies crossed wiring and voltage divider',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        TxRxCrossWireCheckerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('TX / RX Cross-Wire'), findsOneWidget);

      // Initially straight wiring: test transmission
      await tester.tap(find.byKey(const Key('test_connection_button')));
      await tester.pump(const Duration(milliseconds: 600));
      expect(completed, isFalse);

      // Switch to crossed wiring
      await tester.tap(find.byKey(const Key('wire_crossed_button')));
      await tester.pumpAndSettle();

      // Activate 1k/2k voltage divider
      await tester.tap(find.byKey(const Key('toggle_divider_button')));
      await tester.pumpAndSettle();

      // Retest connection
      await tester.tap(find.byKey(const Key('test_connection_button')));
      await tester.pump(const Duration(milliseconds: 600));

      expect(completed, isTrue);
      expect(find.text('WIRING VERIFIED'), findsOneWidget);
    });

    testWidgets(
        'BluetoothAtCommandTerminalWidget sends AT commands and logs response',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        BluetoothAtCommandTerminalWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('HC-05 Bluetooth AT Command Terminal'),
          findsOneWidget);

      // Send AT test command preset
      await tester.tap(find.byKey(const Key('preset_at_test')));
      await tester.pumpAndSettle();

      // Send AT+NAME preset
      await tester.tap(find.byKey(const Key('preset_at_name')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('AT MASTERED'), findsOneWidget);

      // Toggle to data mode
      await tester.tap(find.byKey(const Key('toggle_at_mode')));
      await tester.pumpAndSettle();
      expect(find.textContaining('DATA MODE'), findsOneWidget);
    });

    testWidgets(
        'BaudRateMismatchDemoWidget simulates clock drift and synchronizes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        BaudRateMismatchDemoWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Baud Rate Clock Mismatch'), findsOneWidget);

      // Transmit with default mismatch (115200 vs 9600)
      await tester.tap(find.byKey(const Key('send_packet_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('FRAMING ERROR'), findsWidgets);

      // Synchronize baud clocks
      await tester.tap(find.byKey(const Key('match_baud_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('TIMING SYNC MASTERED'), findsOneWidget);
      expect(find.textContaining('DECODE OK'), findsOneWidget);
    });
  });

  group('Lesson 12 Interactive Activity Widgets', () {
    testWidgets(
        'InductiveKickbackSimulatorWidget tests back-EMF spike and clamping diode',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        InductiveKickbackSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Inductive Kickback'), findsOneWidget);

      // Switch OFF without diode -> massive 85V spike
      await tester.tap(find.byKey(const Key('toggle_motor_switch')));
      await tester.pumpAndSettle();

      expect(find.textContaining('ARC BREAKDOWN'), findsOneWidget);

      // Install 1N4007 flyback diode
      await tester.tap(find.byKey(const Key('toggle_flyback_diode')));
      await tester.pumpAndSettle();

      // Cycle switch again to test clamped state
      await tester.tap(find.byKey(const Key('toggle_motor_switch')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle_motor_switch')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('DIODE CLAMP VERIFIED'), findsOneWidget);
      expect(find.textContaining('CLAMPED: Current Recirculating'),
          findsOneWidget);
    });

    testWidgets(
        'HBridgeDirectionSwitchWidget tests forward, reverse, and shoot-through',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        HBridgeDirectionSwitchWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('4-Transistor H-Bridge'), findsOneWidget);

      // Test reverse spin
      await tester.tap(find.byKey(const Key('hbridge_reverse_btn')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.textContaining('REVERSE ↺'), findsOneWidget);

      // Test dynamic brake
      await tester.tap(find.byKey(const Key('hbridge_brake_btn')));
      await tester.pumpAndSettle();
      expect(find.textContaining('DYNAMIC BRAKING'), findsOneWidget);

      // Test shoot-through simulation
      await tester.tap(find.byKey(const Key('hbridge_shoot_through_btn')));
      await tester.pumpAndSettle();
      expect(
          find.textContaining('SHOOT-THROUGH SHORT CIRCUIT'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.text('H-BRIDGE MASTERED'), findsOneWidget);
    });

    testWidgets(
        'ServoPulseWidthModulatorWidget tests PWM angles and slider adjustments',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ServoPulseWidthModulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('50Hz Servo Pulse Width Modulator'),
          findsOneWidget);

      // Test 0 degree preset
      await tester.tap(find.byKey(const Key('preset_0_deg')));
      await tester.pumpAndSettle();
      expect(find.text('0°'), findsOneWidget);

      // Test 180 degree preset
      await tester.tap(find.byKey(const Key('preset_180_deg')));
      await tester.pumpAndSettle();
      expect(find.text('180°'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.text('SERVO PWM MASTERED'), findsOneWidget);

      // Drag slider
      await tester.drag(
          find.byKey(const Key('pulse_width_slider')), const Offset(-40, 0));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'ExternalMotorPowerLabWidget tests power isolation and brownout crash',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ExternalMotorPowerLabWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('External Motor Power'), findsOneWidget);

      // Switch to risky Arduino 5V regulator
      await tester.tap(find.byKey(const Key('config_arduino_power')));
      await tester.pumpAndSettle();

      // Increase load to stall -> causes brownout crash
      await tester.tap(find.byKey(const Key('load_stall_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('BROWNOUT CRASH'), findsOneWidget);

      // Switch back to external battery with common ground
      await tester.tap(find.byKey(const Key('config_external_power')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('POWER ISOLATED'), findsOneWidget);
      expect(find.textContaining('STABLE'), findsOneWidget);
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

    testWidgets('1. UartFrameVisualizerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const UartFrameVisualizerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('2. TxRxCrossWireCheckerWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const TxRxCrossWireCheckerWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('3. BluetoothAtCommandTerminalWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester.pumpWidget(
          wrapWithMaterial(const BluetoothAtCommandTerminalWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('4. BaudRateMismatchDemoWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const BaudRateMismatchDemoWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('5. InductiveKickbackSimulatorWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester.pumpWidget(
          wrapWithMaterial(const InductiveKickbackSimulatorWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('6. HBridgeDirectionSwitchWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const HBridgeDirectionSwitchWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('7. ServoPulseWidthModulatorWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const ServoPulseWidthModulatorWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('8. ExternalMotorPowerLabWidget on 360px', (tester) async {
      setupMobile(tester);
      await tester
          .pumpWidget(wrapWithMaterial(const ExternalMotorPowerLabWidget()));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}

class _MockBuildContext extends Fake implements BuildContext {}
