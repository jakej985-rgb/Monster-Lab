import '../models/learner_progress_model.dart';

abstract class ProgressRepository {
  Future<LearnerProgressModel> getProgress(String learnerId);
  Future<void> saveProgress(LearnerProgressModel progress);
  Future<void> addXp(String learnerId, int xpAmount);
  Future<bool> completeLesson(String learnerId, String lessonId, int xpReward);
  Future<void> discoverComponent(String learnerId, String componentId,
      [int xpReward = 0]);
  Future<void> recordProjectPhase(
      String learnerId, String projectId, int phaseNumber);
  Future<bool> completeProject(String learnerId, String projectId, int xpReward,
      [String? badgeId]);
  Future<bool> solveChallenge(
      String learnerId, String challengeId, int xpReward);
  Future<void> recordQuizScore(
      String learnerId, String quizId, int score, int xpReward);
  Future<void> recordActivity(String learnerId, LastActivityInfo activity);
  Future<void> resetProgress(String learnerId);
}
