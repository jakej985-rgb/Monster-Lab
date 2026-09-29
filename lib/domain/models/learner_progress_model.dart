import 'dart:math' as math;

enum ActivityType { lesson, project, challenge, component }

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
  final Set<String> completedLessonIds;
  final Set<String> discoveredComponentIds;
  final Set<String> completedProjectIds;
  final Map<String, int> projectStepBookmarks;
  final Set<String> solvedChallengeIds;
  final Set<String> earnedBadgeIds;
  final Map<String, int> quizBestScores;
  final LastActivityInfo? lastActivity;
  final DateTime lastSessionDate;

  const LearnerProgressModel({
    required this.learnerId,
    this.totalXp = 0,
    this.completedLessonIds = const {},
    this.discoveredComponentIds = const {},
    this.completedProjectIds = const {},
    this.projectStepBookmarks = const {},
    this.solvedChallengeIds = const {},
    this.earnedBadgeIds = const {},
    this.quizBestScores = const {},
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
      lastActivity: json['lastActivity'] != null
          ? LastActivityInfo.fromJson(
              json['lastActivity'] as Map<String, dynamic>)
          : null,
      lastSessionDate: DateTime.parse(json['lastSessionDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'learnerId': learnerId,
        'totalXp': totalXp,
        'currentLevel': currentLevel,
        'completedLessonIds': completedLessonIds.toList(),
        'discoveredComponentIds': discoveredComponentIds.toList(),
        'completedProjectIds': completedProjectIds.toList(),
        'projectStepBookmarks': projectStepBookmarks,
        'solvedChallengeIds': solvedChallengeIds.toList(),
        'earnedBadgeIds': earnedBadgeIds.toList(),
        'quizBestScores': quizBestScores,
        if (lastActivity != null) 'lastActivity': lastActivity!.toJson(),
        'lastSessionDate': lastSessionDate.toIso8601String(),
      };

  LearnerProgressModel copyWith({
    int? totalXp,
    Set<String>? completedLessonIds,
    Set<String>? discoveredComponentIds,
    Set<String>? completedProjectIds,
    Map<String, int>? projectStepBookmarks,
    Set<String>? solvedChallengeIds,
    Set<String>? earnedBadgeIds,
    Map<String, int>? quizBestScores,
    LastActivityInfo? lastActivity,
    DateTime? lastSessionDate,
  }) {
    return LearnerProgressModel(
      learnerId: learnerId,
      totalXp: totalXp ?? this.totalXp,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      discoveredComponentIds:
          discoveredComponentIds ?? this.discoveredComponentIds,
      completedProjectIds: completedProjectIds ?? this.completedProjectIds,
      projectStepBookmarks: projectStepBookmarks ?? this.projectStepBookmarks,
      solvedChallengeIds: solvedChallengeIds ?? this.solvedChallengeIds,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      quizBestScores: quizBestScores ?? this.quizBestScores,
      lastActivity: lastActivity ?? this.lastActivity,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }
}
