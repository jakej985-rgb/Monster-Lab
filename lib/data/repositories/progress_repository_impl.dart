import 'dart:async';
import '../../domain/models/learner_progress_model.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_storage_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final LocalStorageDataSource _dataSource;
  final Map<String, Future<void>> _locks = {};

  ProgressRepositoryImpl(this._dataSource);

  Future<T> _synchronized<T>(
      String learnerId, Future<T> Function() action) async {
    final previous = _locks[learnerId];
    final completer = Completer<void>();
    _locks[learnerId] = completer.future;

    try {
      if (previous != null) {
        await previous.catchError((_) {});
      }
      return await action();
    } finally {
      completer.complete();
      if (_locks[learnerId] == completer.future) {
        _locks.remove(learnerId);
      }
    }
  }

  Future<LearnerProgressModel> _getProgressDirect(String learnerId) async {
    final raw = _dataSource.getProgress(learnerId);
    final migrated = LearnerProgressModel.migrateFromOldFormat(raw);
    if (raw != migrated) {
      await _dataSource.saveProgress(migrated);
    }
    return migrated;
  }

  @override
  Future<LearnerProgressModel> getProgress(String learnerId) {
    return _synchronized(learnerId, () => _getProgressDirect(learnerId));
  }

  @override
  Future<void> saveProgress(LearnerProgressModel progress) {
    return _synchronized(progress.learnerId, () async {
      await _dataSource.saveProgress(progress);
    });
  }

  @override
  Future<void> addXp(String learnerId, int xpAmount) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final updated = current.copyWith(
        totalXp: current.totalXp + xpAmount,
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeCourse(String learnerId, String courseId, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final isNew = !current.completedCourseIds.contains(courseId);
      final updatedCourses = Set<String>.from(current.completedCourseIds)
        ..add(courseId);
      final updated = current.copyWith(
        totalXp: isNew ? current.totalXp + xpReward : current.totalXp,
        completedCourseIds: updatedCourses,
        lastActivity: LastActivityInfo(
          type: ActivityType.lesson,
          activityId: courseId,
          title: 'Completed Course $courseId',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
      return isNew;
    });
  }

  @override
  Future<void> markPlacementPassed(String learnerId, String courseId) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final updatedPlacements =
          Set<String>.from(current.placementPassedCourseIds)..add(courseId);
      final updated = current.copyWith(
        placementPassedCourseIds: updatedPlacements,
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeLesson(String learnerId, String lessonId, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final isNew = !current.completedLessonIds.contains(lessonId);
      final updatedLessons = Set<String>.from(current.completedLessonIds)
        ..add(lessonId);
      final updated = current.copyWith(
        totalXp: isNew ? current.totalXp + xpReward : current.totalXp,
        completedLessonIds: updatedLessons,
        lastActivity: LastActivityInfo(
          type: ActivityType.lesson,
          activityId: lessonId,
          title: 'Completed Lesson $lessonId',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
      return isNew;
    });
  }

  @override
  Future<void> discoverComponent(String learnerId, String componentId,
      [int xpReward = 0]) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final isNew = !current.discoveredComponentIds.contains(componentId);
      final updatedComponents = Set<String>.from(current.discoveredComponentIds)
        ..add(componentId);
      final updated = current.copyWith(
        totalXp: isNew ? current.totalXp + xpReward : current.totalXp,
        discoveredComponentIds: updatedComponents,
        lastActivity: LastActivityInfo(
          type: ActivityType.component,
          activityId: componentId,
          title: 'Discovered Component $componentId',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<void> recordProjectPhase(
      String learnerId, String projectId, int phaseNumber) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final updatedBookmarks =
          Map<String, int>.from(current.projectStepBookmarks);
      final existing = updatedBookmarks[projectId] ?? 0;
      if (phaseNumber > existing) {
        updatedBookmarks[projectId] = phaseNumber;
      }
      final updated = current.copyWith(
        projectStepBookmarks: updatedBookmarks,
        lastActivity: LastActivityInfo(
          type: ActivityType.project,
          activityId: projectId,
          title: 'Project In Progress: Phase $phaseNumber',
          timestamp: DateTime.now(),
          stepNumber: phaseNumber,
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeProject(String learnerId, String projectId, int xpReward,
      [String? badgeId]) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final isNew = !current.completedProjectIds.contains(projectId);
      final updatedProjects = Set<String>.from(current.completedProjectIds)
        ..add(projectId);
      final updatedBadges = Set<String>.from(current.earnedBadgeIds);
      if (badgeId != null) {
        updatedBadges.add(badgeId);
      }
      final updated = current.copyWith(
        totalXp: isNew ? current.totalXp + xpReward : current.totalXp,
        completedProjectIds: updatedProjects,
        earnedBadgeIds: updatedBadges,
        lastActivity: LastActivityInfo(
          type: ActivityType.project,
          activityId: projectId,
          title: 'Completed Project $projectId',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
      return isNew;
    });
  }

  @override
  Future<bool> solveChallenge(
      String learnerId, String challengeId, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final isNew = !current.solvedChallengeIds.contains(challengeId);
      final updatedChallenges = Set<String>.from(current.solvedChallengeIds)
        ..add(challengeId);
      final updated = current.copyWith(
        totalXp: isNew ? current.totalXp + xpReward : current.totalXp,
        solvedChallengeIds: updatedChallenges,
        lastActivity: LastActivityInfo(
          type: ActivityType.challenge,
          activityId: challengeId,
          title: 'Solved Challenge $challengeId',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
      return isNew;
    });
  }

  @override
  Future<void> recordQuizScore(
      String learnerId, String quizId, int score, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final updatedScores = Map<String, int>.from(current.quizBestScores);
      final previousBest = updatedScores[quizId] ?? 0;

      // Only award XP if it is a new high score
      final addedXp = score > previousBest ? xpReward : 0;
      if (score > previousBest) {
        updatedScores[quizId] = score;
      }

      final updated = current.copyWith(
        totalXp: current.totalXp + addedXp,
        quizBestScores: updatedScores,
        lastActivity: LastActivityInfo(
          type: ActivityType.lesson,
          activityId: quizId,
          title: 'Quiz Checkpoint ($score%)',
          timestamp: DateTime.now(),
        ),
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<void> recordActivity(String learnerId, LastActivityInfo activity) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final updated = current.copyWith(
        lastActivity: activity,
        lastSessionDate: DateTime.now(),
      );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<void> resetProgress(String learnerId) {
    return _synchronized(learnerId, () async {
      final empty = LearnerProgressModel.empty(learnerId);
      await _dataSource.saveProgress(empty);
    });
  }
}
