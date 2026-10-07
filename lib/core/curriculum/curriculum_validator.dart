import '../../domain/models/lesson_model.dart';
import '../../domain/models/component_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/challenge_model.dart';
import '../../domain/models/badge_model.dart';

class CurriculumValidationException implements Exception {
  final String entityId;
  final String entityType;
  final String message;
  final List<String> details;

  const CurriculumValidationException({
    required this.entityId,
    required this.entityType,
    required this.message,
    this.details = const [],
  });

  @override
  String toString() {
    final buffer = StringBuffer(
        'CurriculumValidationException [$entityType:$entityId]: $message');
    for (final detail in details) {
      buffer.write('\n  - $detail');
    }
    return buffer.toString();
  }
}

class CurriculumValidator {
  static final RegExp _lessonIdPattern =
      RegExp(r'^(lesson_[0-9]{2,3}|cf_[0-9]{2}|l2a_[0-9]{2}|l2b_[0-9]{2})$');
  static final RegExp _componentIdPattern = RegExp(r'^comp_[a-z0-9_]+$');
  static final RegExp _projectIdPattern = RegExp(r'^proj_[0-9]{2}$');
  static final RegExp _challengeIdPattern = RegExp(r'^chal_[a-z0-9_]+$');

  /// Validates a single lesson
  static void validateLesson(Lesson lesson) {
    final errors = <String>[];

    if (!_lessonIdPattern.hasMatch(lesson.id)) {
      errors.add(
          "Lesson ID '${lesson.id}' does not match pattern '^lesson_[0-9]{2,3}\$'");
    }
    if (lesson.title.trim().length < 3) {
      errors.add("Lesson title must be at least 3 characters");
    }
    if (lesson.summary.trim().isEmpty) {
      errors.add("Lesson summary cannot be empty");
    }
    if (lesson.estimatedMinutes < 5 || lesson.estimatedMinutes > 120) {
      errors.add(
          "estimatedMinutes must be between 5 and 120 (got ${lesson.estimatedMinutes})");
    }
    if (lesson.steps.isEmpty) {
      errors.add("Lesson must contain at least 1 step");
    }
    for (var i = 0; i < lesson.steps.length; i++) {
      final s = lesson.steps[i];
      if (s.stepId.trim().isEmpty) {
        errors.add("Step at index $i is missing stepId");
      }
      if (s.title.trim().isEmpty) {
        errors.add("Step '${s.stepId}' is missing title");
      }
      if (s.markdownContent.trim().isEmpty) {
        errors.add("Step '${s.stepId}' is missing markdownContent");
      }
    }
    if (lesson.xpReward < 10) {
      errors.add("xpReward must be at least 10 (got ${lesson.xpReward})");
    }

    if (errors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: lesson.id,
        entityType: 'Lesson',
        message: 'Lesson failed validation constraints',
        details: errors,
      );
    }
  }

  /// Validates a single component
  static void validateComponent(ComponentModel component) {
    final errors = <String>[];

    if (!_componentIdPattern.hasMatch(component.id)) {
      errors.add(
          "Component ID '${component.id}' does not match pattern '^comp_[a-z0-9_]+\$'");
    }
    if (component.peripheralNumber < 1 || component.peripheralNumber > 100) {
      errors.add(
          "peripheralNumber must be between 1 and 100 (got ${component.peripheralNumber})");
    }
    if (component.name.trim().length < 2) {
      errors.add("Component name must be at least 2 characters");
    }
    if (component.partNumber.trim().isEmpty) {
      errors.add("Component partNumber cannot be empty");
    }
    if (component.description.trim().isEmpty) {
      errors.add("Component description cannot be empty");
    }
    if (component.realWorldAnalogy.trim().isEmpty) {
      errors.add("Component realWorldAnalogy cannot be empty");
    }
    for (final p in component.pinout) {
      if (p.pinName.trim().isEmpty) {
        errors.add("Pin definition is missing pinName");
      }
      if (p.description.trim().isEmpty) {
        errors.add("Pin '${p.pinName}' is missing description");
      }
    }
    if (component.primaryImage != null &&
        component.primaryImage!.trim().isEmpty) {
      errors.add("Component primaryImage cannot be empty string");
    }
    for (final detail in component.detailImages) {
      if (detail.trim().isEmpty) {
        errors.add("Component detailImages item cannot be empty string");
      }
    }

    if (errors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: component.id,
        entityType: 'Component',
        message: 'Component failed validation constraints',
        details: errors,
      );
    }
  }

  /// Validates a single project
  static void validateProject(ProjectModel project) {
    final errors = <String>[];

    if (!_projectIdPattern.hasMatch(project.id)) {
      errors.add(
          "Project ID '${project.id}' does not match pattern '^proj_[0-9]{2}\$'");
    }
    if (project.title.trim().length < 3) {
      errors.add("Project title must be at least 3 characters");
    }
    if (project.tagline.trim().isEmpty) {
      errors.add("Project tagline cannot be empty");
    }
    if (project.estimatedMinutes < 15 || project.estimatedMinutes > 180) {
      errors.add(
          "estimatedMinutes must be between 15 and 180 (got ${project.estimatedMinutes})");
    }
    if (project.phases.length < 2) {
      errors.add(
          "Project must contain at least 2 phases (got ${project.phases.length})");
    }
    for (final phase in project.phases) {
      if (phase.phaseTitle.trim().isEmpty) {
        errors.add("Phase ${phase.phaseNumber} is missing phaseTitle");
      }
      if (phase.instructions.trim().isEmpty) {
        errors.add("Phase ${phase.phaseNumber} is missing instructions");
      }
    }
    if (project.xpReward < 50) {
      errors.add("xpReward must be at least 50 (got ${project.xpReward})");
    }

    if (errors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: project.id,
        entityType: 'Project',
        message: 'Project failed validation constraints',
        details: errors,
      );
    }
  }

  /// Validates a single challenge
  static void validateChallenge(ChallengeModel challenge) {
    final errors = <String>[];

    if (!_challengeIdPattern.hasMatch(challenge.id)) {
      errors.add(
          "Challenge ID '${challenge.id}' does not match pattern '^chal_[a-z0-9_]+\$'");
    }
    if (challenge.title.trim().length < 3) {
      errors.add("Challenge title must be at least 3 characters");
    }
    if (challenge.prompt.trim().isEmpty) {
      errors.add("Challenge prompt cannot be empty");
    }
    if (challenge.hint.trim().isEmpty) {
      errors.add("Challenge hint cannot be empty");
    }
    if (challenge.xpAward < 25) {
      errors.add("xpAward must be at least 25 (got ${challenge.xpAward})");
    }

    if (errors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: challenge.id,
        entityType: 'Challenge',
        message: 'Challenge failed validation constraints',
        details: errors,
      );
    }
  }

  /// Validates a single badge
  static void validateBadge(BadgeModel badge) {
    final errors = <String>[];

    if (badge.id.trim().isEmpty) {
      errors.add("Badge ID cannot be empty");
    }
    if (badge.name.trim().isEmpty) {
      errors.add("Badge name cannot be empty");
    }
    if (badge.description.trim().isEmpty) {
      errors.add("Badge description cannot be empty");
    }
    if (badge.iconAsset.trim().isEmpty) {
      errors.add("Badge iconAsset cannot be empty");
    }
    if (badge.xpBonus < 0) {
      errors.add("Badge xpBonus cannot be negative");
    }

    if (errors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: badge.id,
        entityType: 'Badge',
        message: 'Badge failed validation constraints',
        details: errors,
      );
    }
  }

  /// Validates entire curriculum collection and cross-referential integrity
  static void validateCurriculumIntegrity({
    required List<Lesson> lessons,
    required List<ComponentModel> components,
    required List<ProjectModel> projects,
    required List<ChallengeModel> challenges,
    required List<BadgeModel> badges,
  }) {
    final lessonMap = {for (final l in lessons) l.id: l};
    final componentMap = {for (final c in components) c.id: c};
    final projectMap = {for (final p in projects) p.id: p};
    final badgeMap = {for (final b in badges) b.id: b};

    final referentialErrors = <String>[];

    // Check Lessons
    for (final lesson in lessons) {
      validateLesson(lesson);
      for (final prereq in lesson.prerequisites) {
        if (!lessonMap.containsKey(prereq)) {
          referentialErrors
              .add("Lesson '${lesson.id}' has missing prerequisite '$prereq'");
        }
      }
      for (final cid in lesson.componentIds) {
        if (!componentMap.containsKey(cid)) {
          referentialErrors
              .add("Lesson '${lesson.id}' references missing component '$cid'");
        }
      }
    }

    // Check Components
    for (final component in components) {
      validateComponent(component);
      for (final pid in component.projectIds) {
        if (!projectMap.containsKey(pid)) {
          referentialErrors.add(
              "Component '${component.id}' references missing project '$pid'");
        }
      }
    }

    // Check Projects
    for (final project in projects) {
      validateProject(project);
      for (final reqC in project.requiredComponents) {
        if (!componentMap.containsKey(reqC)) {
          referentialErrors.add(
              "Project '${project.id}' references missing required component '$reqC'");
        }
      }
      for (final prereqL in project.prerequisiteLessons) {
        if (!lessonMap.containsKey(prereqL)) {
          referentialErrors.add(
              "Project '${project.id}' references missing prerequisite lesson '$prereqL'");
        }
      }
      if (project.badgeRewardId != null && project.badgeRewardId!.isNotEmpty) {
        if (!badgeMap.containsKey(project.badgeRewardId)) {
          referentialErrors.add(
              "Project '${project.id}' references missing badge '${project.badgeRewardId}'");
        }
      }
    }

    // Check Challenges
    for (final challenge in challenges) {
      validateChallenge(challenge);
    }

    // Check Badges
    for (final badge in badges) {
      validateBadge(badge);
    }

    if (referentialErrors.isNotEmpty) {
      throw CurriculumValidationException(
        entityId: 'ALL',
        entityType: 'CurriculumBundle',
        message: 'Referential integrity check failed',
        details: referentialErrors,
      );
    }
  }
}
