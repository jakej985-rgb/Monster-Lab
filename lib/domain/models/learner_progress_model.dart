import 'dart:math' as math;

enum ActivityType { lesson, project, challenge, component }

abstract final class ProgressBadgeIds {
  static const String firstCircuitScout = 'badge_first_circuit_scout';
}

enum QuickCheckReadiness {
  ready,
  warmUp,
  notAssessed,
}

class QuickCheckResult {
  final String lessonId;
  final String submoduleId;
  final List<String> questionIds;
  final List<int> selectedAnswers;
  final bool isBypassed;
  final QuickCheckReadiness readiness;
  final DateTime timestamp;
  final bool warmupShown;

  const QuickCheckResult({
    required this.lessonId,
    required this.submoduleId,
    required this.questionIds,
    required this.selectedAnswers,
    required this.isBypassed,
    required this.readiness,
    required this.timestamp,
    this.warmupShown = false,
  });

  factory QuickCheckResult.fromJson(Map<String, dynamic> json) {
    return QuickCheckResult(
      lessonId: json['lessonId'] as String,
      submoduleId: json['submoduleId'] as String,
      questionIds: List<String>.from(json['questionIds'] as List? ?? []),
      selectedAnswers: List<int>.from(json['selectedAnswers'] as List? ?? []),
      isBypassed: json['isBypassed'] as bool? ?? false,
      readiness: QuickCheckReadiness.values.byName(
        json['readiness'] as String? ?? 'notAssessed',
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      warmupShown: json['warmupShown'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'submoduleId': submoduleId,
        'questionIds': questionIds,
        'selectedAnswers': selectedAnswers,
        'isBypassed': isBypassed,
        'readiness': readiness.name,
        'timestamp': timestamp.toIso8601String(),
        'warmupShown': warmupShown,
      };
}

class LastActivityInfo {
  final ActivityType type;
  final String activityId;
  final String title;
  final DateTime timestamp;
  final int? stepNumber;

  const LastActivityInfo({
    required this.type,
    required this.activityId,
    required this.title,
    required this.timestamp,
    this.stepNumber,
  });

  factory LastActivityInfo.fromJson(Map<String, dynamic> json) {
    return LastActivityInfo(
      type: ActivityType.values.byName(json['type'] as String),
      activityId: json['activityId'] as String,
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      stepNumber: json['stepNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'activityId': activityId,
        'title': title,
        'timestamp': timestamp.toIso8601String(),
        if (stepNumber != null) 'stepNumber': stepNumber,
      };
}

class UnsupportedSchemaVersionException implements Exception {
  final int requestedVersion;
  final int currentVersion;

  const UnsupportedSchemaVersionException(
    this.requestedVersion,
    this.currentVersion,
  );

  @override
  String toString() =>
      'UnsupportedSchemaVersionException: Schema version $requestedVersion is higher than supported version $currentVersion';
}

enum ProgressEventType {
  courseCompleted,
  lessonCompleted,
  placementPassed,
  componentDiscovered,
  projectCompleted,
  projectStepBookmarked,
  challengeSolved,
  badgeEarned,
  quizScoreRecorded,
  quickCheckRecorded,
  xpAdded,
}

class LearnerProgressEvent {
  final String eventId;
  final ProgressEventType eventType;
  final String learnerId;
  final String activityId;
  final DateTime timestamp;
  final int xpAwarded;
  final Map<String, dynamic> metadata;

  const LearnerProgressEvent({
    required this.eventId,
    required this.eventType,
    required this.learnerId,
    required this.activityId,
    required this.timestamp,
    this.xpAwarded = 0,
    this.metadata = const {},
  });

  factory LearnerProgressEvent.fromJson(Map<String, dynamic> json) {
    return LearnerProgressEvent(
      eventId: json['eventId'] as String,
      eventType: ProgressEventType.values.byName(json['eventType'] as String),
      learnerId: json['learnerId'] as String,
      activityId: json['activityId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      xpAwarded: json['xpAwarded'] as int? ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'eventType': eventType.name,
        'learnerId': learnerId,
        'activityId': activityId,
        'timestamp': timestamp.toIso8601String(),
        'xpAwarded': xpAwarded,
        'metadata': metadata,
      };
}

class LearnerProgressModel {
  static const int currentSchemaVersion = 2;

  /// The completion sets and XP totals are authoritative; the ledger is a
  /// bounded audit trail so long-lived profiles cannot grow without limit.
  static const int maxEventLedgerEntries = 1000;
  static const int maxProcessedTransactionIds = 2000;

  final int schemaVersion;
  final String learnerId;
  final int totalXp;
  final Set<String> completedCourseIds;
  final Set<String> placementPassedCourseIds;
  final Set<String> completedLessonIds;
  final Set<String> discoveredComponentIds;
  final Set<String> completedProjectIds;
  final Map<String, int> projectStepBookmarks;
  final Set<String> solvedChallengeIds;
  final Set<String> earnedBadgeIds;
  final Map<String, int> quizBestScores;
  final Map<String, QuickCheckResult> quickCheckResults;
  final LastActivityInfo? lastActivity;
  final DateTime lastSessionDate;
  final Set<String> processedTransactionIds;
  final List<LearnerProgressEvent> eventLedger;

  const LearnerProgressModel({
    this.schemaVersion = currentSchemaVersion,
    required this.learnerId,
    this.totalXp = 0,
    this.completedCourseIds = const {},
    this.placementPassedCourseIds = const {},
    this.completedLessonIds = const {},
    this.discoveredComponentIds = const {},
    this.completedProjectIds = const {},
    this.projectStepBookmarks = const {},
    this.solvedChallengeIds = const {},
    this.earnedBadgeIds = const {},
    this.quizBestScores = const {},
    this.quickCheckResults = const {},
    this.lastActivity,
    required this.lastSessionDate,
    this.processedTransactionIds = const {},
    this.eventLedger = const [],
  });

  /// Computes level based on XP: Level = floor(sqrt(XP / 50)) + 1
  int get currentLevel {
    if (totalXp <= 0) return 1;
    return (math.sqrt(totalXp / 50)).floor() + 1;
  }

  /// Calculates XP threshold required for next level
  int get xpForNextLevel {
    final nextLevel = currentLevel;
    return nextLevel * nextLevel * 50;
  }

  /// Progress ratio towards next level (0.0 to 1.0)
  double get levelProgressRatio {
    final currentLevelBaseXp = (currentLevel - 1) * (currentLevel - 1) * 50;
    final nextLevelXp = xpForNextLevel;
    final span = nextLevelXp - currentLevelBaseXp;
    if (span <= 0) return 1.0;
    final progressInLevel = totalXp - currentLevelBaseXp;
    return (progressInLevel / span).clamp(0.0, 1.0);
  }

  factory LearnerProgressModel.empty(String learnerId) {
    return LearnerProgressModel(
      schemaVersion: currentSchemaVersion,
      learnerId: learnerId,
      lastSessionDate: DateTime.now(),
    );
  }

  factory LearnerProgressModel.fromJson(Map<String, dynamic> json) {
    final version = json['schemaVersion'] as int? ?? 1;
    if (version > currentSchemaVersion) {
      throw UnsupportedSchemaVersionException(version, currentSchemaVersion);
    }

    final rawModel = LearnerProgressModel(
      schemaVersion: version,
      learnerId: json['learnerId'] as String,
      totalXp: json['totalXp'] as int? ?? 0,
      completedCourseIds:
          Set<String>.from(json['completedCourseIds'] as List? ?? []),
      placementPassedCourseIds:
          Set<String>.from(json['placementPassedCourseIds'] as List? ?? []),
      completedLessonIds:
          Set<String>.from(json['completedLessonIds'] as List? ?? []),
      discoveredComponentIds:
          Set<String>.from(json['discoveredComponentIds'] as List? ?? []),
      completedProjectIds:
          Set<String>.from(json['completedProjectIds'] as List? ?? []),
      projectStepBookmarks: Map<String, int>.from(
        (json['projectStepBookmarks'] as Map?)
                ?.map((k, v) => MapEntry(k as String, v as int)) ??
            {},
      ),
      solvedChallengeIds:
          Set<String>.from(json['solvedChallengeIds'] as List? ?? []),
      earnedBadgeIds: Set<String>.from(json['earnedBadgeIds'] as List? ?? []),
      quizBestScores: Map<String, int>.from(
        (json['quizBestScores'] as Map?)
                ?.map((k, v) => MapEntry(k as String, v as int)) ??
            {},
      ),
      quickCheckResults: (json['quickCheckResults'] as Map?)?.map((k, v) =>
              MapEntry(k as String,
                  QuickCheckResult.fromJson(v as Map<String, dynamic>))) ??
          {},
      lastActivity: json['lastActivity'] != null
          ? LastActivityInfo.fromJson(
              json['lastActivity'] as Map<String, dynamic>)
          : null,
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.parse(json['lastSessionDate'] as String)
          : DateTime.now(),
      processedTransactionIds:
          Set<String>.from(json['processedTransactionIds'] as List? ?? []),
      eventLedger: (json['eventLedger'] as List? ?? [])
          .map((e) => LearnerProgressEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (version < currentSchemaVersion) {
      return migrateSchema(rawModel,
          fromVersion: version, toVersion: currentSchemaVersion);
    }
    return rawModel;
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'learnerId': learnerId,
        'totalXp': totalXp,
        'currentLevel': currentLevel,
        'completedCourseIds': completedCourseIds.toList(),
        'placementPassedCourseIds': placementPassedCourseIds.toList(),
        'completedLessonIds': completedLessonIds.toList(),
        'discoveredComponentIds': discoveredComponentIds.toList(),
        'completedProjectIds': completedProjectIds.toList(),
        'projectStepBookmarks': projectStepBookmarks,
        'solvedChallengeIds': solvedChallengeIds.toList(),
        'earnedBadgeIds': earnedBadgeIds.toList(),
        'quizBestScores': quizBestScores,
        'quickCheckResults':
            quickCheckResults.map((k, v) => MapEntry(k, v.toJson())),
        if (lastActivity != null) 'lastActivity': lastActivity!.toJson(),
        'lastSessionDate': lastSessionDate.toIso8601String(),
        'processedTransactionIds': processedTransactionIds.toList(),
        'eventLedger': eventLedger.map((e) => e.toJson()).toList(),
      };

  LearnerProgressModel copyWith({
    int? schemaVersion,
    int? totalXp,
    Set<String>? completedCourseIds,
    Set<String>? placementPassedCourseIds,
    Set<String>? completedLessonIds,
    Set<String>? discoveredComponentIds,
    Set<String>? completedProjectIds,
    Map<String, int>? projectStepBookmarks,
    Set<String>? solvedChallengeIds,
    Set<String>? earnedBadgeIds,
    Map<String, int>? quizBestScores,
    Map<String, QuickCheckResult>? quickCheckResults,
    LastActivityInfo? lastActivity,
    DateTime? lastSessionDate,
    Set<String>? processedTransactionIds,
    List<LearnerProgressEvent>? eventLedger,
  }) {
    return LearnerProgressModel(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      learnerId: learnerId,
      totalXp: totalXp ?? this.totalXp,
      completedCourseIds: completedCourseIds ?? this.completedCourseIds,
      placementPassedCourseIds:
          placementPassedCourseIds ?? this.placementPassedCourseIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      discoveredComponentIds:
          discoveredComponentIds ?? this.discoveredComponentIds,
      completedProjectIds: completedProjectIds ?? this.completedProjectIds,
      projectStepBookmarks: projectStepBookmarks ?? this.projectStepBookmarks,
      solvedChallengeIds: solvedChallengeIds ?? this.solvedChallengeIds,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      quizBestScores: quizBestScores ?? this.quizBestScores,
      quickCheckResults: quickCheckResults ?? this.quickCheckResults,
      lastActivity: lastActivity ?? this.lastActivity,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      processedTransactionIds:
          processedTransactionIds ?? this.processedTransactionIds,
      eventLedger: eventLedger ?? this.eventLedger,
    );
  }

  /// Migrates models across schema versions
  static LearnerProgressModel migrateSchema(
    LearnerProgressModel model, {
    required int fromVersion,
    required int toVersion,
  }) {
    var current = model;
    if (fromVersion == 1) {
      // 1. Run legacy lesson ID mappings
      current = migrateFromOldFormat(current);

      // 2. Synthesize transaction keys from completed items if empty
      final synthesizedTx = Set<String>.from(current.processedTransactionIds);
      for (final cid in current.completedCourseIds) {
        synthesizedTx.add('tx_course_$cid');
      }
      for (final lid in current.completedLessonIds) {
        synthesizedTx.add('tx_lesson_$lid');
      }
      for (final chid in current.solvedChallengeIds) {
        synthesizedTx.add('tx_chal_$chid');
      }
      for (final pid in current.completedProjectIds) {
        synthesizedTx.add('tx_proj_$pid');
      }
      for (final bid in current.earnedBadgeIds) {
        synthesizedTx.add('tx_badge_$bid');
      }

      current = current.copyWith(
        schemaVersion: 2,
        processedTransactionIds: synthesizedTx,
      );
    }
    return current;
  }

  /// Replays an event ledger sequentially to construct a consistent state snapshot
  static LearnerProgressModel replayFromEvents(
    String learnerId,
    List<LearnerProgressEvent> events,
  ) {
    var progress = LearnerProgressModel.empty(learnerId);
    for (final event in events) {
      progress = progress.applyEvent(event);
    }
    return progress;
  }

  static Set<String> _boundedTransactionIds(Set<String> ids) {
    if (ids.length <= maxProcessedTransactionIds) return ids;
    return ids.skip(ids.length - maxProcessedTransactionIds).toSet();
  }

  static List<LearnerProgressEvent> _boundedLedger(
      List<LearnerProgressEvent> events) {
    if (events.length <= maxEventLedgerEntries) return events;
    return events.sublist(events.length - maxEventLedgerEntries);
  }

  /// Applies a single event deterministically and idempotently
  LearnerProgressModel applyEvent(LearnerProgressEvent event) {
    if (processedTransactionIds.contains(event.eventId)) {
      return this; // Idempotent: already applied
    }

    final updatedTx = _boundedTransactionIds(
      Set<String>.from(processedTransactionIds)..add(event.eventId),
    );
    final updatedLedger = _boundedLedger(
      List<LearnerProgressEvent>.from(eventLedger)..add(event),
    );

    switch (event.eventType) {
      case ProgressEventType.courseCompleted:
        final updatedCourses = Set<String>.from(completedCourseIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          completedCourseIds: updatedCourses,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.lessonCompleted:
        final updatedLessons = Set<String>.from(completedLessonIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          completedLessonIds: updatedLessons,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.placementPassed:
        final updatedPlacements = Set<String>.from(placementPassedCourseIds)
          ..add(event.activityId);
        return copyWith(
          placementPassedCourseIds: updatedPlacements,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.componentDiscovered:
        final updatedComponents = Set<String>.from(discoveredComponentIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          discoveredComponentIds: updatedComponents,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.projectCompleted:
        final updatedProjects = Set<String>.from(completedProjectIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          completedProjectIds: updatedProjects,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.projectStepBookmarked:
        final step = event.metadata['stepNumber'] as int? ?? 1;
        final updatedBookmarks = Map<String, int>.from(projectStepBookmarks)
          ..[event.activityId] = step;
        return copyWith(
          projectStepBookmarks: updatedBookmarks,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.challengeSolved:
        final updatedChallenges = Set<String>.from(solvedChallengeIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          solvedChallengeIds: updatedChallenges,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.badgeEarned:
        final updatedBadges = Set<String>.from(earnedBadgeIds)
          ..add(event.activityId);
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          earnedBadgeIds: updatedBadges,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.quizScoreRecorded:
        final score = event.metadata['score'] as int? ?? 0;
        final updatedScores = Map<String, int>.from(quizBestScores)
          ..[event.activityId] = score;
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          quizBestScores: updatedScores,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.quickCheckRecorded:
        return copyWith(
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
      case ProgressEventType.xpAdded:
        return copyWith(
          totalXp: totalXp + event.xpAwarded,
          processedTransactionIds: updatedTx,
          eventLedger: updatedLedger,
          lastSessionDate: event.timestamp,
        );
    }
  }

  static LearnerProgressModel migrateFromOldFormat(LearnerProgressModel old) {
    final updatedLessonIds = Set<String>.from(old.completedLessonIds);
    final updatedCourseIds = Set<String>.from(old.completedCourseIds);
    bool changed = false;

    final legacyMapping = <String, (String, List<String>)>{
      'lesson_01': (
        'lesson_01',
        [for (int i = 1; i <= 12; i++) 'l01_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_02': (
        'lesson_2b',
        [for (int i = 1; i <= 8; i++) 'l2b_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_03': (
        'lesson_03',
        [for (int i = 1; i <= 9; i++) 'l03_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_04': (
        'lesson_04',
        [for (int i = 1; i <= 10; i++) 'l04_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_05': (
        'lesson_05',
        [for (int i = 1; i <= 16; i++) 'l05_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_06': (
        'lesson_06',
        [for (int i = 1; i <= 11; i++) 'l06_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_07': (
        'lesson_07',
        [for (int i = 1; i <= 11; i++) 'l07_${i.toString().padLeft(2, '0')}'],
      ),
      'lesson_08': (
        'lesson_08',
        [for (int i = 1; i <= 10; i++) 'l08_${i.toString().padLeft(2, '0')}'],
      ),
    };

    for (final entry in legacyMapping.entries) {
      if (old.completedLessonIds.contains(entry.key)) {
        updatedCourseIds.add(entry.value.$1);
        updatedLessonIds.addAll(entry.value.$2);
        changed = true;
      }
    }

    if (changed) {
      return old.copyWith(
        completedLessonIds: updatedLessonIds,
        completedCourseIds: updatedCourseIds,
      );
    }
    return old;
  }
}
