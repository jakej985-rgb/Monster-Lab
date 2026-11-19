import '../../domain/models/course_model.dart';
import '../../domain/models/lesson_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/learner_progress_model.dart';

enum RecommendationType {
  lesson,
  project,
  challenge,
}

class LessonRecommendation {
  final RecommendationType type;
  final String targetId;
  final String title;
  final String reason;
  final List<String> satisfiedPrerequisites;
  final int estimatedMinutes;
  final int xpReward;

  const LessonRecommendation({
    required this.type,
    required this.targetId,
    required this.title,
    required this.reason,
    required this.satisfiedPrerequisites,
    required this.estimatedMinutes,
    required this.xpReward,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'targetId': targetId,
        'title': title,
        'reason': reason,
        'satisfiedPrerequisites': satisfiedPrerequisites,
        'estimatedMinutes': estimatedMinutes,
        'xpReward': xpReward,
      };
}

class AdaptiveRecommendationService {
  /// Recommends the next optimal, safe learning activity without prerequisite bypass
  static LessonRecommendation recommendNextActivity({
    required LearnerProgressModel progress,
    required List<CourseModel> courses,
    required List<Lesson> allLessons,
    List<ProjectModel> projects = const [],
  }) {
    // 1. Look for uncompleted lessons in the active/first available course
    for (final course in courses) {
      final courseLessons = allLessons
          .where((l) => course.lessonIds.contains(l.id))
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      for (final lesson in courseLessons) {
        if (!progress.completedLessonIds.contains(lesson.id)) {
          // Verify prerequisites are strictly met
          final prereqsMet = lesson.prerequisites.every((p) =>
              progress.completedLessonIds.contains(p) ||
              progress.completedCourseIds.contains(p));

          if (prereqsMet) {
            String explanation;
            if (lesson.sortOrder == 1) {
              explanation =
                  "Ready to start '${course.title}'! Dive in with the foundational introduction.";
            } else {
              final priorLesson = courseLessons.firstWhere(
                (l) => l.sortOrder == lesson.sortOrder - 1,
                orElse: () => lesson,
              );
              explanation =
                  "Because you completed '${priorLesson.title}', you are ready for '${lesson.title}'.";
            }

            return LessonRecommendation(
              type: RecommendationType.lesson,
              targetId: lesson.id,
              title: lesson.title,
              reason: explanation,
              satisfiedPrerequisites: lesson.prerequisites,
              estimatedMinutes: lesson.estimatedMinutes,
              xpReward: lesson.xpReward,
            );
          }
        }
      }

      // If all lessons in course are completed, check if capstone project is pending
      if (courseLessons.isNotEmpty &&
          courseLessons
              .every((l) => progress.completedLessonIds.contains(l.id))) {
        final relatedProjects = projects.where((p) =>
            p.prerequisiteLessons.any((l) => course.lessonIds.contains(l)) &&
            !progress.completedProjectIds.contains(p.id));

        if (relatedProjects.isNotEmpty) {
          final nextProject = relatedProjects.first;
          return LessonRecommendation(
            type: RecommendationType.project,
            targetId: nextProject.id,
            title: nextProject.title,
            reason:
                "You completed all lessons in '${course.title}'! Put your skills into action with the hands-on project '${nextProject.title}'.",
            satisfiedPrerequisites: nextProject.prerequisiteLessons,
            estimatedMinutes: nextProject.estimatedMinutes,
            xpReward: nextProject.xpReward,
          );
        }
      }
    }

    // Default fallback: Capstone / Graduation
    return const LessonRecommendation(
      type: RecommendationType.lesson,
      targetId: 'all_completed',
      title: 'Monster Lab Grand Master',
      reason:
          'Incredible achievement! You have mastered all available curriculum courses and projects.',
      satisfiedPrerequisites: [],
      estimatedMinutes: 0,
      xpReward: 0,
    );
  }
}
