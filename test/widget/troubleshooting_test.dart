import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/project_model.dart';
import 'package:monster_lab/presentation/features/build/widgets/troubleshooting_sheet.dart';
import 'package:monster_lab/presentation/features/troubleshoot/troubleshooting_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Phase 11: Troubleshooting Lab & Doctor Monster Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();

      final localDataSource = LocalStorageDataSource(storageService);
      profileRepo = ProfileRepositoryImpl(localDataSource);
      progressRepo = ProgressRepositoryImpl(localDataSource);
    });

    Widget createTestWidget(Widget child,
        [List<Override> extraOverrides = const []]) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          profileRepositoryProvider.overrideWithValue(profileRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          ...extraOverrides,
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets(
        'TroubleshootingScreen renders all 3 tabs and root triage station',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const TroubleshootingScreen()));
      await tester.pumpAndSettle();

      // Title
      expect(find.text('Doctor Monster Clinic'), findsOneWidget);

      // Tabs
      expect(find.text('Diagnostic Wizard'), findsOneWidget);
      expect(find.text('Debugging Method'), findsOneWidget);
      expect(find.text('Failure Playbooks'), findsOneWidget);

      // Wizard root options
      expect(find.text('Triage Station'), findsOneWidget);
      expect(find.text('Power & Board Dead'), findsOneWidget);
      expect(find.text('Breadboard & Wiring'), findsOneWidget);
      expect(find.text('Arduino IDE Compile Error'), findsOneWidget);
      expect(find.text('Upload & Port Failure'), findsOneWidget);
      expect(find.text('Sensor & Logic Glitches'), findsOneWidget);
    });

    testWidgets(
        'Diagnostic Wizard branches to prescription and resets correctly',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const TroubleshootingScreen()));
      await tester.pumpAndSettle();

      // Tap Power & Board Dead
      await tester.tap(find.text('Power & Board Dead'));
      await tester.pumpAndSettle();

      expect(find.text('Power Inspection'), findsOneWidget);
      expect(find.textContaining('Is the small green LED labeled "ON" lit'),
          findsOneWidget);

      // Tap "No, the green ON LED is completely dark"
      await tester.tap(find.text('No, the green ON LED is completely dark'));
      await tester.pumpAndSettle();

      expect(find.text('USB Power Check'), findsOneWidget);

      // Tap "The green ON LED turns on now!"
      await tester.tap(find.text('The green ON LED turns on now!'));
      await tester.pumpAndSettle();

      // Result prescription displayed
      expect(find.text('DIAGNOSIS FOUND'), findsOneWidget);
      expect(find.text('Breadboard Short Circuit'), findsOneWidget);
      expect(
          find.textContaining(
              'There is a short circuit somewhere on your breadboard'),
          findsOneWidget);
      expect(find.text('VERIFICATION TEST'), findsOneWidget);

      // Tap a fix step to toggle check
      await tester
          .tap(find.textContaining('Keep USB plugged in to Arduino only'));
      await tester.pumpAndSettle();

      // Tap New Diagnosis button
      final resetButton = find.byKey(const Key('reset_wizard_button'));
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Back to root
      expect(find.text('Triage Station'), findsOneWidget);
      expect(find.text('Power & Board Dead'), findsOneWidget);
    });

    testWidgets('Diagnostic Method tab explains 4 engineering debugging steps',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const TroubleshootingScreen()));
      await tester.pumpAndSettle();

      // Switch to Debugging Method tab
      await tester.tap(find.text('Debugging Method'));
      await tester.pumpAndSettle();

      expect(find.text('The Monster Diagnostic Method'), findsOneWidget);
      expect(find.text('OBSERVE WITHOUT GUESSING'), findsOneWidget);
      expect(find.text('ISOLATE THE DOMAIN'), findsOneWidget);
      expect(find.text('TEST ONE HYPOTHESIS AT A TIME'), findsOneWidget);
      expect(find.text('FIX, VERIFY & REFLECT'), findsOneWidget);
      expect(
          find.textContaining(
              'Change only ONE wire or ONE line of code at a time'),
          findsOneWidget);
    });

    testWidgets(
        'Failure Playbooks tab filters categories and displays kid rules',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const TroubleshootingScreen()));
      await tester.pumpAndSettle();

      // Switch to Failure Playbooks tab
      await tester.tap(find.text('Failure Playbooks'));
      await tester.pumpAndSettle();

      expect(find.text('All Domains'), findsOneWidget);
      expect(find.text('Power & Shorts'), findsOneWidget);
      expect(find.text('Power Failures & Short Circuit Protection'),
          findsOneWidget);

      // Expand first playbook
      await tester.tap(find.text('Power Failures & Short Circuit Protection'));
      await tester.pumpAndSettle();

      expect(
          find.textContaining(
              'Kid Rule: Never let Red (+) and Blue/Black (-) touch'),
          findsOneWidget);
      expect(find.text('Diagnostic Checklist:'), findsOneWidget);

      // Filter by Upload Issues
      await tester.tap(find.text('Upload Issues'));
      await tester.pumpAndSettle();

      expect(
          find.text('Power Failures & Short Circuit Protection'), findsNothing);
      expect(
          find.text('Upload Timeouts & Serial Port Conflicts'), findsOneWidget);
    });

    testWidgets(
        'TroubleshootingSheet in Build Lab displays category badge and diagnostic steps',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const items = [
        TroubleshootingItem(
          symptom: 'Distance always reads 0 or 3000 cm',
          cause: 'TRIG and ECHO pins are swapped',
          solution: 'Swap pins 9 and 10 on your breadboard or verify wires.',
          category: 'logic',
          diagnosticSteps: [
            'Check TRIG on Pin 9 and ECHO on Pin 10.',
            'Ensure VCC is connected to 5V (not 3.3V).'
          ],
        ),
      ];

      await tester.pumpWidget(createTestWidget(
        const Scaffold(
          body: TroubleshootingSheet(items: items),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Troubleshooting & Diagnostics'), findsOneWidget);
      expect(find.text('Need general help? Open Doctor Monster Clinic'),
          findsOneWidget);
      expect(find.text('LOGIC'), findsOneWidget);
      expect(find.text('Distance always reads 0 or 3000 cm'), findsOneWidget);
      expect(
          find.text('Cause: TRIG and ECHO pins are swapped'), findsOneWidget);
      expect(find.text('Diagnostic Steps:'), findsOneWidget);
      expect(
          find.text('Check TRIG on Pin 9 and ECHO on Pin 10.'), findsOneWidget);

      // Tap checklist step
      await tester.tap(find.text('Check TRIG on Pin 9 and ECHO on Pin 10.'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });
  });
}
