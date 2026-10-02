import '../../domain/models/learner_profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local_storage_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final LocalStorageDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<List<LearnerProfileModel>> getAllProfiles() async {
    return _dataSource.getProfiles();
  }

  @override
  Future<LearnerProfileModel?> getActiveProfile() async {
    final activeId = _dataSource.getActiveProfileId();
    if (activeId == null) return null;
    final profiles = _dataSource.getProfiles();
    try {
      return profiles.firstWhere((p) => p.id == activeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setActiveProfile(String profileId) async {
    await _dataSource.setActiveProfileId(profileId);
  }

  @override
  Future<void> saveProfile(LearnerProfileModel profile) async {
    final profiles = _dataSource.getProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      profiles[index] = profile;
    } else {
      profiles.add(profile);
    }
    await _dataSource.saveProfiles(profiles);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    final profiles = _dataSource.getProfiles();
    profiles.removeWhere((p) => p.id == profileId);
    await _dataSource.saveProfiles(profiles);
    await _dataSource.deleteProgress(profileId);
    if (_dataSource.getActiveProfileId() == profileId) {
      if (profiles.isNotEmpty) {
        await _dataSource.setActiveProfileId(profiles.first.id);
      } else {
        await _dataSource.clearActiveProfileId();
      }
    }
  }
}
