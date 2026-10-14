import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';
import 'package:monster_lab/presentation/features/learn/widgets/rfid_coupling_simulator_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  test('RFID coupling simulator is registered', () {
    expect(ActivityRegistry.hasActivity('rfidCouplingSimulator'), isTrue);
    expect(
      ActivityRegistry.buildActivity(
        context: _BuildContextStub(),
        activityType: 'rfidCouplingSimulator',
      ),
      isA<RfidCouplingSimulatorWidget>(),
    );
  });

  testWidgets('out-of-range tag stays unpowered and cannot be read', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const RfidCouplingSimulatorWidget()));
    expect(find.text('TAG NOT POWERED — OUT OF RANGE'), findsOneWidget);
    final readButton = tester.widget<ElevatedButton>(
      find.byKey(const Key('rfid_read_uid')),
    );
    expect(readButton.onPressed, isNull);
    expect(find.byKey(const Key('rfid_serial_output')), findsNothing);

    final retrySliderRect = tester.getRect(
      find.byKey(const Key('rfid_distance_slider')),
    );
    await tester.tapAt(
      Offset(
        retrySliderRect.left + retrySliderRect.width * 0.45,
        retrySliderRect.center.dy,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rfid_read_uid')));
    await tester.pump(const Duration(milliseconds: 1800));
    expect(find.text('UID (example): DE AD BE EF'), findsOneWidget);
  });

  testWidgets('in-range read animates the SPI stages and emits the demo UID', (
    tester,
  ) async {
    bool completed = false;
    await tester.pumpWidget(
      wrap(RfidCouplingSimulatorWidget(onComplete: () => completed = true)),
    );

    final semantics = tester.ensureSemantics();
    final slider = find.byKey(const Key('rfid_distance_slider'));
    expect(
        find.bySemanticsLabel(RegExp('Tag distance control')), findsOneWidget);
    semantics.dispose();
    final sliderRect = tester.getRect(slider);
    await tester.tapAt(
      Offset(sliderRect.left + sliderRect.width * 0.45, sliderRect.center.dy),
    );
    await tester.pumpAndSettle();

    expect(find.text('TAG POWERED — IN RANGE'), findsOneWidget);
    final readButton = tester.widget<ElevatedButton>(
      find.byKey(const Key('rfid_read_uid')),
    );
    expect(readButton.onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('rfid_read_uid')));
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.textContaining('Tag load modulation'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.textContaining('RC522 receives'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.textContaining('SPI transfer'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.byKey(const Key('rfid_serial_output')), findsOneWidget);
    expect(find.text('UID (example): DE AD BE EF'), findsOneWidget);
    expect(completed, isTrue);
  });

  testWidgets('reset restores out-of-range state and permits retry', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const RfidCouplingSimulatorWidget()));
    final sliderRect = tester.getRect(
      find.byKey(const Key('rfid_distance_slider')),
    );
    await tester.tapAt(
      Offset(sliderRect.left + sliderRect.width * 0.45, sliderRect.center.dy),
    );
    await tester.pumpAndSettle();
    expect(find.text('TAG POWERED — IN RANGE'), findsOneWidget);

    await tester.tap(find.byKey(const Key('rfid_reset')));
    await tester.pumpAndSettle();
    expect(find.text('TAG NOT POWERED — OUT OF RANGE'), findsOneWidget);
    expect(find.byKey(const Key('rfid_serial_output')), findsNothing);

    final retrySliderRect = tester.getRect(
      find.byKey(const Key('rfid_distance_slider')),
    );
    await tester.tapAt(
      Offset(
        retrySliderRect.left + retrySliderRect.width * 0.45,
        retrySliderRect.center.dy,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('rfid_read_uid')));
    await tester.pump(const Duration(milliseconds: 1800));
    expect(find.text('UID (example): DE AD BE EF'), findsOneWidget);
  });

  testWidgets(
      'exact 3.0 cm simulated threshold is in range and 3.5 cm is out of range', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const RfidCouplingSimulatorWidget()));

    // Initial state: default 5.0 cm is out of range
    expect(find.text('TAG NOT POWERED — OUT OF RANGE'), findsOneWidget);

    // Set slider to exact 3.0 cm boundary
    final sliderFinder = find.byKey(const Key('rfid_distance_slider'));
    final slider = tester.widget<Slider>(sliderFinder);
    slider.onChanged!(3.0);
    await tester.pumpAndSettle();

    expect(find.text('TAG POWERED — IN RANGE'), findsOneWidget);
    expect(find.text('Tag distance: 3.0 cm'), findsOneWidget);
    final readButtonAtBoundary = tester.widget<ElevatedButton>(
      find.byKey(const Key('rfid_read_uid')),
    );
    expect(readButtonAtBoundary.onPressed, isNotNull);

    // Move just beyond boundary to 3.5 cm
    slider.onChanged!(3.5);
    await tester.pumpAndSettle();

    expect(find.text('TAG NOT POWERED — OUT OF RANGE'), findsOneWidget);
    expect(find.text('Tag distance: 3.5 cm'), findsOneWidget);
    final readButtonBeyond = tester.widget<ElevatedButton>(
      find.byKey(const Key('rfid_read_uid')),
    );
    expect(readButtonBeyond.onPressed, isNull);
  });

  testWidgets(
      'displays correct SPI signal roles and qualified simulation threshold note', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const RfidCouplingSimulatorWidget()));

    expect(find.text('MOSI'), findsOneWidget);
    expect(find.text('Uno → RC522: command data'), findsOneWidget);
    expect(find.text('SCK'), findsOneWidget);
    expect(find.text('Uno → RC522: clock'), findsOneWidget);
    expect(find.text('CS'), findsOneWidget);
    expect(find.text('Uno → RC522: select reader'), findsOneWidget);
    expect(find.text('MISO'), findsOneWidget);
    expect(find.text('RC522 → Uno: returned UID bytes'), findsOneWidget);

    expect(
      find.textContaining('physical range varies with reader/tag antennas'),
      findsOneWidget,
    );
  });
}

class _BuildContextStub implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
