import 'dart:convert';
import '../../data/datasources/local_storage_datasource.dart';
import '../../domain/models/learner_profile_model.dart';
import '../../domain/models/learner_progress_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import 'competency_progression_service.dart';

/// Encapsulates the verified payload extracted from an imported backup.
class BackupImportResult {
  final LearnerProfileModel profile;
  final LearnerProgressModel progress;

  const BackupImportResult({
    required this.profile,
    required this.progress,
  });
}

/// Service handling local JSON backup export, import, schema validation, and consistency checks.
class ParentDataService {
  static const int currentSchemaVersion = 2;

  /// Serializes learner profile and progress into a formatted JSON backup string.
  static String exportBackupJson(
    LearnerProfileModel profile,
    LearnerProgressModel progress,
  ) {
    final Map<String, dynamic> data = {
      'app': 'MonsterLab',
      'version': currentSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': profile.toJson(),
      'progress': progress.toJson(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Generates a privacy-conscious, offline learning summary report
  /// excluding any telemetry, IP addresses, or personal identifiers.
  static Map<String, dynamic> generatePrivacyConsciousReport(
    LearnerProfileModel profile,
    LearnerProgressModel progress,
  ) {
    final competencies =
        CompetencyProgressionService.evaluateCompetencies(progress);

    return {
      'reportType': 'ParentLearningSummary',
      'generatedAt': DateTime.now().toIso8601String(),
      'learnerAlias': profile.nickname,
      'avatarId': profile.avatarId,
      'ageBracket': profile.ageBracket.name,
      'overview': {
        'totalXp': progress.totalXp,
        'currentLevel': progress.currentLevel,
        'completedLessonsCount': progress.completedLessonIds.length,
        'completedProjectsCount': progress.completedProjectIds.length,
        'earnedBadgesCount': progress.earnedBadgeIds.length,
        'lastActiveDate': progress.lastSessionDate.toIso8601String(),
      },
      'competencies': competencies.map((c) => c.toJson()).toList(),
      'privacyNotice':
          'Generated offline on local device. Monster Lab strictly never collects, transmits, or shares personal data or online telemetry.',
    };
  }

  /// Parses and validates a JSON backup string, returning the restored profile and progress.
  /// Throws [FormatException] if the structure, version, or IDs are invalid.
  static BackupImportResult importBackupJson(String jsonString) {
    if (jsonString.trim().isEmpty) {
      throw const FormatException('Import payload is empty');
    }

    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Invalid backup structure: root must be a JSON object');
    }

    if (decoded['app'] != 'MonsterLab') {
      throw const FormatException(
          'Unsupported backup format: app origin mismatch');
    }

    final version = decoded['version'] as int?;
    if (version == null || version > currentSchemaVersion) {
      throw FormatException('Unsupported backup schema version: $version');
    }

    if (!decoded.containsKey('profile') ||
        decoded['profile'] is! Map<String, dynamic>) {
      throw const FormatException('Backup missing valid "profile" object');
    }

    if (!decoded.containsKey('progress') ||
        decoded['progress'] is! Map<String, dynamic>) {
      throw const FormatException('Backup missing valid "progress" object');
    }

    final profileMap = decoded['profile'] as Map<String, dynamic>;
    final progressMap = decoded['progress'] as Map<String, dynamic>;

    final profile = LearnerProfileModel.fromJson(profileMap);
    final progress = LearnerProgressModel.fromJson(progressMap);

    if (profile.id != progress.learnerId) {
      throw const FormatException(
          'Profile ID and Progress Learner ID do not match');
    }

    return BackupImportResult(profile: profile, progress: progress);
  }

  /// Transactionally restores a backup payload:
  /// 1. Fully validates the backup string.
  /// 2. Creates a rollback snapshot of existing profile, progress, and backup state.
  /// 3. Commits the restored profile and progress.
  /// 4. If any persistence operation fails, rolls back immediately to prior state.
  static Future<BackupImportResult> restoreBackupTransactional({
    required String jsonString,
    required ProfileRepository profileRepo,
    required ProgressRepository progressRepo,
    required LocalStorageDataSource storageDataSource,
  }) async {
    final result = importBackupJson(jsonString);

    // Snapshot existing state for atomic rollback
    final existingProfiles = storageDataSource.getProfiles();
    final priorProgressRaw =
        storageDataSource.getRawProgressString(result.profile.id);
    final priorBackupRaw =
        storageDataSource.getRawBackupString(result.profile.id);

    try {
      await profileRepo.saveProfile(result.profile);
      await progressRepo.saveProgress(result.progress);
      return result;
    } catch (e) {
      // Rollback on any failure!
      await storageDataSource.saveProfiles(existingProfiles);
      if (priorProgressRaw != null) {
        await storageDataSource.saveRawProgress(
            result.profile.id, priorProgressRaw);
      } else {
        await storageDataSource.deleteProgress(result.profile.id);
      }
      if (priorBackupRaw != null) {
        await storageDataSource.saveBackupSnapshot(
            result.profile.id, priorBackupRaw);
      }
      rethrow;
    }
  }

  /// Takes an in-memory snapshot of all profiles and progress across learners before a destructive action.
  static PreDestructiveSnapshot createPreDestructiveSnapshot(
      LocalStorageDataSource storageDataSource) {
    final profiles = storageDataSource.getProfiles();
    final progressMap = <String, String?>{};
    final backupMap = <String, String?>{};

    for (final profile in profiles) {
      progressMap[profile.id] =
          storageDataSource.getRawProgressString(profile.id);
      backupMap[profile.id] = storageDataSource.getRawBackupString(profile.id);
    }

    return PreDestructiveSnapshot(
      profiles: profiles,
      rawProgressByLearner: progressMap,
      rawBackupByLearner: backupMap,
      capturedAt: DateTime.now(),
    );
  }

  /// Restores a full pre-destructive snapshot, recovering profiles and progress slots.
  static Future<void> restorePreDestructiveSnapshot(
    PreDestructiveSnapshot snapshot,
    LocalStorageDataSource storageDataSource,
  ) async {
    await storageDataSource.saveProfiles(snapshot.profiles);
    for (final entry in snapshot.rawProgressByLearner.entries) {
      if (entry.value != null) {
        await storageDataSource.saveRawProgress(entry.key, entry.value!);
      } else {
        await storageDataSource.deleteProgress(entry.key);
      }
    }
    for (final entry in snapshot.rawBackupByLearner.entries) {
      if (entry.value != null) {
        await storageDataSource.saveBackupSnapshot(entry.key, entry.value!);
      }
    }
  }

  /// Executes a destructive action with mandatory confirmation check and automatic rollback on failure.
  static Future<T> executeDestructiveAction<T>({
    required LocalStorageDataSource storageDataSource,
    required String confirmationInput,
    String requiredPhrase = 'CONFIRM',
    required Future<T> Function() action,
  }) async {
    if (confirmationInput.trim().toUpperCase() !=
        requiredPhrase.toUpperCase()) {
      throw FormatException(
        'Destructive action cancelled: confirmation phrase "$confirmationInput" did not match "$requiredPhrase".',
      );
    }

    final snapshot = createPreDestructiveSnapshot(storageDataSource);
    try {
      return await action();
    } catch (e) {
      // Automatic recovery on failure!
      await restorePreDestructiveSnapshot(snapshot, storageDataSource);
      rethrow;
    }
  }
}

class PreDestructiveSnapshot {
  final List<LearnerProfileModel> profiles;
  final Map<String, String?> rawProgressByLearner;
  final Map<String, String?> rawBackupByLearner;
  final DateTime capturedAt;

  const PreDestructiveSnapshot({
    required this.profiles,
    required this.rawProgressByLearner,
    required this.rawBackupByLearner,
    required this.capturedAt,
  });
}
