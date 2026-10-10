import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';

class LocalDiskAssetBundle extends CachingAssetBundle {
  final String basePath;
  LocalDiskAssetBundle([this.basePath = '.']);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final file = File('$basePath/$key');
    if (await file.exists()) {
      return file.readAsString();
    }
    throw Exception('Asset not found: $key (tried $basePath/$key)');
  }

  @override
  Future<ByteData> load(String key) async {
    final file = File('$basePath/$key');
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return ByteData.view(bytes.buffer);
    }
    throw Exception('Asset not found: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageDataSource Resilience & Corruption Recovery', () {
    test('Recovers gracefully when profile JSON is malformed or corrupted',
        () async {
      SharedPreferences.setMockInitialValues({
        'monster_lab_profiles': '{"not": "a list", corrupted_json!}',
      });

      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);

      // Must not throw, and should return safe default empty list
      final profiles = dataSource.getProfiles();
      expect(profiles, isEmpty);
    });

    test('Recovers gracefully when progress JSON is malformed or truncated',
        () async {
      SharedPreferences.setMockInitialValues({
        'monster_lab_progress_learner_1': '{invalid json {{{{',
      });

      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);

      final progress = dataSource.getProgress('learner_1');
      expect(progress.learnerId, equals('learner_1'));
      expect(progress.totalXp, equals(0));
      expect(progress.completedLessonIds, isEmpty);
    });

    test(
        'Recovers gracefully when progress JSON contains unexpected schema types',
        () async {
      SharedPreferences.setMockInitialValues({
        'monster_lab_progress_learner_2': '{"totalXp": "not an int"}',
      });

      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);

      final progress = dataSource.getProgress('learner_2');
      expect(progress.learnerId, equals('learner_2'));
      expect(progress.totalXp, equals(0));
    });

    test('Handles missing keys by returning empty states without errors',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);

      expect(dataSource.getProfiles(), isEmpty);
      expect(dataSource.getActiveProfileId(), isNull);

      final progress = dataSource.getProgress('non_existent');
      expect(progress.totalXp, equals(0));
      expect(progress.learnerId, equals('non_existent'));
    });
  });

  group('Multi-Learner Persistence Isolation & Concurrency', () {
    test('Rapid concurrent updates between profiles maintain strict isolation',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);
      final repo = ProgressRepositoryImpl(dataSource);

      const profileA = 'child_circuit_scout';
      const profileB = 'child_bot_builder';

      // Simulate rapid concurrent operations
      await Future.wait<void>([
        repo.addXp(profileA, 150),
        repo.addXp(profileB, 300),
        repo.completeLesson(profileA, 'lesson_01', 50),
        repo.solveChallenge(profileB, 'ch_01', 75),
        repo.completeProject(profileA, 'proj_01', 100, 'badge_first_wire'),
      ]);

      final progressA = await repo.getProgress(profileA);
      final progressB = await repo.getProgress(profileB);

      expect(progressA.totalXp, equals(300)); // 150 + 50 + 100
      expect(progressA.completedLessonIds, contains('lesson_01'));
      expect(progressA.completedProjectIds, contains('proj_01'));
      expect(progressA.earnedBadgeIds, contains('badge_first_wire'));
      expect(progressA.solvedChallengeIds, isNot(contains('ch_01')));

      expect(progressB.totalXp, equals(375)); // 300 + 75
      expect(progressB.solvedChallengeIds, contains('ch_01'));
      expect(progressB.completedLessonIds, isNot(contains('lesson_01')));
      expect(progressB.earnedBadgeIds, isNot(contains('badge_first_wire')));
    });
  });

  group('Offline-Only Behavior & Zero Network Loading', () {
    test(
        'Entire curriculum loads from bundled local assets with zero network access',
        () async {
      final diskBundle = LocalDiskAssetBundle();
      final engine = CurriculumDataEngine(assetBundle: diskBundle);
      await engine.initialize();

      final lessons = await engine.getLessons();
      final components = await engine.getComponents();
      final projects = await engine.getProjects();
      final challenges = await engine.getChallenges();
      final badges = await engine.getBadges();

      expect(lessons.length, equals(139));
      expect(components.length, equals(54));
      expect(projects.length, equals(20));
      expect(challenges.length, equals(24));
      expect(badges.length, equals(20));

      for (final lesson in lessons) {
        expect(lesson.id, isNotEmpty);
        expect(lesson.steps, isNotEmpty);
      }

      for (final comp in components) {
        expect(comp.id, isNotEmpty);
        expect(comp.pinout, isNotEmpty);
      }
    });
  });

  group('Profile Deletion & Active Profile State Cleanup', () {
    test('Deleting the sole active profile clears active profile ID in storage',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);
      final profileRepo = ProfileRepositoryImpl(dataSource);

      final profile = LearnerProfileModel(
        id: 'solo_profile',
        nickname: 'SoloBot',
        avatarId: 'monster_spark',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);

      expect(dataSource.getActiveProfileId(), equals('solo_profile'));
      expect((await profileRepo.getAllProfiles()).length, equals(1));

      // Now delete the sole profile
      await profileRepo.deleteProfile('solo_profile');

      expect((await profileRepo.getAllProfiles()), isEmpty);
      expect(dataSource.getActiveProfileId(), isNull);
      expect(await profileRepo.getActiveProfile(), isNull);
    });
  });
}
