import 'dart:convert';
import '../../core/services/storage_service.dart';
import '../../domain/models/learner_profile_model.dart';
import '../../domain/models/learner_progress_model.dart';

class ProgressCorruptionException implements Exception {
  final String learnerId;
  final String rawPayload;
  final Object error;

  const ProgressCorruptionException(
      this.learnerId, this.rawPayload, this.error);

  @override
  String toString() =>
      'ProgressCorruptionException [learner: $learnerId]: Payload is corrupt and could not be recovered ($error)';
}

class LocalStorageDataSource {
  final StorageService _storageService;

  static const String _profilesKey = 'monster_lab_profiles';
  static const String _activeProfileIdKey = 'monster_lab_active_profile_id';
  static const String _progressKeyPrefix = 'monster_lab_progress_';
  static const String _backupKeyPrefix = 'monster_lab_progress_backup_';

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

  String? getRawProgressString(String learnerId) {
    return _storageService.getString('$_progressKeyPrefix$learnerId');
  }

  String? getRawBackupString(String learnerId) {
    return _storageService.getString('$_backupKeyPrefix$learnerId');
  }

  Future<void> saveRawProgress(String learnerId, String rawJson) async {
    await _storageService.setString('$_progressKeyPrefix$learnerId', rawJson);
  }

  Future<void> saveBackupSnapshot(String learnerId, String rawJson) async {
    await _storageService.setString('$_backupKeyPrefix$learnerId', rawJson);
  }

  ProgressCorruptionException? _lastCorruption;
  ProgressCorruptionException? get lastCorruption => _lastCorruption;

  LearnerProgressModel getProgress(String learnerId,
      {bool throwOnUnrecoverable = false}) {
    final raw = _storageService.getString('$_progressKeyPrefix$learnerId');
    if (raw == null || raw.isEmpty) {
      return LearnerProgressModel.empty(learnerId);
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LearnerProgressModel.fromJson(map);
    } catch (err) {
      final corruptionException =
          ProgressCorruptionException(learnerId, raw, err);
      _lastCorruption = corruptionException;

      // Primary payload is corrupt. Attempt recovery from backup snapshot!
      final backupRaw =
          _storageService.getString('$_backupKeyPrefix$learnerId');
      if (backupRaw != null && backupRaw.isNotEmpty) {
        try {
          final backupMap = jsonDecode(backupRaw) as Map<String, dynamic>;
          final recovered = LearnerProgressModel.fromJson(backupMap);
          // Auto-repair primary slot with recovered backup
          _storageService.setString('$_progressKeyPrefix$learnerId', backupRaw);
          return recovered;
        } catch (_) {}
      }

      if (throwOnUnrecoverable) {
        throw corruptionException;
      }
      return LearnerProgressModel.empty(learnerId);
    }
  }

  Future<void> saveProgress(LearnerProgressModel progress) async {
    final raw = jsonEncode(progress.toJson());
    await _storageService.setString(
        '$_progressKeyPrefix${progress.learnerId}', raw);
    // Maintain a verified backup snapshot
    await _storageService.setString(
        '$_backupKeyPrefix${progress.learnerId}', raw);
  }

  Future<void> deleteProgress(String learnerId) async {
    await _storageService.remove('$_progressKeyPrefix$learnerId');
    await _storageService.remove('$_backupKeyPrefix$learnerId');
  }
}
