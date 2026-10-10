import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/presentation/features/learn/learn_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

import 'package:go_router/go_router.dart';

void main() {
  group('LearnScreen Course Folders & Sub-Lesson Prerequisite Tests', () {
    late CurriculumDataEngine engine;

    setUp(() async {
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createTestWidget({required StorageService storageService}) {
      final router = GoRouter(
        initialLocation: '/learn',
        routes: [
          GoRoute(
            path: '/learn',
            builder: (context, state) => const LearnScreen(),
          ),
          GoRoute(
            path: '/learn/:lessonId',
            builder: (context, state) => Scaffold(
              body: Text('Lesson Detail: ${state.pathParameters['lessonId']}'),
            ),
          ),
        ],
      );

      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumDataEngineProvider.overrideWithValue(engine),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      );
    }

    testWidgets('Renders all 14 course folders', (tester) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(createTestWidget(storageService: storageService));
      await tester.pumpAndSettle();

      // Check course titles
      expect(find.text('Lesson 1 — Arduino Fundamentals'), findsOneWidget);
      expect(find.text('Coding Foundations'), findsOneWidget);
      expect(find.text('Lesson 2A — Meet Monster Lab'), findsOneWidget);
      expect(find.text('Lesson 2B — Arduino IDE Walkthrough'), findsOneWidget);
      expect(find.text('Lesson 3 — Circuits, Breadboards & First Builds'),
          findsOneWidget);
      expect(find.text('Lesson 4 — PWM & RGB LEDs: Colors and Brightness'),
          findsOneWidget);
      expect(find.text('Lesson 5 — Switches, Buttons & Potentiometers'),
          findsOneWidget);
      expect(find.text('Lesson 6 — Sensors & Reading the Real World'),
          findsOneWidget);
      expect(find.text('Lesson 7 — Libraries: Power Up Your Code'),
          findsOneWidget);
      expect(find.text('Lesson 8 — I2C & Connected Devices'), findsOneWidget);
      expect(
          find.text(
              'Lesson 9 (Advanced) — Multi-Device I2C Architectures & Real-Time Clocks'),
          findsOneWidget);
      expect(
          find.text(
              'Lesson 10 — High-Speed SPI Protocol & Peripheral Displays'),
          findsOneWidget);
      expect(find.text('Lesson 11 — Serial UART & Wireless Telemetry'),
          findsOneWidget);
      expect(find.text('Lesson 12 — Motors, H-Bridges & Inductive Physics'),
          findsOneWidget);
    });

    testWidgets(
        'Sub-lesson l2a_01 is unlocked when course lesson_01 is completed in completedCourseIds',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Completed course lesson_01 without legacy lesson_01 in completedLessonIds
      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
        'monster_lab_progress_prof_1':
            '{"learnerId":"prof_1","totalXp":225,"completedLessonIds":["l01_01","l01_02","l01_03","l01_04","l01_05","l01_06","l01_07","l01_08","l01_09","l01_10","l01_11","l01_12"],"completedCourseIds":["lesson_01"],"completedProjectIds":[],"discoveredComponentIds":[],"solvedChallengeIds":[],"unlockedBadgeIds":[],"stepProgress":{},"lastSessionDate":"2026-01-01T00:00:00.000Z"}',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(createTestWidget(storageService: storageService));
      await tester.pumpAndSettle();

      // Expand Lesson 2A folder
      final folder2AHeader = find.byKey(const Key('folder_header_lesson_2a'));
      expect(folder2AHeader, findsOneWidget);
      await tester.ensureVisible(folder2AHeader);
      await tester.tap(folder2AHeader);
      await tester.pumpAndSettle();

      // l2a_01 should be rendered and unlocked (not locked with prerequisite alert)
      final l2a01Finder = find.text('What Is Monster Lab?');
      expect(l2a01Finder, findsOneWidget);
      await tester.ensureVisible(l2a01Finder);
      await tester.tap(l2a01Finder);
      await tester.pumpAndSettle();

      // Successfully navigated to detail screen of l2a_01
      expect(find.text('Lesson Detail: l2a_01'), findsOneWidget);
    });

    testWidgets(
        'Sub-lesson l2a_01 shows locked prerequisite SnackBar when lesson_01 course is NOT completed',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Fresh user with no completed lessons
      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(createTestWidget(storageService: storageService));
      await tester.pumpAndSettle();

      // Expand Lesson 2A folder
      final folder2AHeader = find.byKey(const Key('folder_header_lesson_2a'));
      expect(folder2AHeader, findsOneWidget);
      await tester.ensureVisible(folder2AHeader);
      await tester.tap(folder2AHeader);
      await tester.pumpAndSettle();

      // Tap l2a_01 which has unmet prerequisite 'lesson_01'
      final l2a01Finder = find.text('What Is Monster Lab?');
      expect(l2a01Finder, findsOneWidget);
      await tester.ensureVisible(l2a01Finder);
      await tester.tap(l2a01Finder);
      await tester.pump();

      // Should show prerequisite SnackBar
      expect(find.text('Complete prerequisite (lesson_01) first!'),
          findsOneWidget);
    });
  });
}
