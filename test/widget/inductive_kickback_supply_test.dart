import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/widgets/inductive_kickback_simulator_widget.dart';

Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

Future<void> showProtectedState(
  WidgetTester tester,
  Map<String, dynamic> config,
) async {
  await tester.pumpWidget(
    wrap(InductiveKickbackSimulatorWidget(config: config)),
  );
  await tester.tap(find.byKey(const Key('toggle_flyback_diode')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('toggle_motor_switch')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('default supply clamps at 5.7 V', (tester) async {
    await showProtectedState(tester, const {});
    expect(find.text('5.7V'), findsOneWidget);
    expect(find.text('Diode Clamped (5.7V)'), findsOneWidget);
  });

  testWidgets('clamp follows a configured supply and diode drop', (
    tester,
  ) async {
    await showProtectedState(tester, {
      'supplyVoltageV': 9.0,
      'diodeForwardVoltageV': 1.0,
    });
    expect(find.text('10.0V'), findsOneWidget);
    expect(find.text('Diode Clamped (10.0V)'), findsOneWidget);
  });

  testWidgets('unprotected 85 V value is labeled illustrative', (tester) async {
    await tester.pumpWidget(wrap(const InductiveKickbackSimulatorWidget()));
    await tester.tap(find.byKey(const Key('toggle_motor_switch')));
    await tester.pumpAndSettle();
    expect(find.textContaining('85V MODEL SPIKE (Illustrative)'), findsWidgets);
    expect(
      find.textContaining('Actual transient voltage depends'),
      findsOneWidget,
    );
  });
}
