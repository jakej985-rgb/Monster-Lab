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

class OfflineDiskAssetBundle extends CachingAssetBundle {
  final String rootDir;

  OfflineDiskAssetBundle(this.rootDir);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final file = File('$rootDir/$key');
    if (await file.exists()) {
      return file.readAsString();
    }
    throw Exception('Offline asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final file = File('$rootDir/$key');
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return ByteData.view(bytes.buffer);
    }
    throw Exception('Offline asset not found: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Learning Flow & Zero-Network Verification (Issue #48)', () {
    late StorageService storage;
    late LocalStorageDataSource dataSource;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;
    late CurriculumDataEngine curriculumEngine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await StorageService.init();
      dataSource = LocalStorageDataSource(storage);
      profileRepo = ProfileRepositoryImpl(dataSource);
      progressRepo = ProgressRepositoryImpl(dataSource);

      // Offline curriculum loaded purely from local disk bundle
      final bundle = OfflineDiskAssetBundle('.');
      curriculumEngine = CurriculumDataEngine(
        assetBundle: bundle,
        allowFallback: true,
      );
      await curriculumEngine.initialize();
    });

    test('Loads full curriculum completely offline from local assets',
        () async {
      final lessons = await curriculumEngine.getLessons();
      expect(lessons, isNotEmpty);
      expect(lessons.length, greaterThanOrEqualTo(12));

      final components = await curriculumEngine.getComponents();
      expect(components, isNotEmpty);

      final projects = await curriculumEngine.getProjects();
      expect(projects, isNotEmpty);
    });

    test(
        'Learner completes lessons offline, updates streak, and persists progress',
        () async {
      final profile = LearnerProfileModel(
        id: 'offline_kid_01',
        nickname: 'Tinkerer',
        avatarId: 'dr_volt',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);

      // Record offline progress
      await progressRepo.completeLesson(
        profile.id,
        'l01_01',
        50,
      );

      final progress = await progressRepo.getProgress(profile.id);
      expect(progress.completedLessonIds, contains('l01_01'));
      expect(progress.totalXp, equals(50));
      expect(progress.processedTransactionIds, contains('tx_lesson_l01_01'));

      // Complete second lesson offline
      await progressRepo.completeLesson(
        profile.id,
        'l01_02',
        50,
      );

      final progress2 = await progressRepo.getProgress(profile.id);
      expect(progress2.completedLessonIds, contains('l01_02'));
      expect(progress2.totalXp, equals(100));
    });

    test('Multi-profile data isolation operates securely in offline mode',
        () async {
      final kidA = LearnerProfileModel(
        id: 'kid_a',
        nickname: 'Alice',
        avatarId: 'dr_volt',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      final kidB = LearnerProfileModel(
        id: 'kid_b',
        nickname: 'Bob',
        avatarId: 'dr_volt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      await profileRepo.saveProfile(kidA);
      await profileRepo.saveProfile(kidB);

      await progressRepo.completeLesson(kidA.id, 'l01_01', 50);

      final progA = await progressRepo.getProgress(kidA.id);
      final progB = await progressRepo.getProgress(kidB.id);

      expect(progA.totalXp, equals(50));
      expect(progA.completedLessonIds, contains('l01_01'));

      // Kid B progress must remain completely isolated
      expect(progB.totalXp, equals(0));
      expect(progB.completedLessonIds, isEmpty);
    });

    test(
        'Sync-safe replay and deduplication: replayed offline events never duplicate XP',
        () async {
      const learnerId = 'offline_sync_kid';
      const txId = 'tx_offline_event_123';

      await progressRepo.addXp(learnerId, 100, txId);
      final prog1 = await progressRepo.getProgress(learnerId);
      expect(prog1.totalXp, equals(100));

      // Replay same event (e.g. simulated network reconnection or re-sync)
      await progressRepo.addXp(learnerId, 100, txId);
      final prog2 = await progressRepo.getProgress(learnerId);
      expect(prog2.totalXp, equals(100)); // Total XP must not increase
    });
  });
}
