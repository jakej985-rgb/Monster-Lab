import 'dart:convert';
import '../../core/services/storage_service.dart';
import '../../domain/models/learner_profile_model.dart';
import '../../domain/models/learner_progress_model.dart';

class LocalStorageDataSource {
  final StorageService _storageService;

  static const String _profilesKey = 'monster_lab_profiles';
  static const String _activeProfileIdKey = 'monster_lab_active_profile_id';
  static const String _progressKeyPrefix = 'monster_lab_progress_';

  LocalStorageDataSource(this._storageService);

  List<LearnerProfileModel> getProfiles() {
    final raw = _storageService.getString(_profilesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((item) =>
              LearnerProfileModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProfiles(List<LearnerProfileModel> profiles) async {
    final raw = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _storageService.setString(_profilesKey, raw);
  }

  String? getActiveProfileId() {
    return _storageService.getString(_activeProfileIdKey);
  }

  Future<void> setActiveProfileId(String profileId) async {
    await _storageService.setString(_activeProfileIdKey, profileId);
  }

  Future<void> clearActiveProfileId() async {
    await _storageService.remove(_activeProfileIdKey);
  }

  LearnerProgressModel getProgress(String learnerId) {
    final raw = _storageService.getString('$_progressKeyPrefix$learnerId');
    if (raw == null || raw.isEmpty) {
      return LearnerProgressModel.empty(learnerId);
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LearnerProgressModel.fromJson(map);
    } catch (_) {
      return LearnerProgressModel.empty(learnerId);
    }
  }

  Future<void> saveProgress(LearnerProgressModel progress) async {
    final raw = jsonEncode(progress.toJson());
    await _storageService.setString(
        '$_progressKeyPrefix${progress.learnerId}', raw);
  }

  Future<void> deleteProgress(String learnerId) async {
    await _storageService.remove('$_progressKeyPrefix$learnerId');
  }
}
