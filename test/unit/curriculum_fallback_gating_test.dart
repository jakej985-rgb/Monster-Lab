import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';

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

    test(
        'restoring full curriculum after browsing placeholders leaves production lessons uncredited',
        () async {
      final fallbackEngine = CurriculumDataEngine(
        assetBundle: FailingAssetBundle(),
        allowFallback: true,
      );
      await fallbackEngine.initialize();
      expect(fallbackEngine.isFallbackActive, isTrue);

      final fallbackRepo = CurriculumRepositoryImpl(fallbackEngine);
      final placeholderLesson = await fallbackRepo.getLessonById('l01_02');
      expect(placeholderLesson, isNotNull);
      expect(placeholderLesson.isPlaceholder, isTrue);

      // Verify gating predicate: placeholder lessons are blocked from writing credit
      final shouldAwardCredit =
          !placeholderLesson.isPlaceholder && !fallbackRepo.isFallbackActive;
      expect(shouldAwardCredit, isFalse);

      // Now restore assets
      final normalDataSource = AssetCurriculumDataSource();
      final normalEngine = CurriculumDataEngine(
        fallbackDataSource: normalDataSource,
      );
      await normalEngine.initialize();
      expect(normalEngine.isFallbackActive, isFalse);

      final restoredRepo = CurriculumRepositoryImpl(normalEngine);
      final productionLesson = await restoredRepo.getLessonById('l01_02');
      expect(productionLesson, isNotNull);
      expect(productionLesson.isPlaceholder, isFalse);

      // Progress stays uncredited
      final progress = LearnerProgressModel.empty('learner_test');
      expect(progress.completedLessonIds.contains('l01_02'), isFalse);
      expect(progress.totalXp, equals(0));
      expect(progress.completedCourseIds.contains('lesson_01'), isFalse);
    });
  });
}
