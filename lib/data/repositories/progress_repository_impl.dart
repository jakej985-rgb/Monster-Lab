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
  Future<void> addXp(String learnerId, int xpAmount, [String? transactionId]) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey =
          transactionId ?? 'tx_xp_${DateTime.now().microsecondsSinceEpoch}';
      if (current.processedTransactionIds.contains(txKey)) {
        return; // Idempotent: already processed
      }

      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.xpAdded,
        learnerId: learnerId,
        activityId: 'custom_xp',
        timestamp: DateTime.now(),
        xpAwarded: xpAmount,
      );

      final updated = current.applyEvent(event);
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeCourse(String learnerId, String courseId, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey = 'tx_course_$courseId';
      if (current.processedTransactionIds.contains(txKey)) {
        return false; // Idempotent: course already completed
      }

      final isNew = !current.completedCourseIds.contains(courseId);
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.courseCompleted,
        learnerId: learnerId,
        activityId: courseId,
        timestamp: DateTime.now(),
        xpAwarded: isNew ? xpReward : 0,
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.lesson,
              activityId: courseId,
              title: 'Completed Course $courseId',
              timestamp: DateTime.now(),
            ),
          );
      await _dataSource.saveProgress(updated);
      return isNew;
    });
  }

  @override
  Future<void> markPlacementPassed(String learnerId, String courseId) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey = 'tx_placement_$courseId';
      if (current.processedTransactionIds.contains(txKey)) {
        return; // Idempotent
      }

      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.placementPassed,
        learnerId: learnerId,
        activityId: courseId,
        timestamp: DateTime.now(),
      );

      final updated = current.applyEvent(event);
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeLesson(String learnerId, String lessonId, int xpReward) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey = 'tx_lesson_$lessonId';
      if (current.processedTransactionIds.contains(txKey)) {
        return false; // Idempotent: lesson already completed
      }

      final isNew = !current.completedLessonIds.contains(lessonId);
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.lessonCompleted,
        learnerId: learnerId,
        activityId: lessonId,
        timestamp: DateTime.now(),
        xpAwarded: isNew ? xpReward : 0,
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.lesson,
              activityId: lessonId,
              title: 'Completed Lesson $lessonId',
              timestamp: DateTime.now(),
            ),
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
      final txKey = 'tx_comp_$componentId';
      if (current.processedTransactionIds.contains(txKey)) {
        return; // Idempotent
      }

      final isNew = !current.discoveredComponentIds.contains(componentId);
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.componentDiscovered,
        learnerId: learnerId,
        activityId: componentId,
        timestamp: DateTime.now(),
        xpAwarded: isNew ? xpReward : 0,
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.component,
              activityId: componentId,
              title: 'Discovered Component $componentId',
              timestamp: DateTime.now(),
            ),
          );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<void> recordProjectPhase(
      String learnerId, String projectId, int phaseNumber) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey = 'tx_proj_${projectId}_phase_$phaseNumber';
      if (current.processedTransactionIds.contains(txKey)) {
        return; // Idempotent
      }

      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.projectStepBookmarked,
        learnerId: learnerId,
        activityId: projectId,
        timestamp: DateTime.now(),
        metadata: {'stepNumber': phaseNumber},
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.project,
              activityId: projectId,
              title: 'Project In Progress: Phase $phaseNumber',
              timestamp: DateTime.now(),
              stepNumber: phaseNumber,
            ),
          );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<bool> completeProject(String learnerId, String projectId, int xpReward,
      [String? badgeId]) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final txKey = 'tx_proj_$projectId';
      if (current.processedTransactionIds.contains(txKey)) {
        return false; // Idempotent
      }

      final isNew = !current.completedProjectIds.contains(projectId);
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.projectCompleted,
        learnerId: learnerId,
        activityId: projectId,
        timestamp: DateTime.now(),
        xpAwarded: isNew ? xpReward : 0,
        metadata: badgeId != null ? {'badgeId': badgeId} : const {},
      );

      var updated = current.applyEvent(event);
      if (badgeId != null) {
        final badgeTx = 'tx_badge_$badgeId';
        final badgeEvent = LearnerProgressEvent(
          eventId: badgeTx,
          eventType: ProgressEventType.badgeEarned,
          learnerId: learnerId,
          activityId: badgeId,
          timestamp: DateTime.now(),
        );
        updated = updated.applyEvent(badgeEvent);
      }

      updated = updated.copyWith(
        lastActivity: LastActivityInfo(
          type: ActivityType.project,
          activityId: projectId,
          title: 'Completed Project $projectId',
          timestamp: DateTime.now(),
        ),
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
      final txKey = 'tx_chal_$challengeId';
      if (current.processedTransactionIds.contains(txKey)) {
        return false; // Idempotent
      }

      final isNew = !current.solvedChallengeIds.contains(challengeId);
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.challengeSolved,
        learnerId: learnerId,
        activityId: challengeId,
        timestamp: DateTime.now(),
        xpAwarded: isNew ? xpReward : 0,
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.challenge,
              activityId: challengeId,
              title: 'Solved Challenge $challengeId',
              timestamp: DateTime.now(),
            ),
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
      final txKey = 'tx_quiz_${quizId}_score_$score';
      if (current.processedTransactionIds.contains(txKey)) {
        return; // Idempotent
      }

      final previousBest = current.quizBestScores[quizId] ?? 0;
      final addedXp = score > previousBest ? xpReward : 0;
      final event = LearnerProgressEvent(
        eventId: txKey,
        eventType: ProgressEventType.quizScoreRecorded,
        learnerId: learnerId,
        activityId: quizId,
        timestamp: DateTime.now(),
        xpAwarded: addedXp,
        metadata: {'score': score, 'previousBest': previousBest},
      );

      final updated = current.applyEvent(event).copyWith(
            lastActivity: LastActivityInfo(
              type: ActivityType.lesson,
              activityId: quizId,
              title: 'Quiz Checkpoint ($score%)',
              timestamp: DateTime.now(),
            ),
          );
      await _dataSource.saveProgress(updated);
    });
  }

  @override
  Future<void> recordQuickCheckResult(
      String learnerId, QuickCheckResult result) {
    return _synchronized(learnerId, () async {
      final current = await _getProgressDirect(learnerId);
      final key = '${result.lessonId}_${result.submoduleId}';
      final updatedResults =
          Map<String, QuickCheckResult>.from(current.quickCheckResults)
            ..[key] = result;
      final updated = current.copyWith(
        quickCheckResults: updatedResults,
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
