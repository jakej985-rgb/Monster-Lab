class CodeVariable {
  final String name;
  final String label;
  final String type;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final int step;
  final String unit;
  final String description;

  const CodeVariable({
    required this.name,
    required this.label,
    required this.type,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    this.step = 100,
    required this.unit,
    required this.description,
  });

  CodeVariable copyWith({int? currentValue}) {
    return CodeVariable(
      name: name,
      label: label,
      type: type,
      currentValue: currentValue ?? this.currentValue,
      minValue: minValue,
      maxValue: maxValue,
      step: step,
      unit: unit,
      description: description,
    );
  }
}

class CompilerErrorSample {
  final String id;
  final String title;
  final String rawCompilerOutput;
  final String buggyCode;
  final String fixedCode;
  final String kidExplanation;
  final String theScience;

  const CompilerErrorSample({
    required this.id,
    required this.title,
    required this.rawCompilerOutput,
    required this.buggyCode,
    required this.fixedCode,
    required this.kidExplanation,
    required this.theScience,
  });
}

class CodePreset {
  final String id;
  final String title;
  final String description;
  final String baseCode;
  final List<CodeVariable> variables;
  final List<CompilerErrorSample> errorSamples;

  const CodePreset({
    required this.id,
    required this.title,
    required this.description,
    required this.baseCode,
    required this.variables,
    required this.errorSamples,
  });

  String renderCode(Map<String, int> values) {
    var result = baseCode;
    for (final entry in values.entries) {
      result = result.replaceAll('{{${entry.key}}}', entry.value.toString());
    }
    return result;
  }
}

abstract class CodePresets {
  static const CodePreset blinkExperiment = CodePreset(
    id: 'code_blink',
    title: 'Lesson 5: Blink Rate Experiment',
    description:
        'Experiment with Arduino timing loops and discover how delay() governs physical LED frequency.',
    baseCode: '''// Monster Lab: Lesson 5 Blink Experiment
const int ledPin = 13;
int blinkDelay = {{blinkDelay}}; // Milliseconds

void setup() {
  pinMode(ledPin, OUTPUT);
}

void loop() {
  digitalWrite(ledPin, HIGH); // Turn LED ON
  delay(blinkDelay);          // Wait
  digitalWrite(ledPin, LOW);  // Turn LED OFF
  delay(blinkDelay);          // Wait
}
''',
    variables: [
      CodeVariable(
        name: 'blinkDelay',
        label: 'Blink Interval',
        type: 'int',
        currentValue: 1000,
        minValue: 100,
        maxValue: 2500,
        step: 100,
        unit: 'ms',
        description:
            'Time in milliseconds the microcontroller pauses between state transitions.',
      ),
    ],
    errorSamples: [
      CompilerErrorSample(
        id: 'err_semicolon',
        title: 'Missing Semicolon Glitch',
        rawCompilerOutput:
            "sketch.ino:In function 'void loop()':\nsketch.ino:10:3: error: expected ';' before 'delay'",
        buggyCode: '''void loop() {
  digitalWrite(ledPin, HIGH) // <-- Missing semicolon!
  delay(blinkDelay);
}''',
        fixedCode: '''void loop() {
  digitalWrite(ledPin, HIGH); // Fixed!
  delay(blinkDelay);
}''',
        kidExplanation:
            'In C++, a semicolon (;) is like a period at the end of a sentence. Without it, Arduino reads the next command as one giant run-on sentence and gets confused!',
        theScience:
            'The compiler parser requires statement terminators (;) to construct the Abstract Syntax Tree (AST) before generating AVR assembly machine instructions.',
      ),
      CompilerErrorSample(
        id: 'err_brace',
        title: 'Mismatched Curly Braces',
        rawCompilerOutput:
            "sketch.ino:14:1: error: expected '}' at end of input",
        buggyCode: '''void loop() {
  digitalWrite(ledPin, HIGH);
  delay(blinkDelay);
  // <-- Forgot closing brace }''',
        fixedCode: '''void loop() {
  digitalWrite(ledPin, HIGH);
  delay(blinkDelay);
} // Fixed!''',
        kidExplanation:
            'Curly braces { } are like opening and closing a cardboard box. If you open a function with {, you must always close the box with }!',
        theScience:
            'Block scoping enforces code organization and stack frame boundaries. An unclosed brace leaves the function body open past the file terminator.',
      ),
      CompilerErrorSample(
        id: 'err_typo',
        title: 'Case-Sensitive Spelling Typo',
        rawCompilerOutput:
            "sketch.ino:In function 'void loop()':\nsketch.ino:9:3: error: 'digitalwrite' was not declared in this scope",
        buggyCode: '''void loop() {
  digitalwrite(ledPin, HIGH); // <-- lowercase 'w'!
}''',
        fixedCode: '''void loop() {
  digitalWrite(ledPin, HIGH); // Fixed capital 'W'!
}''',
        kidExplanation:
            'Arduino code is case-sensitive! It sees "digitalwrite" and "digitalWrite" as two completely different words. Always use camelCase: capital W!',
        theScience:
            'C++ symbols are matched byte-for-byte in the symbol lookup table. The Arduino wiring framework exports "digitalWrite", so lowercase lookups fail to resolve.',
      ),
    ],
  );

  static const List<CodePreset> all = [
    blinkExperiment,
  ];

  static CodePreset findById(String id) {
    return all.firstWhere((p) => p.id == id, orElse: () => blinkExperiment);
  }
}
