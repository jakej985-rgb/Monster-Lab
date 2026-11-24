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

      // Mount LessonDetailScreen on placeholder fallback lesson
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider.overrideWithValue(fallbackRepo),
            profileRepositoryProvider.overrideWithValue(profileRepo),
            progressRepositoryProvider.overrideWithValue(progressRepo),
          ],
          child: const MaterialApp(
            home: LessonDetailScreen(lessonId: 'l01_01'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Complete Lesson on the single-step fallback notice
      final completeButton = find.text('Complete Lesson (+0 XP)');
      expect(completeButton, findsOneWidget);
      await tester.ensureVisible(completeButton);
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // Verify that the fallback completion dialog path was explicitly reached
      expect(find.text('Fallback Notice'), findsOneWidget);
      expect(
        find.text('FALLBACK NOTICE (No XP or credit recorded)'),
        findsOneWidget,
      );
      await tester.tap(find.text('Back to Learn Lab'));
      await tester.pumpAndSettle();

      // Verify progress persisted in repository remained untouched (0 XP, uncompleted)
      final intermediateProgress = await progressRepo.getProgress(profile.id);
      expect(intermediateProgress.completedLessonIds, isEmpty);
      expect(intermediateProgress.totalXp, equals(0));

      // Now restore assets
      final normalDataSource = AssetCurriculumDataSource();
      final normalEngine = CurriculumDataEngine(
        fallbackDataSource: normalDataSource,
      );
      await normalEngine.initialize();
      expect(normalEngine.isFallbackActive, isFalse);

      final restoredRepo = CurriculumRepositoryImpl(normalEngine);
      final productionLesson = await restoredRepo.getLessonById('l01_01');
      expect(productionLesson, isNotNull);
      expect(productionLesson.isPlaceholder, isFalse);

      // Reload saved progress from persistent storage to verify it remained untouched
      final reloadedProgress = await progressRepo.getProgress(profile.id);
      expect(reloadedProgress.completedLessonIds.contains('l01_01'), isFalse);
      expect(reloadedProgress.totalXp, equals(0));
      expect(
          reloadedProgress.completedCourseIds.contains('lesson_01'), isFalse);

      // Verify completing restored production lesson awards authoritative credit
      await progressRepo.completeLesson(
        profile.id,
        productionLesson.id,
        productionLesson.xpReward,
      );
      final creditedProgress = await progressRepo.getProgress(profile.id);
      expect(creditedProgress.completedLessonIds, contains('l01_01'));
      expect(creditedProgress.totalXp, equals(productionLesson.xpReward));
    });
  });
}
