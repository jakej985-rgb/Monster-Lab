import '../models/lesson_model.dart';
import '../models/component_model.dart';
import '../models/project_model.dart';
import '../models/challenge_model.dart';

abstract class CurriculumRepository {
  Future<List<Lesson>> getLessons({DifficultyTier? tier});
  Future<Lesson> getLessonById(String id);
  Future<List<ComponentModel>> getComponents({String? category});
  Future<ComponentModel> getComponentById(String id);
  Future<List<ProjectModel>> getProjects({DifficultyTier? tier});
  Future<ProjectModel> getProjectById(String id);
  Future<List<ChallengeModel>> getChallenges({DifficultyTier? tier});
  Future<ChallengeModel> getChallengeById(String id);
}
