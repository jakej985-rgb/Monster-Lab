import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/shared/widgets/responsive_code_block.dart';

void main() {
  group('ResponsiveCodeBlock Widget Tests', () {
    testWidgets('Renders code text and copy button', (tester) async {
      const sampleCode = 'void setup() {\n  pinMode(13, OUTPUT);\n}\n';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveCodeBlock(
              code: sampleCode,
              language: 'cpp',
            ),
          ),
        ),
      );

      expect(find.text(sampleCode), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('Tapping copy button displays feedback snackbar',
        (tester) async {
      const sampleCode = 'digitalWrite(13, HIGH);';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveCodeBlock(
              code: sampleCode,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump(); // Start snackbar animation

      expect(find.text('Copied!'), findsOneWidget);
    });

    testWidgets(
        'Wraps long code lines on narrow containers without layout overflow',
        (tester) async {
      const longLine =
          'Serial.println("This is an extremely long debug output statement intended to verify wrapping inside ResponsiveCodeBlock");';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: ResponsiveCodeBlock(
                code: longLine,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(longLine), findsOneWidget);
    });
  });
}
