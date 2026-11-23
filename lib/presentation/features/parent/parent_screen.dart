import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/services/parent_data_service.dart';
import '../../../core/services/parent_session_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/learner_profile_model.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../../domain/models/parent_insights_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class ParentScreen extends ConsumerStatefulWidget {
  const ParentScreen({super.key});

  @override
  ConsumerState<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends ConsumerState<ParentScreen> {
  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final allProfilesAsync = ref.watch(allProfilesProvider);
    final totals = ref.watch(curriculumTotalsProvider).valueOrNull;
    final safetyAuthorizations = ref.watch(safetyAuthorizationsProvider);

    ref.listen<AsyncValue<bool>>(parentSessionAuthStateProvider,
        (previous, next) {
      if (!(next.value ?? true)) _handleSessionExpired();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parent Dashboard & Insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: activeProfile == null || activeProgress == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Learner Profile Selector
                allProfilesAsync.when(
                  data: (profiles) =>
                      _buildLearnerSelector(profiles, activeProfile),
                  loading: () =>
                      _buildLearnerSelector([activeProfile], activeProfile),
                  error: (_, __) =>
                      _buildLearnerSelector([activeProfile], activeProfile),
                ),
                const SizedBox(height: 16),

                // 2. 60-Second Executive Summary Card
                _buildExecutiveSummaryCard(
                    activeProfile, activeProgress, totals),
                const SizedBox(height: 16),

                // 3. Pedagogical Quick-Take & Growth Focus
                _buildQuickTakeCard(activeProfile, activeProgress),
                const SizedBox(height: 20),

                // 4. STEM Competencies (6 key dimensions)
                const Text(
                  'STEM Competencies Practiced',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Curriculum skills mapped against verified circuit builds, sensor readings, and code debugging.',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14),
                ),
                const SizedBox(height: 12),
                ..._buildCompetencyCards(activeProgress),
                const SizedBox(height: 20),

                // 5. Chronological Recent Activity
                const Text(
                  'Recent Activity Timeline',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRecentActivityCard(activeProgress),
                const SizedBox(height: 20),

                // 6. Hardware Safety Interlocks
                const Text(
                  'Hardware Safety Interlocks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSafetyInterlocksCard(safetyAuthorizations),
                const SizedBox(height: 20),

                // 7. Data Controls & Disaster Recovery
                const Text(
                  'Data Controls & Backups',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDataControlsCard(activeProfile, activeProgress),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildLearnerSelector(
    List<LearnerProfileModel> profiles,
    LearnerProfileModel activeProfile,
  ) {
    // Combine profile list ensuring the active profile is always present
    final Map<String, LearnerProfileModel> profileMap = {
      for (final p in profiles) p.id: p,
      activeProfile.id: activeProfile,
    };
    final uniqueProfiles = profileMap.values.toList();

    return MonsterCard(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          const Icon(Icons.people_alt, color: AppColors.primaryViolet),
          const SizedBox(width: 12),
          const Text(
            'Viewing Learner:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          DropdownButton<String>(
            key: const Key('parent_learner_dropdown'),
            value: activeProfile.id,
            underline: const SizedBox(),
            items: uniqueProfiles.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Text(
                  '${p.nickname} (${p.ageBracket.name.replaceAll("ages", "Ages ")})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (newId) {
              if (newId != null && newId != activeProfile.id) {
                ref.read(activeProfileProvider.notifier).selectProfile(newId);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryCard(
    LearnerProfileModel profile,
    LearnerProgressModel progress,
    CurriculumTotals? totals,
  ) {
    return MonsterCard(
      color: AppColors.primaryViolet.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryViolet,
                child: Text(
                  profile.nickname.isNotEmpty
                      ? profile.nickname[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.nickname,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryViolet,
                      ),
                    ),
                    Text(
                      'Level ${progress.currentLevel} Inventor • ${progress.totalXp} Total XP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.levelProgressRatio,
              minHeight: 10,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.energyAmber),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress.levelProgressRatio * 100).toInt()}% towards Level ${progress.currentLevel + 1}',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          const Divider(height: 24),
          // 4 Metric Counters Grid
          Row(
            children: [
              _buildMetricTile(
                  'Lessons',
                  _countLabel(
                      progress.completedLessonIds.length, totals?.lessons),
                  Icons.menu_book),
              _buildMetricTile(
                  'Projects',
                  _countLabel(
                      progress.completedProjectIds.length, totals?.projects),
                  Icons.handyman),
              _buildMetricTile(
                  'Parts Found',
                  _countLabel(progress.discoveredComponentIds.length,
                      totals?.components),
                  Icons.memory),
              _buildMetricTile(
                  'Challenges',
                  _countLabel(
                      progress.solvedChallengeIds.length, totals?.challenges),
                  Icons.military_tech),
            ],
          ),
        ],
      ),
    );
  }

  String _countLabel(int completed, int? total) {
    return total == null ? '$completed' : '$completed/$total';
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.primaryViolet),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTakeCard(
    LearnerProfileModel profile,
    LearnerProgressModel progress,
  ) {
    final quickTake =
        ParentCompetencyAnalyzer.generateQuickTake(profile, progress);
    final focus = ParentCompetencyAnalyzer.getRecommendedFocus(progress);

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.energyAmber),
              SizedBox(width: 8),
              Text(
                'Pedagogical Quick-Take (60-Sec Digest)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            quickTake,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.accentCyanDark, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommended Growth Focus:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        focus,
                        style: const TextStyle(fontSize: 13, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompetencyCards(LearnerProgressModel progress) {
    final competencies = ParentCompetencyAnalyzer.analyzeCompetencies(progress);

    return competencies.map((comp) {
      Color statusColor;
      String statusLabel;

      switch (comp.status) {
        case CompetencyStatus.mastered:
          statusColor = AppColors.success;
          statusLabel = 'Mastered';
          break;
        case CompetencyStatus.inProgress:
          statusColor = AppColors.warning;
          statusLabel = 'In Progress';
          break;
        case CompetencyStatus.upcoming:
          statusColor = Theme.of(context).colorScheme.onSurfaceVariant;
          statusLabel = 'Upcoming';
          break;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: MonsterCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      comp.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                comp.description,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: comp.progressRatio,
                        minHeight: 6,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(comp.progressRatio * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: comp.skillsPracticed.map((skill) {
                  return Chip(
                    label: Text(skill, style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildRecentActivityCard(LearnerProgressModel progress) {
    final activity = progress.lastActivity;

    return MonsterCard(
      child: activity != null
          ? Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      AppColors.primaryViolet.withValues(alpha: 0.1),
                  child:
                      const Icon(Icons.history, color: AppColors.primaryViolet),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${activity.type.name.toUpperCase()} • ${_formatDate(activity.timestamp)}',
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.hourglass_empty,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No activities recorded yet for this learner profile.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }

  Widget _buildInterlockTile({
    required Key key,
    required String title,
    required String subtitle,
    required String authKey,
    required bool isAuthorized,
  }) {
    return SwitchListTile(
      key: key,
      title: Text(title),
      subtitle: Text(subtitle),
      value: isAuthorized,
      onChanged: (val) {
        if (val && !_ensureAuthorized()) return;
        ref
            .read(safetyAuthorizationsProvider.notifier)
            .setAuthorized(authKey, val);
      },
    );
  }

  Widget _buildSafetyInterlocksCard(Map<String, bool> authorizations) {
    return MonsterCard(
      child: Column(
        children: [
          _buildInterlockTile(
            key: const Key('laser_interlock_switch'),
            title: 'Laser Module Authorization (Project 11)',
            subtitle:
                'Requires adult supervision. Protects eyes from KY-008 laser diode.',
            authKey: 'laser',
            isAuthorized: authorizations['laser'] ?? false,
          ),
          const Divider(),
          _buildInterlockTile(
            key: const Key('gas_interlock_switch'),
            title: 'Gas/Flame Sensor Heating Authorization',
            subtitle:
                'Ensures adult presence during MQ-9 internal heater burn-in.',
            authKey: 'gas',
            isAuthorized: authorizations['gas'] ?? false,
          ),
          const Divider(),
          _buildInterlockTile(
            key: const Key('relay_interlock_switch'),
            title: 'High-Current Relay Authorization',
            subtitle:
                'Required for the optocoupled relay module; never connect it to mains AC.',
            authKey: 'relay',
            isAuthorized: authorizations['relay'] ?? false,
          ),
        ],
      ),
    );
  }

  bool _ensureAuthorized() {
    try {
      ref.read(parentSessionServiceProvider).executeWithAuthorization(() {});
      return true;
    } on ParentUnauthorizedException {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content:
                Text('Parent authorization expired. Verify again to continue.'),
          ),
        );
      }
    }
    // Action cannot proceed without active parent authorization.
    return false;
  }

  void _handleSessionExpired() {
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Parent session expired. Parent controls are locked.'),
      ),
    );
    try {
      context.go(RoutePaths.parentGate);
    } catch (_) {
      // Ignored if navigator context is already unmounted or transitioning.
    }
  }

  Widget _buildDataControlsCard(
    LearnerProfileModel profile,
    LearnerProgressModel progress,
  ) {
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            key: const Key('export_backup_button'),
            icon: const Icon(Icons.download),
            label: const Text('Export Progress Backup (JSON)'),
            onPressed: () => _handleExportBackup(profile, progress),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            key: const Key('import_backup_button'),
            icon: const Icon(Icons.upload),
            label: const Text('Import Progress Backup (JSON)'),
            onPressed: () => _handleImportBackup(),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            key: const Key('reset_progress_button'),
            icon: const Icon(Icons.refresh, color: AppColors.danger),
            label: const Text(
              'Reset Current Learner Progress',
              style: TextStyle(color: AppColors.danger),
            ),
            onPressed: () => _handleResetProgress(profile),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            key: const Key('about_app_button'),
            icon:
                const Icon(Icons.info_outline, color: AppColors.primaryViolet),
            label: const Text('About Monster Lab & Open Source Licenses'),
            onPressed: () => context.push(RoutePaths.parentAbout),
          ),
        ],
      ),
    );
  }

  void _handleExportBackup(
      LearnerProfileModel profile, LearnerProgressModel progress) {
    if (!_ensureAuthorized()) return;
    final jsonString = ParentDataService.exportBackupJson(profile, progress);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Backup JSON'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Copy and save this JSON backup to securely preserve your progress offline:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    jsonString,
                    key: const Key('export_json_preview'),
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            key: const Key('copy_backup_json_button'),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy to Clipboard'),
            onPressed: () async {
              if (!_ensureAuthorized()) return;
              final messenger = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx);
              try {
                await Clipboard.setData(ClipboardData(text: jsonString));
              } catch (_) {}
              nav.pop();
              messenger.showSnackBar(
                const SnackBar(
                    content: Text('Backup JSON copied to clipboard.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleImportBackup() {
    if (!_ensureAuthorized()) return;
    final controller = TextEditingController();
    String? validationError;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Import Progress Backup'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Paste valid Monster Lab backup JSON below to restore learner profile and progress:',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('import_json_input'),
                  controller: controller,
                  maxLines: 8,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  decoration: InputDecoration(
                    hintText:
                        '{\n  "app": "MonsterLab",\n  "version": 1,\n  ...\n}',
                    border: const OutlineInputBorder(),
                    errorText: validationError,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              key: const Key('confirm_restore_backup_button'),
              onPressed: () async {
                if (!_ensureAuthorized()) return;
                final messenger = ScaffoldMessenger.of(context);
                final nav = Navigator.of(ctx);
                final text = controller.text.trim();
                try {
                  final result =
                      await ParentDataService.restoreBackupTransactional(
                    jsonString: text,
                    profileRepo: ref.read(profileRepositoryProvider),
                    progressRepo: ref.read(progressRepositoryProvider),
                    storageDataSource: ref.read(localStorageDataSourceProvider),
                  );

                  // Switch to this profile if needed and reload
                  ref.invalidate(allProfilesProvider);
                  await ref
                      .read(activeProfileProvider.notifier)
                      .selectProfile(result.profile.id);
                  await ref
                      .read(activeProgressProvider.notifier)
                      .loadProgress();

                  nav.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Backup successfully restored for ${result.profile.nickname}!',
                      ),
                    ),
                  );
                } catch (e) {
                  setDialogState(() {
                    validationError = 'Invalid backup: $e';
                  });
                }
              },
              child: const Text('Restore Backup'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleResetProgress(LearnerProfileModel profile) {
    if (!_ensureAuthorized()) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            SizedBox(width: 8),
            Text('Reset All Progress?'),
          ],
        ),
        content: Text(
          'Are you sure you want to reset all progress for "${profile.nickname}"?\n\n'
          'This will permanently clear completed lessons, project steps, discovered parts, and XP. '
          'This action cannot be undone unless you have exported a JSON backup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('confirm_reset_progress_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (!_ensureAuthorized()) return;
              final messenger = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx);
              try {
                await ParentDataService.executeDestructiveAction(
                  storageDataSource: ref.read(localStorageDataSourceProvider),
                  confirmationInput: 'CONFIRM',
                  action: () => ref
                      .read(progressRepositoryProvider)
                      .resetProgress(profile.id),
                );
                if (!context.mounted) return;
                await ref.read(activeProgressProvider.notifier).loadProgress();
                nav.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                        'All progress for ${profile.nickname} has been reset.'),
                  ),
                );
              } catch (error) {
                messenger.showSnackBar(
                  SnackBar(
                      content:
                          Text('Reset failed; previous data restored: $error')),
                );
              }
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
