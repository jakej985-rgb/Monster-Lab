import '../../domain/models/learner_progress_model.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_storage_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final LocalStorageDataSource _dataSource;

  ProgressRepositoryImpl(this._dataSource);

  @override
  Future<LearnerProgressModel> getProgress(String learnerId) async {
    return _dataSource.getProgress(learnerId);
  }

  @override
  Future<void> saveProgress(LearnerProgressModel progress) async {
    await _dataSource.saveProgress(progress);
  }

  @override
  Future<void> addXp(String learnerId, int xpAmount) async {
    final current = _dataSource.getProgress(learnerId);
    final updated = current.copyWith(
      totalXp: current.totalXp + xpAmount,
      lastSessionDate: DateTime.now(),
    );
    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> completeLesson(
      String learnerId, String lessonId, int xpReward) async {
    final current = _dataSource.getProgress(learnerId);
    final updatedLessons = Set<String>.from(current.completedLessonIds)
      ..add(lessonId);
    final updated = current.copyWith(
      totalXp: current.totalXp + xpReward,
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
  }

  @override
  Future<void> discoverComponent(String learnerId, String componentId,
      [int xpReward = 0]) async {
    final current = _dataSource.getProgress(learnerId);
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
  }

  @override
  Future<void> recordProjectPhase(
      String learnerId, String projectId, int phaseNumber) async {
    final current = _dataSource.getProgress(learnerId);
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
  }

  @override
  Future<void> completeProject(String learnerId, String projectId, int xpReward,
      [String? badgeId]) async {
    final current = _dataSource.getProgress(learnerId);
    final updatedProjects = Set<String>.from(current.completedProjectIds)
      ..add(projectId);
    final updatedBadges = Set<String>.from(current.earnedBadgeIds);
    if (badgeId != null) {
      updatedBadges.add(badgeId);
    }
    final updated = current.copyWith(
      totalXp: current.totalXp + xpReward,
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
  }

  @override
  Future<void> solveChallenge(
      String learnerId, String challengeId, int xpReward) async {
    final current = _dataSource.getProgress(learnerId);
    final updatedChallenges = Set<String>.from(current.solvedChallengeIds)
      ..add(challengeId);
    final updated = current.copyWith(
      totalXp: current.totalXp + xpReward,
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
  }

  @override
  Future<void> recordQuizScore(
      String learnerId, String quizId, int score, int xpReward) async {
    final current = _dataSource.getProgress(learnerId);
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
  }

  @override
  Future<void> recordActivity(
      String learnerId, LastActivityInfo activity) async {
    final current = _dataSource.getProgress(learnerId);
    final updated = current.copyWith(
      lastActivity: activity,
      lastSessionDate: DateTime.now(),
    );
    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> resetProgress(String learnerId) async {
    final empty = LearnerProgressModel.empty(learnerId);
    await _dataSource.saveProgress(empty);
  }
}
