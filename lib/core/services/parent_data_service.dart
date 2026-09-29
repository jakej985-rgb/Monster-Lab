import 'dart:convert';
import '../../domain/models/learner_profile_model.dart';
import '../../domain/models/learner_progress_model.dart';

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
  static const int currentSchemaVersion = 1;

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
}
