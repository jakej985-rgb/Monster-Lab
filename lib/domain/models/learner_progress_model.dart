import 'dart:math' as math;

enum ActivityType { lesson, project, challenge, component }

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

class LearnerProgressModel {
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

  const LearnerProgressModel({
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
      learnerId: learnerId,
      lastSessionDate: DateTime.now(),
    );
  }

  factory LearnerProgressModel.fromJson(Map<String, dynamic> json) {
    return LearnerProgressModel(
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
    );
  }

  Map<String, dynamic> toJson() => {
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
      };

  LearnerProgressModel copyWith({
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
  }) {
    return LearnerProgressModel(
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
    );
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
