import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/presentation/features/learn/learn_screen.dart';
import 'package:monster_lab/presentation/features/learn/lesson_detail_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FailingAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    throw Exception('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    throw Exception('Asset not found: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Curriculum Fallback & Progress Gating Test Suite', () {
    test(
        'Baseline lessons from AssetCurriculumDataSource have isPlaceholder set to true',
        () {
      final baseline = AssetCurriculumDataSource().getBaselineLessons();
      expect(baseline, isNotEmpty);
      for (final lesson in baseline) {
        expect(lesson.isPlaceholder, isTrue,
            reason: 'Lesson ${lesson.id} should be marked as placeholder');
      }
    });

    test('Baseline fallback lessons have no prerequisites so all are reachable',
        () {
      final baseline = AssetCurriculumDataSource().getBaselineLessons();
      expect(baseline.length, greaterThan(1));
      for (final lesson in baseline) {
        expect(lesson.prerequisites, isEmpty,
            reason: 'Fallback ${lesson.id} must not be gated');
      }
    });

    testWidgets(
        'later fallback notice is unlocked and opens with no completed lessons',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(dataSource);
      final progressRepo = ProgressRepositoryImpl(dataSource);

      final profile = LearnerProfileModel(
        id: 'learner_nav',
        nickname: 'Navigator',
        avatarId: 'avatar_default',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);
      final emptyProgress = LearnerProgressModel.empty(profile.id);
      await progressRepo.saveProgress(emptyProgress);

      final engine = CurriculumDataEngine(
        assetBundle: FailingAssetBundle(),
        allowFallback: true,
      );
      await engine.initialize();
      final repo = CurriculumRepositoryImpl(engine);
      final lessons = await repo.getLessons();
      expect(lessons.length, greaterThan(1));

      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Real Learn Lab card navigation: the card itself decides lock state.
      final router = GoRouter(
        initialLocation: '/learn',
        routes: [
          GoRoute(
            path: '/learn',
            builder: (_, __) => const LearnScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    LessonDetailScreen(lessonId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider.overrideWithValue(repo),
            profileRepositoryProvider.overrideWithValue(profileRepo),
            progressRepositoryProvider.overrideWithValue(progressRepo),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // The first incomplete course folder auto-expands; tap a later notice.
      final laterCard = find.text(lessons[1].title);
      expect(laterCard, findsOneWidget);
      await tester.ensureVisible(laterCard);
      await tester.tap(laterCard);
      await tester.pumpAndSettle();

      expect(find.textContaining('Complete prerequisite'), findsNothing);
      expect(find.byType(LessonDetailScreen), findsOneWidget);
      final openedScreen =
          tester.widget<LessonDetailScreen>(find.byType(LessonDetailScreen));
      expect(openedScreen.lessonId, equals(lessons[1].id));
      expect(find.text(lessons[1].title), findsWidgets);
      expect(find.text('Complete Lesson (+0 XP)'), findsOneWidget);
    });

    test('Lesson.fromJson parses isPlaceholder correctly and defaults to false',
        () {
      final normalJson = {
        'id': 'l01_01',
        'title': 'Normal Lesson',
        'summary': 'Summary',
        'tier': 'rookie',
        'estimatedMinutes': 10,
        'prerequisites': <String>[],
        'componentIds': <String>[],
        'steps': [
          {
            'stepId': 'step_1',
            'title': 'Step 1',
            'type': 'story',
            'markdownContent': 'Read this carefully',
          }
        ],
        'xpReward': 20,
      };

      final normalLesson = Lesson.fromJson(normalJson);
      expect(normalLesson.isPlaceholder, isFalse);

      final placeholderJson = Map<String, dynamic>.from(normalJson)
        ..['isPlaceholder'] = true;
      final placeholderLesson = Lesson.fromJson(placeholderJson);
      expect(placeholderLesson.isPlaceholder, isTrue);
    });

    test(
        'CurriculumDataEngine fallback sets isFallbackActive and flags lessons as placeholders',
        () async {
      final engine = CurriculumDataEngine(
        assetBundle: FailingAssetBundle(),
        allowFallback: true,
      );
      // Failing bundle triggers fallback to baseline
      await engine.initialize();
      expect(engine.isFallbackActive, isTrue);

      final repo = CurriculumRepositoryImpl(engine);
      expect(repo.isFallbackActive, isTrue);

      final lessons = await repo.getLessons();
      expect(lessons, isNotEmpty);
      expect(lessons.every((Lesson l) => l.isPlaceholder), isTrue);
    });

    test(
        'LearnerProgressModel.replayFromEvents preserves baseSnapshot progress',
        () {
      const learnerId = 'learner_42';
      final base = LearnerProgressModel.empty(learnerId).copyWith(
        totalXp: 150,
        completedLessonIds: {'l01_01', 'l01_02'},
        completedCourseIds: {'course_01'},
      );

      final newEvents = [
        LearnerProgressEvent(
          eventId: 'evt_1',
          learnerId: learnerId,
          eventType: ProgressEventType.lessonCompleted,
          activityId: 'l01_03',
          timestamp: DateTime.now(),
          xpAwarded: 50,
        ),
      ];

      final replayed = LearnerProgressModel.replayFromEvents(
        learnerId,
        newEvents,
        baseSnapshot: base,
      );

      expect(replayed.totalXp, equals(200));
      expect(replayed.completedLessonIds,
          containsAll(['l01_01', 'l01_02', 'l01_03']));
      expect(replayed.completedCourseIds, contains('course_01'));
      expect(replayed.processedTransactionIds, contains('evt_1'));
    });

    testWidgets(
        'restoring full curriculum after browsing placeholders leaves production lessons uncredited',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(dataSource);
      final progressRepo = ProgressRepositoryImpl(dataSource);

      final profile = LearnerProfileModel(
        id: 'learner_test',
        nickname: 'Explorer',
        avatarId: 'avatar_default',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);
      await progressRepo.saveProgress(LearnerProgressModel.empty(profile.id));

      final fallbackEngine = CurriculumDataEngine(
        assetBundle: FailingAssetBundle(),
        allowFallback: true,
      );
      await fallbackEngine.initialize();
      expect(fallbackEngine.isFallbackActive, isTrue);

      final fallbackRepo = CurriculumRepositoryImpl(fallbackEngine);

      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Real Learn Lab card navigation: the card itself evaluates lock state.
      final router = GoRouter(
        initialLocation: '/learn',
        routes: [
          GoRoute(
            path: '/learn',
            builder: (_, __) => const LearnScreen(),
            routes: [
              GoRoute(
                path: ':lessonId',
                builder: (_, state) => LessonDetailScreen(
                  lessonId: state.pathParameters['lessonId']!,
                ),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider.overrideWithValue(fallbackRepo),
            profileRepositoryProvider.overrideWithValue(profileRepo),
            progressRepositoryProvider.overrideWithValue(progressRepo),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Browse and inspect the first placeholder notice
      final firstNoticeFinder = find.text('What Is Arduino?');
      expect(firstNoticeFinder, findsOneWidget);
      await tester.ensureVisible(firstNoticeFinder);
      await tester.tap(firstNoticeFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LessonDetailScreen), findsOneWidget);
      final firstScreen =
          tester.widget<LessonDetailScreen>(find.byType(LessonDetailScreen));
      expect(firstScreen.lessonId, equals('l01_01'));
      expect(find.text('What Is Arduino?'), findsWidgets);
      expect(find.textContaining('This is a compact offline fallback lesson'),
          findsOneWidget);

      final firstCompleteButton = find.text('Complete Lesson (+0 XP)');
      expect(firstCompleteButton, findsOneWidget);
      await tester.ensureVisible(firstCompleteButton);
      await tester.tap(firstCompleteButton);
      await tester.pumpAndSettle();

      expect(find.text('Fallback Notice'), findsOneWidget);
      expect(
        find.text(
            'Browsed fallback placeholder "What Is Arduino?". Production curriculum is loading.'),
        findsOneWidget,
      );
      expect(
        find.text('FALLBACK NOTICE (No XP or credit recorded)'),
        findsOneWidget,
      );
      await tester.tap(find.text('Back to Learn Lab'));
      await tester.pumpAndSettle();
      expect(find.byType(LessonDetailScreen), findsNothing);

      // 2. Browse to the second placeholder notice
      final secondNoticeFinder = find.text('Your First Circuit');
      expect(secondNoticeFinder, findsOneWidget);
      await tester.ensureVisible(secondNoticeFinder);
      await tester.tap(secondNoticeFinder);
      await tester.pumpAndSettle();

      // Verify destination is specifically the second notice and not misrouted to the first
      expect(find.byType(LessonDetailScreen), findsOneWidget);
      final secondScreen =
          tester.widget<LessonDetailScreen>(find.byType(LessonDetailScreen));
      expect(secondScreen.lessonId, equals('l01_02'));
      expect(find.text('Your First Circuit'), findsWidgets);
      expect(find.textContaining('This is a compact offline fallback lesson'),
          findsOneWidget);

      // Verify completion button on second notice and tap
      final secondCompleteButton = find.text('Complete Lesson (+0 XP)');
      expect(secondCompleteButton, findsOneWidget);
      await tester.ensureVisible(secondCompleteButton);
      await tester.tap(secondCompleteButton);
      await tester.pumpAndSettle();

      expect(find.text('Fallback Notice'), findsOneWidget);
      expect(
        find.text(
            'Browsed fallback placeholder "Your First Circuit". Production curriculum is loading.'),
        findsOneWidget,
      );
      expect(
        find.text('FALLBACK NOTICE (No XP or credit recorded)'),
        findsOneWidget,
      );
      await tester.tap(find.text('Back to Learn Lab'));
      await tester.pumpAndSettle();
      expect(find.byType(LessonDetailScreen), findsNothing);

      // Verify progress persisted in repository remained untouched (0 XP, uncompleted)
      final intermediateProgress = await progressRepo.getProgress(profile.id);
      expect(intermediateProgress.completedLessonIds, isEmpty);
      expect(intermediateProgress.totalXp, equals(0));

      // 3. Now restore full curriculum assets
      final normalDataSource = AssetCurriculumDataSource();
      final normalEngine = CurriculumDataEngine(
        fallbackDataSource: normalDataSource,
      );
      await normalEngine.initialize();
      expect(normalEngine.isFallbackActive, isFalse);

      final restoredRepo = CurriculumRepositoryImpl(normalEngine);
      final productionLesson1 = await restoredRepo.getLessonById('l01_01');
      final productionLesson2 = await restoredRepo.getLessonById('l01_02');
      expect(productionLesson1, isNotNull);
      expect(productionLesson2, isNotNull);
      expect(productionLesson1.isPlaceholder, isFalse);
      expect(productionLesson2.isPlaceholder, isFalse);
      expect(productionLesson2.prerequisites, contains(productionLesson1.id));

      // Reload saved progress from persistent storage to verify it remained untouched
      final reloadedProgress = await progressRepo.getProgress(profile.id);
      expect(reloadedProgress.completedLessonIds.contains('l01_01'), isFalse);
      expect(reloadedProgress.completedLessonIds.contains('l01_02'), isFalse);
      expect(reloadedProgress.totalXp, equals(0));
      expect(
          reloadedProgress.completedCourseIds.contains('lesson_01'), isFalse);

      // Re-render Learn Lab with restored production curriculum
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider.overrideWithValue(restoredRepo),
            profileRepositoryProvider.overrideWithValue(profileRepo),
            progressRepositoryProvider.overrideWithValue(progressRepo),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 4. Verify prerequisite gating blocks opening the restored second lesson
      final lockedCard = find.text(productionLesson2.title);
      expect(lockedCard, findsOneWidget);
      await tester.ensureVisible(lockedCard);
      await tester.tap(lockedCard);
      await tester.pumpAndSettle();

      expect(
        find.text('Complete prerequisite (${productionLesson1.id}) first!'),
        findsOneWidget,
      );
      expect(find.byType(LessonDetailScreen), findsNothing);

      // 5. Complete prerequisite lesson 1 to unlock lesson 2
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      await container.read(activeProgressProvider.notifier).completeLesson(
            productionLesson1.id,
            productionLesson1.xpReward,
          );
      await tester.pumpAndSettle();

      final unlockedProgress = await progressRepo.getProgress(profile.id);
      expect(
          unlockedProgress.completedLessonIds, contains(productionLesson1.id));
      expect(
        unlockedProgress.completedLessonIds
            .containsAll(productionLesson2.prerequisites),
        isTrue,
      );

      // 6. Now tap the unlocked second lesson; navigation succeeds
      await tester.tap(lockedCard);
      await tester.pumpAndSettle();

      expect(find.byType(LessonDetailScreen), findsOneWidget);
      final restoredDetail =
          tester.widget<LessonDetailScreen>(find.byType(LessonDetailScreen));
      expect(restoredDetail.lessonId, equals(productionLesson2.id));
      expect(find.text(productionLesson2.title), findsWidgets);

      // Complete production lesson 2 and verify authoritative credit for both
      await container.read(activeProgressProvider.notifier).completeLesson(
            productionLesson2.id,
            productionLesson2.xpReward,
          );
      await tester.pumpAndSettle();
      final finalProgress = await progressRepo.getProgress(profile.id);
      expect(
        finalProgress.completedLessonIds,
        containsAll([productionLesson1.id, productionLesson2.id]),
      );
      expect(
        finalProgress.totalXp,
        equals(productionLesson1.xpReward + productionLesson2.xpReward),
      );
    });
  });
}
