import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';
import 'package:monster_lab/presentation/features/learn/widgets/led_polarity_inspector_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/resistor_ohm_law_simulator_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/breadboard_internal_bus_inspector_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/blink_timing_lab_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/voltage_divider_cutaway_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/adc_sampling_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/wiper_pinout_checker_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/analog_read_noise_filter_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/common_cathode_vs_anode_diagram_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/pwm_duty_cycle_visualizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/rgb_color_synthesizer_widget.dart';
import 'package:monster_lab/presentation/features/learn/widgets/pwm_pin_identifier_widget.dart';

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

  group('ActivityRegistry Batch 2 Registration Tests', () {
    test(
        'verifies all 12 Batch 2 activities are registered in ActivityRegistry',
        () {
      expect(ActivityRegistry.hasActivity('ledPolarityInspector'), isTrue);
      expect(ActivityRegistry.hasActivity('resistorOhmLawSimulator'), isTrue);
      expect(ActivityRegistry.hasActivity('breadboardInternalBusInspector'),
          isTrue);
      expect(ActivityRegistry.hasActivity('blinkTimingLab'), isTrue);
      expect(ActivityRegistry.hasActivity('voltageDividerCutaway'), isTrue);
      expect(ActivityRegistry.hasActivity('adcSamplingVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('wiperPinoutChecker'), isTrue);
      expect(ActivityRegistry.hasActivity('analogReadNoiseFilter'), isTrue);
      expect(
          ActivityRegistry.hasActivity('commonCathodeVsAnodeDiagram'), isTrue);
      expect(ActivityRegistry.hasActivity('pwmDutyCycleVisualizer'), isTrue);
      expect(ActivityRegistry.hasActivity('rgbColorSynthesizer'), isTrue);
      expect(ActivityRegistry.hasActivity('pwmPinIdentifier'), isTrue);
    });
  });

  group('Lesson 05 Interactive Activity Widgets', () {
    testWidgets(
        'LedPolarityInspectorWidget inspects anatomy, flips polarity, and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        LedPolarityInspectorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('5mm LED Anatomy & Polarity Inspector'),
          findsOneWidget);
      expect(find.text('POWER OFF'), findsOneWidget);

      // Inspect Cathode and Anode
      await tester.tap(find.byKey(const Key('led_inspect_cathode_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('CATHODE (−): Larger anvil flag'),
          findsOneWidget);

      await tester.tap(find.byKey(const Key('led_inspect_anode_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('ANODE (+): Smaller post contact'),
          findsOneWidget);

      // Apply 5V power (forward biased by default)
      expect(find.text('Anode (+) ➔ +5V'), findsOneWidget);
      expect(find.text('Cathode (−) ➔ GND'), findsOneWidget);

      await tester.tap(find.byKey(const Key('led_test_circuit_button')));
      await tester.pumpAndSettle();
      expect(find.text('EMITTING PHOTONS'), findsOneWidget);

      // Flip polarity to reverse bias
      await tester.tap(find.byKey(const Key('led_flip_polarity_button')));
      await tester.pumpAndSettle();
      expect(find.text('BLOCKED (REVERSE BIAS)'), findsOneWidget);
      expect(find.text('Anode (+) ➔ GND'), findsOneWidget);
      expect(find.text('Cathode (−) ➔ +5V'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.textContaining('Polarity Mastery Complete'), findsOneWidget);
    });

    testWidgets(
        'ResistorOhmLawSimulatorWidget explores safe vs burnout and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        ResistorOhmLawSimulatorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining("Ohm's Law & Current-Limiting Simulator"),
          findsOneWidget);
      expect(find.text('OPTIMAL CURRENT'), findsOneWidget);

      // Tap 10k Ohm (Extremely dim, previously crashed slider assert if max was 2000)
      await tester.tap(find.byKey(const Key('resistor_preset_10k')));
      await tester.pumpAndSettle();
      expect(find.text('LOW CURRENT (DIM)'), findsOneWidget);

      // Tap 0 Ohm (Burnout hazard)
      await tester.tap(find.byKey(const Key('resistor_preset_0')));
      await tester.pumpAndSettle();
      expect(find.text('BURNOUT BLOWOUT!'), findsOneWidget);
      expect(find.textContaining('FATAL: Pin rated for max 20mA!'),
          findsOneWidget);

      // Tap 220 Ohm (Standard safe)
      await tester.tap(find.byKey(const Key('resistor_preset_220')));
      await tester.pumpAndSettle();
      expect(find.text('OPTIMAL CURRENT'), findsOneWidget);

      // Tap Verify
      await tester.tap(find.byKey(const Key('resistor_test_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.textContaining("Ohm's Law Mastered!"), findsOneWidget);
    });

    testWidgets(
        'BreadboardInternalBusInspectorWidget tests continuity paths and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        BreadboardInternalBusInspectorWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Breadboard Internal Bus & Clip Inspector'),
          findsOneWidget);
      expect(find.text('CONTINUOUS (0.00 Ω)'), findsOneWidget);

      // Test across divider
      await tester.tap(find.byKey(const Key('probe_across_divider')));
      await tester.pumpAndSettle();
      expect(find.text('OPEN CIRCUIT (∞ MΩ)'), findsOneWidget);

      // Test power rail
      await tester.tap(find.byKey(const Key('probe_power_rail')));
      await tester.pumpAndSettle();
      expect(find.text('CONTINUOUS (0.00 Ω)'), findsOneWidget);

      // Test different rows
      await tester.tap(find.byKey(const Key('probe_different_rows')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(
          find.textContaining('Breadboard Mastery Verified!'), findsOneWidget);
    });

    testWidgets(
        'BlinkTimingLabWidget switches between discrete and POV fusion and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        BlinkTimingLabWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Blink Timing & Persistence of Vision (POV) Lab'),
          findsOneWidget);
      expect(find.text('DISCRETE BLINKS'), findsOneWidget);

      // Select POV Fusion preset (20ms / 20ms)
      await tester.tap(find.byKey(const Key('preset_pov_fusion')));
      await tester.pumpAndSettle();

      expect(find.text('POV FUSION (>30 Hz)'), findsOneWidget);
      expect(completed, isTrue);
      expect(find.textContaining('Blink Timing Mastery Verified!'),
          findsOneWidget);
    });
  });

  group('Lesson 06 Interactive Activity Widgets', () {
    testWidgets('VoltageDividerCutawayWidget sweeps wiper knob and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        VoltageDividerCutawayWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'Potentiometer Internal Cutaway & Voltage Divider Math'),
          findsOneWidget);
      expect(find.text('2.50 V'), findsOneWidget);

      // Tap 0% (min)
      await tester.tap(find.byKey(const Key('knob_preset_min')));
      await tester.pumpAndSettle();
      expect(find.text('0.00 V'), findsOneWidget);

      // Tap 100% (max)
      await tester.tap(find.byKey(const Key('knob_preset_max')));
      await tester.pumpAndSettle();
      expect(find.text('5.00 V'), findsOneWidget);

      expect(find.text('Pin 1: GND'), findsOneWidget);
      expect(find.text('Pin 3: 5V'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.textContaining('Voltage Divider Math Mastered!'),
          findsOneWidget);
    });

    testWidgets(
        'AdcSamplingVisualizerWidget tests voltage quantization steps and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        AdcSamplingVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('10-Bit ADC Sampling & Quantization Visualizer'),
          findsOneWidget);
      expect(find.text('ADC: 512 / 1023'), findsOneWidget);

      // Tap 0.00V preset
      await tester.tap(find.byKey(const Key('adc_preset_0v')));
      await tester.pumpAndSettle();
      expect(find.text('ADC: 0 / 1023'), findsOneWidget);

      // Tap 5.00V preset
      await tester.tap(find.byKey(const Key('adc_preset_5v')));
      await tester.pumpAndSettle();
      expect(find.text('ADC: 1023 / 1023'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.textContaining('10-Bit ADC Quantization Mastered!'),
          findsOneWidget);
    });

    testWidgets(
        'WiperPinoutCheckerWidget catches dead short and verifies correct wiring',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        WiperPinoutCheckerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'Potentiometer 3-Pin Wiring & Short-Circuit Inspector'),
          findsOneWidget);
      expect(find.text('SAFE & FUNCTIONAL'), findsOneWidget);

      // Tap Dead Short Trap
      await tester.tap(find.byKey(const Key('wiper_wire_short_preset')));
      await tester.pumpAndSettle();
      expect(find.text('DEAD SHORT HAZARD!'), findsOneWidget);

      // Return to Correct Preset
      await tester.tap(find.byKey(const Key('wiper_wire_correct_preset')));
      await tester.pumpAndSettle();
      expect(find.text('SAFE & FUNCTIONAL'), findsOneWidget);

      // Verify Safety
      await tester.tap(find.byKey(const Key('wiper_verify_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.textContaining('Potentiometer Pinout Mastery Verified!'),
          findsOneWidget);
    });

    testWidgets(
        'AnalogReadNoiseFilterWidget switches between noise modes and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        AnalogReadNoiseFilterWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'Floating Analog Input Noise & Digital Filtering Lab'),
          findsOneWidget);
      expect(find.textContaining('ERRATIC NOISE'), findsOneWidget);

      // Select Tied to GND
      await tester.tap(find.byKey(const Key('noise_filter_mode_ground')));
      await tester.pumpAndSettle();
      expect(find.textContaining('GND ZERO'), findsOneWidget);

      // Select Filtered EMA
      await tester.tap(find.byKey(const Key('noise_filter_mode_smoothed')));
      await tester.pumpAndSettle();
      expect(find.textContaining('SMOOTHED (EMA FILTER)'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.textContaining('Analog Noise & Filtering Mastery Verified!'),
          findsOneWidget);
    });
  });

  group('Lesson 07 Interactive Activity Widgets', () {
    testWidgets(
        'CommonCathodeVsAnodeDiagramWidget compares CC and CA logic and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        CommonCathodeVsAnodeDiagramWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'Common Cathode vs Common Anode RGB LED Inspector'),
          findsOneWidget);
      expect(find.text('COMMON CATHODE (CC)'), findsOneWidget);

      // Switch to Common Anode
      await tester.tap(find.byKey(const Key('toggle_common_anode')));
      await tester.pumpAndSettle();
      expect(find.text('COMMON ANODE (CA)'), findsOneWidget);
      expect(
          find.textContaining('Logic: ACTIVE-LOW (INVERTED)'), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.byKey(const Key('cc_ca_test_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.textContaining('RGB Package Polarity Mastered!'),
          findsOneWidget);
    });

    testWidgets(
        'PwmDutyCycleVisualizerWidget adjusts PWM slider and presets and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        PwmDutyCycleVisualizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('490 Hz PWM Duty Cycle & Oscilloscope Simulator'),
          findsOneWidget);
      expect(find.text('50% DUTY CYCLE'), findsOneWidget);

      // Tap 0% (OFF)
      await tester.tap(find.byKey(const Key('pwm_preset_0')));
      await tester.pumpAndSettle();
      expect(find.text('0% DUTY CYCLE'), findsOneWidget);

      // Tap 100% (Full)
      await tester.tap(find.byKey(const Key('pwm_preset_255')));
      await tester.pumpAndSettle();
      expect(find.text('100% DUTY CYCLE'), findsOneWidget);

      expect(completed, isTrue);
      expect(find.textContaining('PWM Duty Cycle Mastery Verified!'),
          findsOneWidget);
    });

    testWidgets(
        'RgbColorSynthesizerWidget mixes secondary colors and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        RgbColorSynthesizerWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('RGB Additive Optical Color Synthesizer'),
          findsOneWidget);

      // Mix Yellow (R + G)
      await tester.tap(find.byKey(const Key('preset_yellow')));
      await tester.pumpAndSettle();
      expect(find.text('#FFFF00'), findsOneWidget);

      // Mix Cyan (G + B)
      await tester.tap(find.byKey(const Key('preset_cyan')));
      await tester.pumpAndSettle();
      expect(find.text('#00FFFF'), findsOneWidget);

      expect(completed, isTrue);
      expect(
          find.textContaining('Additive RGB Mixing Mastered!'), findsOneWidget);
    });

    testWidgets(
        'PwmPinIdentifierWidget inspects PWM and non-PWM pins and completes',
        (tester) async {
      setupScreen(tester);
      bool completed = false;

      await tester.pumpWidget(wrapWithMaterial(
        PwmPinIdentifierWidget(
          onComplete: () {
            completed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Uno PWM Pin Identifier (~ Tilde) & Timer Map'),
          findsOneWidget);

      // Inspect Pin 13 (Non-PWM)
      await tester.tap(find.byKey(const Key('pwm_pin_13')));
      await tester.pumpAndSettle();
      expect(find.text('NO PWM'), findsOneWidget);
      expect(find.textContaining('Does NOT support hardware PWM!'),
          findsOneWidget);

      // Inspect Pin 5 (Timer0, 980 Hz)
      await tester.tap(find.byKey(const Key('pwm_pin_5')));
      await tester.pumpAndSettle();
      expect(find.text('PWM CAPABLE'), findsOneWidget);
      expect(find.text('980 Hz'), findsOneWidget);

      // Tap Check All button
      await tester.tap(find.byKey(const Key('pwm_check_all_button')));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.text('PWM PINS: 6 / 6 FOUND'), findsOneWidget);
      expect(find.textContaining('Uno PWM Hardware Map Mastered!'),
          findsOneWidget);
    });
  });
}
