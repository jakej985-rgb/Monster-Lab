import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

LearnerProfileModel _makeProfile(String id, String nickname) {
  final now = DateTime.now();
  return LearnerProfileModel(
    id: id,
    nickname: nickname,
    avatarId: 'avatar_robot',
    ageBracket: AgeBracket.ages10_12,
    createdAt: now,
    lastActiveAt: now,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Picker Invalidation & Synchronization Suite', () {
    test(
        'allProfilesProvider stays in sync when profiles are deleted and added',
        () async {
      final initialProfile = _makeProfile('p1', 'Alice');
      SharedPreferences.setMockInitialValues({
        'monster_lab_profiles': jsonEncode([initialProfile.toJson()]),
        'monster_lab_active_profile_id': 'p1',
      });

      final storageService = await StorageService.init();
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      // Initial read of all profiles
      var profiles = await container.read(allProfilesProvider.future);
      expect(profiles.length, equals(1));
      expect(profiles.first.id, equals('p1'));

      // Delete the only profile
      await container.read(activeProfileProvider.notifier).deleteProfile('p1');

      // The provider cache should have been invalidated, returning empty list
      profiles = await container.read(allProfilesProvider.future);
      expect(profiles, isEmpty);

      // Save a new replacement profile (e.g. from onboarding)
      final replacement = _makeProfile('p2', 'Bob');
      await container
          .read(activeProfileProvider.notifier)
          .saveProfile(replacement, setActive: true);

      // The provider cache should have been invalidated, immediately returning the new profile
      profiles = await container.read(allProfilesProvider.future);
      expect(profiles.length, equals(1));
      expect(profiles.first.id, equals('p2'));
      expect(profiles.first.nickname, equals('Bob'));
    });
  });
}
