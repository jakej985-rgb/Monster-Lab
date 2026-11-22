import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/routing/app_router.dart';
import 'package:monster_lab/core/routing/route_constants.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

LearnerProfileModel _createProfile(
  String id,
  String nickname, {
  String avatarId = 'avatar_robot',
}) {
  final now = DateTime.now();
  return LearnerProfileModel(
    id: id,
    nickname: nickname,
    avatarId: avatarId,
    ageBracket: AgeBracket.ages10_12,
    createdAt: now,
    lastActiveAt: now,
  );
}

Future<(StorageService, LocalStorageDataSource)> _initDataSource(
  Map<String, Object> values,
) async {
  SharedPreferences.setMockInitialValues(values);
  final storageService = await StorageService.init();
  return (storageService, LocalStorageDataSource(storageService));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Learner Profile Backup Snapshot Recovery Suite', () {
    test(
        'cold start with missing primary key restores profile from backup snapshot without onboarding',
        () async {
      final backupProfile = _createProfile('learner_ava', 'Ava');
      final snapshotJson = jsonEncode([backupProfile.toJson()]);

      final (storageService, dataSource) = await _initDataSource({
        'monster_lab_active_profile_id': 'learner_ava',
        'monster_lab_profiles_backup': snapshotJson,
      });
      final profileRepo = ProfileRepositoryImpl(dataSource);

      // Verify getProfiles restores from backup snapshot
      final profiles = dataSource.getProfiles();
      expect(profiles.length, 1);
      expect(profiles.first.id, 'learner_ava');
      expect(profiles.first.nickname, 'Ava');

      // Verify primary slot was auto-repaired
      final repairedRaw = storageService.getString('monster_lab_profiles');
      expect(repairedRaw, isNotNull);
      expect(repairedRaw, contains('learner_ava'));

      // Verify active profile resolution
      final active = await profileRepo.getActiveProfile();
      expect(active, isNotNull);
      expect(active?.id, 'learner_ava');
      expect(active?.nickname, 'Ava');

      // Verify route authorization does not force learner into onboarding
      final guardRedirect = routeAuthorizationGuard(
        location: RoutePaths.home,
        hasActiveProfile: true,
        sessionService: defaultParentSessionService,
      );
      expect(guardRedirect, isNull);
    });

    test(
        'cold start with empty string primary key restores profile from backup snapshot',
        () async {
      final backupProfile =
          _createProfile('learner_kai', 'Kai', avatarId: 'avatar_cat');
      final snapshotJson = jsonEncode([backupProfile.toJson()]);

      final (_, dataSource) = await _initDataSource({
        'monster_lab_active_profile_id': 'learner_kai',
        'monster_lab_profiles': '',
        'monster_lab_profiles_backup': snapshotJson,
      });

      final profiles = dataSource.getProfiles();
      expect(profiles.length, 1);
      expect(profiles.first.id, 'learner_kai');
      expect(profiles.first.nickname, 'Kai');
    });

    test(
        'intentionally saved empty list is preserved and does not restore stale backup',
        () async {
      final staleBackup = _createProfile('stale_id', 'Stale');

      final (_, dataSource) = await _initDataSource({
        'monster_lab_profiles': '[]',
        'monster_lab_profiles_backup': jsonEncode([staleBackup.toJson()]),
      });

      final profiles = dataSource.getProfiles();
      expect(profiles, isEmpty);
    });
  });
}
