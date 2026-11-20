import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/route_constants.dart';
import '../../../domain/models/avatar_model.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';
import '../../shared/widgets/xp_progress_bar.dart';
import '../hardware/widgets/hardware_status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final avatar = MonsterAvatar.findById(activeProfile?.avatarId);

    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Semantics(
            button: true,
            label:
                'Switch profile. Current profile: ${activeProfile?.nickname ?? "Default"}',
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.push(RoutePaths.profileSelect),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: avatar.accentColor,
                  child: Icon(avatar.icon, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeProfile != null
                  ? 'Hello, ${activeProfile.nickname}!'
                  : 'Monster Lab',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (activeProgress != null)
              Text(
                'Level ${activeProgress.currentLevel} Explorer • Companion: ${avatar.name}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondaryLight),
              ),
          ],
        ),
        actions: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: HardwareStatusBadge(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Parent Mode',
            onPressed: () => context.push(RoutePaths.parentGate),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: ResponsiveContentContainer(
        maxWidth: 1040,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (activeProgress != null)
              XPProgressBar(
                totalXp: activeProgress.totalXp,
                currentLevel: activeProgress.currentLevel,
                progressRatio: activeProgress.levelProgressRatio,
              ),
            const SizedBox(height: 20),

            // Robot Companion Greeting
            MonsterCard(
              color: avatar.backgroundColor.withValues(alpha: 0.7),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: avatar.accentColor,
                    child: Icon(avatar.icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${avatar.name} says:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: avatar.accentColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCompanionGreeting(
                              activeProgress?.currentLevel ?? 1),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resume Learning Section
            const Text(
              'Continue Learning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildResumeCard(context, ref, activeProgress),

            const SizedBox(height: 24),

            // Progress Overview Stats Grid
            const Text(
              'Your Monster Lab Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.menu_book,
                    color: AppColors.primaryViolet,
                    label: 'Lessons Done',
                    value: '${activeProgress?.completedLessonIds.length ?? 0}',
                    onTap: () => context.go(RoutePaths.learn),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.extension,
                    color: AppColors.accentCyan,
                    label: 'Parts Found',
                    value:
                        '${activeProgress?.discoveredComponentIds.length ?? 0}',
                    onTap: () => context.go(RoutePaths.parts),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.precision_manufacturing,
                    color: AppColors.tierEngineer,
                    label: 'Projects Built',
                    value: '${activeProgress?.completedProjectIds.length ?? 0}',
                    onTap: () => context.go(RoutePaths.build),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.emoji_events,
                    color: AppColors.energyAmber,
                    label: 'Badges Won',
                    value: '${activeProgress?.earnedBadgeIds.length ?? 0}',
                    onTap: () => context.go(RoutePaths.progress),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Challenge Arena Quick Access
            MonsterCard(
              onTap: () => context.push(RoutePaths.challenges),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.tierMaster.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on,
                        color: AppColors.tierMaster, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Challenge Arena',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${activeProgress?.solvedChallengeIds.length ?? 0} challenges solved. Test your skills!',
                          style: const TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.primaryViolet),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Doctor Monster Clinic Quick Access
            MonsterCard(
              onTap: () => context.push(RoutePaths.troubleshoot),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.energyAmber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.healing,
                        color: AppColors.energyAmber, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Doctor Monster Clinic',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Circuit glitching? Debug hardware & code step-by-step!',
                          style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.primaryViolet),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Hardware Companion Quick Access
            MonsterCard(
              key: const Key('home_hardware_companion_card'),
              onTap: () => context.push(RoutePaths.hardware),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.developer_board,
                        color: AppColors.accentCyanDark, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hardware Companion',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Connect Arduino or Virtual Simulator. Test live serial & pins!',
                          style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.primaryViolet),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Interactive Wiring & Code Lab Quick Access
            MonsterCard(
              key: const Key('home_interactive_lab_card'),
              onTap: () => context.push(RoutePaths.interactiveLab),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryViolet.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.science,
                        color: AppColors.primaryViolet, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interactive Wiring & Code Lab',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Virtual breadboard wiring & live code experiments before physical build!',
                          style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppColors.primaryViolet),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getCompanionGreeting(int level) {
    if (level == 1) {
      return 'Ready to build your first circuit? Let’s jump into Lesson 1!';
    } else if (level < 5) {
      return 'You are becoming a real hardware builder! Keep collecting XP!';
    } else {
      return 'Impressive engineering skills! The Monster Lab is proud of you!';
    }
  }

  Widget _buildResumeCard(
      BuildContext context, WidgetRef ref, LearnerProgressModel? progress) {
    final nextLessonAsync = ref.watch(nextLessonProvider);

    return nextLessonAsync.when(
      loading: () => const MonsterCard(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'Loading your next adventure...',
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
      error: (err, _) => MonsterCard(
        child: Text('Unable to load lesson progress: $err'),
      ),
      data: (nextLesson) {
        if (nextLesson == null) {
          // All lessons completed - Celebration Card!
          return MonsterCard(
            key: const Key('home_curriculum_completed_card'),
            color: AppColors.tierMaster.withValues(alpha: 0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tierMaster,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'CURRICULUM COMPLETE!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const Icon(Icons.emoji_events,
                        color: AppColors.tierMaster, size: 24),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'All Lessons Completed! 🏆',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Outstanding work, Monster Master! You have mastered all 12 lessons in the lab curriculum.',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                MonsterButton(
                  label: 'Explore Projects in Build Lab',
                  icon: Icons.handyman,
                  onPressed: () => context.go(RoutePaths.build),
                ),
              ],
            ),
          );
        }

        final hasCompletedAny =
            progress != null && progress.completedLessonIds.isNotEmpty;
        final lessonNumber =
            int.tryParse(nextLesson.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

        return MonsterCard(
          key: Key('home_next_lesson_card_${nextLesson.id}'),
          onTap: () => context.push('/learn/${nextLesson.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (hasCompletedAny
                              ? AppColors.primaryViolet
                              : AppColors.tierRookie)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hasCompletedAny ? 'UP NEXT' : 'START HERE',
                      style: TextStyle(
                        color: hasCompletedAny
                            ? AppColors.primaryViolet
                            : AppColors.tierRookie,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    '⏱ ${nextLesson.estimatedMinutes} min',
                    style: const TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                nextLesson.courseId != null
                    ? nextLesson.title
                    : 'Lesson $lessonNumber: ${nextLesson.title}',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                nextLesson.summary,
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              MonsterButton(
                label: nextLesson.courseId != null
                    ? 'Start Lesson'
                    : 'Start Lesson $lessonNumber',
                icon: Icons.rocket_launch,
                onPressed: () => context.push('/learn/${nextLesson.id}'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return MonsterCard(
      mergeSemantics: true,
      semanticLabel: '$label: $value',
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
