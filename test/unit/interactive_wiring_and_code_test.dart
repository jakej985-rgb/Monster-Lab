import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/theme/app_colors.dart';
import 'package:monster_lab/domain/models/circuit_wiring_model.dart';
import 'package:monster_lab/domain/models/code_experiment_model.dart';
import 'package:monster_lab/presentation/features/lab/widgets/arduino_syntax_highlighter.dart';

void main() {
  group('Circuit Wiring Validator Tests', () {
    final blinkPreset = CircuitPresets.blinkLed;

    test('Empty circuit triggers missing connections error', () {
      final result = blinkPreset.validator([]);
      expect(result.isValid, isFalse);
      expect(result.title, contains('Circuit Incomplete'));
    });

    test('Direct power-to-ground connection triggers short circuit error', () {
      final shortWires = [
        const JumperWire(
          id: 'wire_1',
          fromPinId: 'uno_5v',
          toPinId: 'uno_gnd',
          color: Colors.red,
        ),
      ];
      final result = blinkPreset.validator(shortWires);
      expect(result.isValid, isFalse);
      expect(result.shortCircuitDetected, isTrue);
      expect(result.title, contains('Short Circuit'));
    });

    test('LED connected without current-limiting resistor triggers warning',
        () {
      final missingResistorWires = [
        const JumperWire(
            id: 'w1',
            fromPinId: 'uno_d13',
            toPinId: 'led_anode',
            color: Colors.yellow),
        const JumperWire(
            id: 'w2',
            fromPinId: 'led_cathode',
            toPinId: 'uno_gnd',
            color: Colors.blue),
      ];
      final result = blinkPreset.validator(missingResistorWires);
      expect(result.isValid, isFalse);
      expect(result.missingResistorDetected, isTrue);
      expect(result.message, contains('without a 220Ω resistor'));
    });

    test('Reversed LED polarity triggers reversed polarity warning', () {
      final reversedWires = [
        // Power through resistor to cathode instead of anode
        const JumperWire(
            id: 'w1',
            fromPinId: 'uno_d13',
            toPinId: 'res_leg1',
            color: Colors.yellow),
        const JumperWire(
            id: 'w2',
            fromPinId: 'res_leg2',
            toPinId: 'led_cathode',
            color: Colors.red),
      ];
      final result = blinkPreset.validator(reversedWires);
      expect(result.isValid, isFalse);
      expect(result.reversedPolarityDetected, isTrue);
      expect(result.title, contains('Reversed LED Polarity'));
    });

    test('Correct blink LED circuit validation succeeds', () {
      final validWires = [
        const JumperWire(
            id: 'w1',
            fromPinId: 'uno_d13',
            toPinId: 'res_leg1',
            color: Colors.yellow),
        const JumperWire(
            id: 'w2',
            fromPinId: 'res_leg2',
            toPinId: 'led_anode',
            color: Colors.red),
        const JumperWire(
            id: 'w3',
            fromPinId: 'led_cathode',
            toPinId: 'uno_gnd',
            color: Colors.blue),
      ];
      final result = blinkPreset.validator(validWires);
      expect(result.isValid, isTrue);
      expect(result.title, contains('Perfect Closed Loop'));
    });

    final sonarPreset = CircuitPresets.ultrasonicSonar;

    test('Sonar empty wiring warns of missing power/pins', () {
      final result = sonarPreset.validator([]);
      expect(result.isValid, isFalse);
      expect(result.title, contains('Sonar Wiring Incomplete'));
    });

    test('Sonar detects swapped Trig/Echo pins', () {
      final swappedWires = [
        const JumperWire(
            id: 'w1',
            fromPinId: 'uno_5v',
            toPinId: 'sonar_vcc',
            color: Colors.red),
        const JumperWire(
            id: 'w2',
            fromPinId: 'uno_gnd',
            toPinId: 'sonar_gnd',
            color: Colors.black),
        const JumperWire(
            id: 'w3',
            fromPinId: 'uno_d9',
            toPinId: 'sonar_echo',
            color: Colors.green), // Swapped
        const JumperWire(
            id: 'w4',
            fromPinId: 'uno_d10',
            toPinId: 'sonar_trig',
            color: Colors.yellow), // Swapped
      ];
      final result = sonarPreset.validator(swappedWires);
      expect(result.isValid, isFalse);
      expect(result.title, contains('TRIG and ECHO Swapped'));
    });

    test('Sonar valid 4-wire connection passes', () {
      final validWires = [
        const JumperWire(
            id: 'w1',
            fromPinId: 'uno_5v',
            toPinId: 'sonar_vcc',
            color: Colors.red),
        const JumperWire(
            id: 'w2',
            fromPinId: 'uno_d9',
            toPinId: 'sonar_trig',
            color: Colors.green),
        const JumperWire(
            id: 'w3',
            fromPinId: 'uno_d10',
            toPinId: 'sonar_echo',
            color: Colors.yellow),
        const JumperWire(
            id: 'w4',
            fromPinId: 'uno_gnd',
            toPinId: 'sonar_gnd',
            color: Colors.black),
      ];
      final result = sonarPreset.validator(validWires);
      expect(result.isValid, isTrue);
      expect(result.title, contains('Sonar Sensor Online'));
    });
  });

  group('Arduino Syntax Highlighter Tests', () {
    test('Highlights preprocessor directives with syntaxPreproc', () {
      final spans = ArduinoSyntaxHighlighter.highlight('#include <Servo.h>');
      expect(spans, isNotEmpty);
      final preprocSpan =
          spans.firstWhere((s) => s.style?.color == AppColors.syntaxPreproc);
      expect(preprocSpan.text, contains('#include'));
    });

    test('Highlights single line comments with syntaxComment', () {
      final spans = ArduinoSyntaxHighlighter.highlight(
          '// This is a comment\nvoid setup()');
      final commentSpan =
          spans.firstWhere((s) => s.style?.color == AppColors.syntaxComment);
      expect(commentSpan.text, equals('// This is a comment'));
    });

    test('Highlights keywords and functions', () {
      const code =
          'const int ledPin = 9;\nvoid setup() {\n  pinMode(ledPin, OUTPUT);\n}';
      final spans = ArduinoSyntaxHighlighter.highlight(code);

      final keywordSpan = spans.firstWhere((s) =>
          s.text == 'const' && s.style?.color == AppColors.syntaxKeyword);
      expect(keywordSpan, isNotNull);

      final funcSpan = spans.firstWhere((s) =>
          s.text == 'setup' && s.style?.color == AppColors.syntaxFunction);
      expect(funcSpan, isNotNull);

      final constSpan = spans.firstWhere((s) =>
          s.text == 'OUTPUT' && s.style?.color == AppColors.syntaxConstant);
      expect(constSpan, isNotNull);
    });

    test('Highlights string literals', () {
      const code = 'Serial.println("Hello Monsters!");';
      final spans = ArduinoSyntaxHighlighter.highlight(code);
      final stringSpan =
          spans.firstWhere((s) => s.style?.color == AppColors.syntaxString);
      expect(stringSpan.text, equals('"Hello Monsters!"'));
    });
  });

  group('Code Experiment Model Tests', () {
    test('renderCode dynamically replaces variable tokens', () {
      const experiment = CodePresets.blinkExperiment;
      final renderedDefault = experiment.renderCode({'blinkDelay': 1000});
      expect(renderedDefault, contains('int blinkDelay = 1000;'));

      final renderedFast = experiment.renderCode({'blinkDelay': 150});
      expect(renderedFast, contains('int blinkDelay = 150;'));
    });

    test('Compiler error samples offer kid-friendly explanations and fixes',
        () {
      const experiment = CodePresets.blinkExperiment;
      expect(experiment.errorSamples.length, greaterThanOrEqualTo(3));

      for (final sample in experiment.errorSamples) {
        expect(sample.title.isNotEmpty, isTrue);
        expect(sample.rawCompilerOutput.isNotEmpty, isTrue);
        expect(sample.kidExplanation.isNotEmpty, isTrue);
        expect(sample.fixedCode.isNotEmpty, isTrue);
        expect(sample.buggyCode, isNot(equals(sample.fixedCode)));
      }
    });
  });
}
