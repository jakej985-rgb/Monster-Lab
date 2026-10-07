import '../../domain/models/lesson_model.dart';
import '../../domain/models/component_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/challenge_model.dart';
import '../../domain/repositories/curriculum_repository.dart';
import '../datasources/curriculum_data_engine.dart';

class CurriculumRepositoryImpl implements CurriculumRepository {
  final CurriculumDataEngine _engine;

  CurriculumRepositoryImpl(this._engine);

  @override
  Future<List<Lesson>> getLessons({DifficultyTier? tier}) {
    return _engine.getLessons(tier: tier);
  }

  @override
  Future<List<Lesson>> getLessonsOrdered() {
    return _engine.getLessonsOrdered();
  }

  @override
  Future<Lesson> getLessonById(String id) {
    return _engine.getLessonById(id);
  }

  @override
  Future<List<ComponentModel>> getComponents({String? category}) {
    return _engine.getComponents(category: category);
  }

  @override
  Future<ComponentModel> getComponentById(String id) {
    return _engine.getComponentById(id);
  }

  @override
  Future<List<ProjectModel>> getProjects({DifficultyTier? tier}) {
    return _engine.getProjects(tier: tier);
  }

  @override
  Future<ProjectModel> getProjectById(String id) {
    return _engine.getProjectById(id);
  }

  @override
  Future<List<ChallengeModel>> getChallenges({DifficultyTier? tier}) {
    return _engine.getChallenges(tier: tier);
  }

  @override
  Future<ChallengeModel> getChallengeById(String id) {
    return _engine.getChallengeById(id);
  }
}
