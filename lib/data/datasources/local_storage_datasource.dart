import 'dart:async';
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
  static const String _profilesBackupKey = 'monster_lab_profiles_backup';
  static const String _activeProfileIdKey = 'monster_lab_active_profile_id';
  static const String _progressKeyPrefix = 'monster_lab_progress_';
  static const String _backupKeyPrefix = 'monster_lab_progress_backup_';

  LocalStorageDataSource(this._storageService);

  final StreamController<String> _corruptionController =
      StreamController<String>.broadcast();
  String? _lastCorruptionMessage;

  /// Avoids re-decoding the same progress payload after every save/read cycle.
  final Map<String, _CachedProgress> _progressCache = {};

  String? get lastCorruptionMessage => _lastCorruptionMessage;

  Stream<String> get corruptionStream async* {
    final initial = _lastCorruptionMessage;
    if (initial != null) yield initial;
    yield* _corruptionController.stream;
  }

  void _reportCorruption(String message) {
    _lastCorruptionMessage = message;
    _corruptionController.add(message);
  }

  List<LearnerProfileModel>? _tryParseProfiles(String raw) {
    return LearnerProfileModel.tryDecodeList(raw);
  }

  List<LearnerProfileModel> getProfiles() {
    final raw = _storageService.getString(_profilesKey);
    if (raw == '[]') {
      return [];
    }

    if (raw != null && raw.isNotEmpty) {
      final profiles = _tryParseProfiles(raw);
      if (profiles != null) {
        return profiles;
      }
    }

    final backupRaw = _storageService.getString(_profilesBackupKey);
    if (backupRaw != null && backupRaw.isNotEmpty && backupRaw != '[]') {
      final recovered = _tryParseProfiles(backupRaw);
      if (recovered != null) {
        _storageService.setString(_profilesKey, backupRaw);
        _reportCorruption(
          'Learner profiles were recovered from a backup snapshot.',
        );
        return recovered;
      }
    }

    if (raw != null && raw.isNotEmpty) {
      _reportCorruption(
        'Learner profiles could not be read. The local profile store may '
        'be corrupt; restore a backup or create a new profile.',
      );
    }
    return [];
  }

  Future<void> saveProfiles(List<LearnerProfileModel> profiles) async {
    final raw = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _storageService.setString(_profilesKey, raw);
    await _storageService.setString(_profilesBackupKey, raw);
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
    _progressCache.remove(learnerId);
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
    final cached = _progressCache[learnerId];
    if (cached != null && cached.raw == raw) {
      return cached.model;
    }
    if (raw == null || raw.isEmpty) {
      final empty = LearnerProgressModel.empty(learnerId);
      _progressCache[learnerId] = _CachedProgress(raw, empty);
      return empty;
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final parsed = LearnerProgressModel.fromJson(map);
      _progressCache[learnerId] = _CachedProgress(raw, parsed);
      return parsed;
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
          _progressCache[learnerId] = _CachedProgress(backupRaw, recovered);
          _reportCorruption(
            'Progress for learner $learnerId was recovered from a backup snapshot.',
          );
          return recovered;
        } catch (_) {}
      }

      _reportCorruption(
        'Progress for learner $learnerId could not be recovered. The corrupt '
        'payload was not overwritten; restore a backup if available.',
      );
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
    _progressCache[progress.learnerId] = _CachedProgress(raw, progress);
  }

  Future<void> deleteProgress(String learnerId) async {
    _progressCache.remove(learnerId);
    await _storageService.remove('$_progressKeyPrefix$learnerId');
    await _storageService.remove('$_backupKeyPrefix$learnerId');
  }
}

class _CachedProgress {
  final String? raw;
  final LearnerProgressModel model;

  const _CachedProgress(this.raw, this.model);
}
