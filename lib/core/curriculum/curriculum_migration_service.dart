import '../../domain/models/learner_progress_model.dart';

class UnsupportedCurriculumVersionException implements Exception {
  final String message;
  final int incomingVersion;
  final int supportedVersion;

  const UnsupportedCurriculumVersionException(
    this.message, {
    required this.incomingVersion,
    required this.supportedVersion,
  });

  @override
  String toString() =>
      'UnsupportedCurriculumVersionException: $message (incoming: $incomingVersion, supported: $supportedVersion)';
}

class CurriculumMigrationResult {
  final LearnerProgressModel progress;
  final bool migrationApplied;
  final int initialSchemaVersion;
  final int finalSchemaVersion;
  final List<String> appliedMigrationSteps;

  const CurriculumMigrationResult({
    required this.progress,
    required this.migrationApplied,
    required this.initialSchemaVersion,
    required this.finalSchemaVersion,
    required this.appliedMigrationSteps,
  });
}

class CurriculumMigrationService {
  static const int currentCurriculumDataVersion = 3;
  static const int minSupportedProgressVersion = 1;
  static const int maxSupportedProgressVersion = 2;

  /// Verifies if a given progress payload schema version is compatible
  static bool isVersionCompatible(int version) {
    return version >= minSupportedProgressVersion &&
        version <= maxSupportedProgressVersion;
  }

  /// Migrates legacy or versioned progress data into the current schema
  static CurriculumMigrationResult migrate(Map<String, dynamic> rawJson) {
    final rawVersion = rawJson['schemaVersion'] as int? ?? 1;

    if (rawVersion > maxSupportedProgressVersion) {
      throw UnsupportedCurriculumVersionException(
        'Progress schema version $rawVersion exceeds maximum supported version $maxSupportedProgressVersion',
        incomingVersion: rawVersion,
        supportedVersion: maxSupportedProgressVersion,
      );
    }

    final steps = <String>[];
    final currentData = Map<String, dynamic>.from(rawJson);

    // Migration Step: Version 1 -> Version 2
    if (rawVersion == 1) {
      steps.add('Migrate unversioned v1 schema to v2 transaction-backed model');

      // Expand legacy lesson_01 single course completion into sub-lessons
      final completedLessons = List<String>.from(
          (currentData['completedLessonIds'] as List?) ?? const []);
      final completedCourses = List<String>.from(
          (currentData['completedCourseIds'] as List?) ?? const []);
      final txIds = List<String>.from(
          (currentData['processedTransactionIds'] as List?) ?? const []);

      if (completedLessons.contains('lesson_01') &&
          !completedCourses.contains('lesson_01')) {
        completedCourses.add('lesson_01');
        steps.add('Map legacy lesson_01 identifier to course container');
      }

      currentData['schemaVersion'] = 2;
      currentData['completedLessonIds'] = completedLessons;
      currentData['completedCourseIds'] = completedCourses;
      currentData['processedTransactionIds'] = txIds;
    }

    final migratedModel = LearnerProgressModel.fromJson(currentData);

    return CurriculumMigrationResult(
      progress: migratedModel,
      migrationApplied: steps.isNotEmpty,
      initialSchemaVersion: rawVersion,
      finalSchemaVersion: migratedModel.schemaVersion,
      appliedMigrationSteps: steps,
    );
  }
}
