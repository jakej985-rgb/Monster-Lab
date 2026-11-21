import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../../domain/models/course_model.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  DifficultyTier? _selectedTier;

  final Set<String> _expandedCourseIds = {};
  bool _initializedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final curriculumRepo = ref.watch(curriculumRepositoryProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Lab',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveContentContainer(
        maxWidth: 1040,
        child: Column(
          children: [
            // Tier Filter Chips (Responsive Wrap - No side scrolling)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: colorScheme.surface,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTierChip(label: 'All Tiers', tier: null),
                  _buildTierChip(
                      label: 'Rookie (Beginner)', tier: DifficultyTier.rookie),
                  _buildTierChip(
                      label: 'Builder (Intermediate)',
                      tier: DifficultyTier.builder),
                  _buildTierChip(
                      label: 'Engineer (Advanced)',
                      tier: DifficultyTier.engineer),
                  _buildTierChip(
                      label: 'Master', tier: DifficultyTier.monsterMaster),
                ],
              ),
            ),
            const Divider(height: 1),

            // Lesson List with Course Folders
            Expanded(
              child: FutureBuilder<List<Lesson>>(
                future: curriculumRepo.getLessons(tier: _selectedTier),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lessons = snapshot.data!;

                  if (lessons.isEmpty) {
                    return const Center(
                      child: Text('No lessons found in this tier yet.'),
                    );
                  }

                  // Group lessons into courses and standalone missions
                  final courseLessonsMap = <String, List<Lesson>>{};
                  final standaloneLessons = <Lesson>[];

                  for (final lesson in lessons) {
                    if (lesson.courseId != null) {
                      courseLessonsMap
                          .putIfAbsent(lesson.courseId!, () => [])
                          .add(lesson);
                    } else {
                      standaloneLessons.add(lesson);
                    }
                  }

                  for (final list in courseLessonsMap.values) {
                    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
                  }

                  standaloneLessons.sort((a, b) => a.id.compareTo(b.id));

                  final courses = coursesAsync.value ?? const [];

                  // Initialize default expansion: expand active or incomplete courses
                  if (!_initializedExpanded && courses.isNotEmpty) {
                    for (final course in courses) {
                      final cLessons = courseLessonsMap[course.id] ?? [];
                      final isComplete = cLessons.isNotEmpty &&
                          cLessons.every((l) =>
                              activeProgress?.completedLessonIds
                                  .contains(l.id) ??
                              false);
                      if (!isComplete) {
                        _expandedCourseIds.add(course.id);
                        break;
                      }
                    }
                    // If all complete or none found, expand first course
                    if (_expandedCourseIds.isEmpty && courses.isNotEmpty) {
                      _expandedCourseIds.add(courses.first.id);
                    }
                    _initializedExpanded = true;
                  }

                  // Build organized items list
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // All 10 Course Folders
                      for (final course in courses) ...[
                        if (courseLessonsMap.containsKey(course.id)) ...[
                          _buildCourseFolderCard(
                            course: course,
                            lessons: courseLessonsMap[course.id]!,
                            activeProgress: activeProgress,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],

                      // Standalone Lessons 9 to 12
                      for (final l in standaloneLessons) ...[
                        _buildLessonCard(l, activeProgress),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseFolderCard({
    required CourseModel course,
    required List<Lesson> lessons,
    required LearnerProgressModel? activeProgress,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final courseId = course.id;
    final isExpanded = _expandedCourseIds.contains(courseId);
    final completedCount = lessons
        .where(
            (l) => activeProgress?.completedLessonIds.contains(l.id) ?? false)
        .length;
    final totalCount = lessons.length;
    final isAllComplete = completedCount == totalCount && totalCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAllComplete
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.primaryViolet.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Folder Header (Tap to expand/collapse)
          InkWell(
            key: Key('folder_header_$courseId'),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCourseIds.remove(courseId);
                } else {
                  _expandedCourseIds.add(courseId);
                }
              });
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(16),
              bottom: isExpanded ? Radius.zero : const Radius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isExpanded
                    ? AppColors.primaryViolet.withValues(alpha: 0.05)
                    : colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isAllComplete
                        ? AppColors.success
                        : AppColors.primaryViolet,
                    child: Icon(
                      isAllComplete
                          ? Icons.folder_special
                          : (isExpanded ? Icons.folder_open : Icons.folder),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryViolet
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'LESSON FOLDER',
                                style: TextStyle(
                                  color: AppColors.primaryViolet,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$completedCount / $totalCount Completed',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          course.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: totalCount > 0
                                ? completedCount / totalCount
                                : 0.0,
                            minHeight: 6,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isAllComplete
                                  ? AppColors.success
                                  : AppColors.energyAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.energyAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${course.xpReward} XP',
                          style: const TextStyle(
                            color: Color(0xFFD48806),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Sub-lessons List
          if (isExpanded) ...[
            const Divider(height: 1),
            Container(
              color: colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  for (final lesson in lessons) ...[
                    _buildLessonCard(lesson, activeProgress, isNested: true),
                    if (lesson != lessons.last) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, LearnerProgressModel? activeProgress,
      {bool isNested = false}) {
    final isCompleted =
        activeProgress?.completedLessonIds.contains(lesson.id) ?? false;

    // Prerequisite check: supports both lesson and course prerequisites
    final completedLessons =
        activeProgress?.completedLessonIds ?? const <String>{};
    final completedCourses =
        activeProgress?.completedCourseIds ?? const <String>{};
    final missingPrereqs = lesson.prerequisites
        .where(
          (req) =>
              !completedLessons.contains(req) &&
              !completedCourses.contains(req),
        )
        .toList();
    final isLocked = missingPrereqs.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return MonsterCard(
      color: isLocked
          ? colorScheme.surfaceContainerHighest
          : (isNested ? colorScheme.surface : null),
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Complete prerequisite (${missingPrereqs.join(", ")}) first!'),
                ),
              );
            }
          : () => context.push('/learn/${lesson.id}'),
      child: Row(
        children: [
          CircleAvatar(
            radius: isNested ? 18 : 22,
            backgroundColor: isCompleted
                ? AppColors.success
                : (isLocked ? colorScheme.outline : AppColors.primaryViolet),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : (isLocked ? Icons.lock : Icons.play_arrow),
              color: Colors.white,
              size: isNested ? 18 : 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _getTierColor(lesson.tier).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lesson.tier.name.toUpperCase(),
                        style: TextStyle(
                          color: _getTierColor(lesson.tier),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '⏱ ${lesson.estimatedMinutes} min',
                      style: TextStyle(
                          color: colorScheme.onSurfaceVariant, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isNested ? 14 : 15,
                    color: isLocked
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.energyAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${lesson.xpReward} XP',
              style: const TextStyle(
                color: Color(0xFFD48806),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierChip(
      {required String label, required DifficultyTier? tier}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedTier == tier;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
          color: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant),
      onSelected: (_) => setState(() => _selectedTier = tier),
    );
  }

  Color _getTierColor(DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.rookie:
        return AppColors.tierRookie;
      case DifficultyTier.builder:
        return AppColors.tierBuilder;
      case DifficultyTier.engineer:
        return AppColors.tierEngineer;
      case DifficultyTier.monsterMaster:
        return AppColors.tierMaster;
    }
  }
}
