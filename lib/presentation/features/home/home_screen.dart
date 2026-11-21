import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/route_constants.dart';
import '../../../domain/models/avatar_model.dart';
import '../../../domain/models/learner_profile_model.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';
import '../../shared/widgets/xp_progress_bar.dart';
import '../hardware/widgets/hardware_status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const double _sideRailBreakpoint = 1000.0;
  static const double _sideRailWidth = 300.0;
  static const double _compactHeightBreakpoint = 700.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final avatar = MonsterAvatar.findById(activeProfile?.avatarId);

    return Scaffold(
      appBar: _buildAppBar(
        context,
        ref,
        activeProfile: activeProfile,
        activeProgress: activeProgress,
        avatar: avatar,
        colorScheme: colorScheme,
      ),
      body: ResponsiveContentContainer(
        maxWidth: 1280,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportHeight =
                constraints.hasBoundedHeight ? constraints.maxHeight : 0.0;
            // The desktop shell adds a menu bar and status bar above this body.
            // Use a denser layout on short viewports so Home does not need a
            // page scroll at common 720p and 768p window sizes.
            final isCompact =
                viewportHeight > 0 && viewportHeight < _compactHeightBreakpoint;
            final verticalPadding = isCompact ? 8.0 : 16.0;
            final minHeight = viewportHeight > verticalPadding * 2
                ? viewportHeight - verticalPadding * 2
                : 0.0;
            final mainColumn = _buildMainColumn(
              context,
              ref,
              activeProgress: activeProgress,
              avatar: avatar,
              compact: isCompact,
            );
            final sideRail = _buildSideRail(
              context,
              ref,
              activeProgress: activeProgress,
              compact: isCompact,
            );

            return SingleChildScrollView(
              key: const Key('home_dashboard_scroll'),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: constraints.maxWidth >= _sideRailBreakpoint
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: mainColumn),
                          const SizedBox(width: 16),
                          SizedBox(width: _sideRailWidth, child: sideRail),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          mainColumn,
                          SizedBox(height: isCompact ? 12 : 16),
                          sideRail,
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref, {
    required LearnerProfileModel? activeProfile,
    required LearnerProgressModel? activeProgress,
    required MonsterAvatar avatar,
    required ColorScheme colorScheme,
  }) {
    return AppBar(
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
              style:
                  TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
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
    );
  }

  Widget _buildMainColumn(
    BuildContext context,
    WidgetRef ref, {
    required LearnerProgressModel? activeProgress,
    required MonsterAvatar avatar,
    required bool compact,
  }) {
    final sectionGap = compact ? 12.0 : 20.0;
    return Column(
      key: const Key('home_dashboard_main_column'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (activeProgress != null)
          XPProgressBar(
            totalXp: activeProgress.totalXp,
            currentLevel: activeProgress.currentLevel,
            progressRatio: activeProgress.levelProgressRatio,
          ),
        SizedBox(height: compact ? 10 : 16),

        // Robot Companion Greeting
        MonsterCard(
          color: avatar.backgroundColor.withValues(alpha: 0.7),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: avatar.accentColor,
                child: Icon(avatar.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 3),
                    Text(
                      _getCompanionGreeting(activeProgress?.currentLevel ?? 1),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: sectionGap),

        // Resume Learning Section
        const Text(
          'Continue Learning',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: compact ? 6 : 8),
        _buildResumeCard(context, ref, activeProgress),

        SizedBox(height: sectionGap),

        // Progress Overview Stats Grid
        const Text(
          'Your Monster Lab Stats',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: compact ? 6 : 8),
        _buildStatsGrid(context, activeProgress, compact: compact),
      ],
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    LearnerProgressModel? activeProgress, {
    required bool compact,
  }) {
    final stats = [
      _buildStatCard(
        context: context,
        icon: Icons.menu_book,
        color: AppColors.primaryViolet,
        label: 'Lessons Done',
        value: '${activeProgress?.completedLessonIds.length ?? 0}',
        compact: compact,
        onTap: () => context.go(RoutePaths.learn),
      ),
      _buildStatCard(
        context: context,
        icon: Icons.extension,
        color: AppColors.accentCyan,
        label: 'Parts Found',
        value: '${activeProgress?.discoveredComponentIds.length ?? 0}',
        compact: compact,
        onTap: () => context.go(RoutePaths.parts),
      ),
      _buildStatCard(
        context: context,
        icon: Icons.precision_manufacturing,
        color: AppColors.tierEngineer,
        label: 'Projects Built',
        value: '${activeProgress?.completedProjectIds.length ?? 0}',
        compact: compact,
        onTap: () => context.go(RoutePaths.build),
      ),
      _buildStatCard(
        context: context,
        icon: Icons.emoji_events,
        color: AppColors.energyAmber,
        label: 'Badges Won',
        value: '${activeProgress?.earnedBadgeIds.length ?? 0}',
        compact: compact,
        onTap: () => context.go(RoutePaths.progress),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: stats[i]),
              ],
            ],
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: stats[0]),
                const SizedBox(width: 12),
                Expanded(child: stats[1]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: stats[2]),
                const SizedBox(width: 12),
                Expanded(child: stats[3]),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideRail(
    BuildContext context,
    WidgetRef ref, {
    required LearnerProgressModel? activeProgress,
    required bool compact,
  }) {
    return Column(
      key: const Key('home_dashboard_side_rail'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAchievementsCard(context, activeProgress, compact: compact),
        SizedBox(height: compact ? 8 : 10),
        _buildNotificationsCard(context, ref, activeProgress),
        SizedBox(height: compact ? 8 : 10),
        _buildQuickActionsCard(context),
      ],
    );
  }

  Widget _buildAchievementsCard(
    BuildContext context,
    LearnerProgressModel? activeProgress, {
    required bool compact,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final earned = activeProgress?.earnedBadgeIds.length ?? 0;
    final hasBadges = earned > 0;
    final badgeLabel = earned == 1 ? '1 badge earned' : '$earned badges earned';

    if (compact) {
      return MonsterCard(
        key: const Key('home_achievements_card'),
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.energyAmber,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achievements',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    hasBadges ? badgeLabel : 'First badge waiting',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.go(RoutePaths.progress),
              tooltip: 'View all achievements',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: const Icon(Icons.chevron_right, size: 20),
            ),
          ],
        ),
      );
    }

    return MonsterCard(
      key: const Key('home_achievements_card'),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.energyAmber,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Achievements',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.progress),
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity.standard,
                ),
                child: const Text('View all', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.energyAmber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasBadges ? Icons.military_tech : Icons.lock_outline,
                  color: hasBadges
                      ? AppColors.energyAmber
                      : colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasBadges ? badgeLabel : 'First badge waiting',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasBadges
                          ? 'Keep experimenting to unlock more.'
                          : 'Finish a lesson to unlock First Circuit Scout.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(
    BuildContext context,
    WidgetRef ref,
    LearnerProgressModel? activeProgress,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final nextLessonAsync = ref.watch(nextLessonProvider);
    final nextLesson = nextLessonAsync.asData?.value;
    final earned = activeProgress?.earnedBadgeIds.length ?? 0;

    late final String nextTitle;
    late final String nextSubtitle;
    VoidCallback? nextTap;

    if (nextLessonAsync.isLoading) {
      nextTitle = 'Checking your progress';
      nextSubtitle = 'Loading your next lesson';
    } else if (nextLessonAsync.hasError) {
      nextTitle = 'Progress unavailable';
      nextSubtitle = 'Open the Learn tab to continue';
      nextTap = () => context.go(RoutePaths.learn);
    } else if (nextLesson != null) {
      nextTitle = 'Next lesson ready';
      nextSubtitle = 'Continue your learning path';
      nextTap = () => context.push('/learn/${nextLesson.id}');
    } else {
      nextTitle = 'Curriculum complete';
      nextSubtitle = 'Explore projects in the Build Lab';
      nextTap = () => context.go(RoutePaths.build);
    }

    return MonsterCard(
      key: const Key('home_notifications_card'),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primaryViolet,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          _buildNotificationTile(
            context,
            icon: Icons.play_circle_outline_rounded,
            color: AppColors.primaryViolet,
            title: nextTitle,
            subtitle: nextSubtitle,
            onTap: nextTap,
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          _buildNotificationTile(
            context,
            icon: Icons.emoji_events_outlined,
            color: AppColors.energyAmber,
            title: earned > 0 ? 'Badge collection' : 'First badge waiting',
            subtitle: earned > 0
                ? (earned == 1
                    ? '1 badge earned — view your collection'
                    : '$earned badges earned — view your collection')
                : 'Complete a lesson to earn one',
            onTap: () => context.go(RoutePaths.progress),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          _buildNotificationTile(
            context,
            icon: Icons.developer_board_outlined,
            color: AppColors.accentCyanDark,
            title: 'Hardware Companion',
            subtitle: 'Connect Arduino or use the simulator',
            onTap: () => context.push(RoutePaths.hardware),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: content,
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return MonsterCard(
      key: const Key('home_quick_actions_card'),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(
                  icon: Icons.flash_on,
                  color: AppColors.tierMaster,
                  label: 'Challenge Arena',
                  tooltip: 'Challenge Arena',
                  onTap: () => context.push(RoutePaths.challenges),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionTile(
                  icon: Icons.healing,
                  color: AppColors.energyAmber,
                  label: 'Doctor Clinic',
                  tooltip: 'Doctor Monster Clinic',
                  onTap: () => context.push(RoutePaths.troubleshoot),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(
                  key: const Key('home_hardware_companion_card'),
                  icon: Icons.developer_board,
                  color: AppColors.accentCyanDark,
                  label: 'Hardware',
                  tooltip: 'Hardware Companion',
                  onTap: () => context.push(RoutePaths.hardware),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionTile(
                  key: const Key('home_interactive_lab_card'),
                  icon: Icons.science,
                  color: AppColors.primaryViolet,
                  label: 'Wiring Lab',
                  tooltip: 'Interactive Wiring & Code Lab',
                  onTap: () => context.push(RoutePaths.interactiveLab),
                ),
              ),
            ],
          ),
        ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final nextLessonAsync = ref.watch(nextLessonProvider);

    return nextLessonAsync.when(
      loading: () => MonsterCard(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'Loading your next adventure...',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                Text(
                  'Outstanding work, Monster Master! You have mastered all 12 lessons in the lab curriculum.',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
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
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                nextLesson.courseId != null
                    ? nextLesson.title
                    : 'Lesson $lessonNumber: ${nextLesson.title}',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                nextLesson.summary,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              MonsterButton(
                label: nextLesson.courseId != null
                    ? 'Start Lesson'
                    : 'Start Lesson $lessonNumber',
                icon: Icons.rocket_launch,
                minHeight: 46,
                onPressed: () => context.push('/learn/${nextLesson.id}'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required bool compact,
    required VoidCallback onTap,
  }) {
    return MonsterCard(
      mergeSemantics: true,
      semanticLabel: '$label: $value',
      onTap: onTap,
      padding: EdgeInsets.all(compact ? 10 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String? tooltip;
  final VoidCallback onTap;

  const _QuickActionTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Tooltip(message: tooltip ?? label, child: tile);
  }
}
