import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';

class LocalDiskAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final file = File(key);
    if (!file.existsSync()) {
      throw Exception('Asset file not found on local disk: $key');
    }
    return file.readAsString();
  }

  @override
  Future<ByteData> load(String key) async {
    final file = File(key);
    if (!file.existsSync()) {
      throw Exception('Asset file not found on local disk: $key');
    }
    final bytes = await file.readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}

void main() {
  group('Placement Logic Integration Tests', () {
    late CurriculumDataEngine engine;
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
      engine = CurriculumDataEngine(assetBundle: LocalDiskAssetBundle());
      await engine.initialize();
    });

    test('When placement is passed, optional Coding Foundations lessons are bypassed', () async {
      const learnerId = 'learner_skip_cf';

      // 1. Complete Lesson 1
      await progressRepo.completeLesson(learnerId, 'lesson_01', 50);

      // 2. Mark Coding Foundations placement as passed
      await progressRepo.markPlacementPassed(learnerId, 'coding_foundations');

      final progress = await progressRepo.getProgress(learnerId);
      final repo = CurriculumRepositoryImpl(engine);
      final orderedLessons = await repo.getLessonsOrdered();

      // Find next uncompleted lesson, bypassing optional course if placement is passed
      String? nextLessonId;
      for (final lesson in orderedLessons) {
        if (progress.completedLessonIds.contains(lesson.id)) continue;
        if (lesson.isOptional &&
            lesson.courseId != null &&
            progress.placementPassedCourseIds.contains(lesson.courseId)) {
          continue;
        }

        final missingPrereqs = lesson.prerequisites.where(
          (req) => !progress.completedLessonIds.contains(req),
        );
        if (missingPrereqs.isEmpty) {
          nextLessonId = lesson.id;
          break;
        }
      }

      // Next lesson should be l2a_01 (Lesson 2A) rather than cf_01
      expect(nextLessonId, equals('l2a_01'));
    });
  });
}
