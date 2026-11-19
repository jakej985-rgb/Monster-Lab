import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/services/parent_data_service.dart';
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
  bool _laserUnlocked = false;
  bool _gasSensorUnlocked = false;

  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final allProfilesAsync = ref.watch(allProfilesProvider);

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
                _buildExecutiveSummaryCard(activeProfile, activeProgress),
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
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
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
                _buildSafetyInterlocksCard(),
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
      color: AppColors.surfaceContainerLight,
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
                        color: Colors.grey.shade700,
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
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.energyAmber),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress.levelProgressRatio * 100).toInt()}% towards Level ${progress.currentLevel + 1}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const Divider(height: 24),
          // 4 Metric Counters Grid
          Row(
            children: [
              _buildMetricTile('Lessons',
                  '${progress.completedLessonIds.length}/7', Icons.menu_book),
              _buildMetricTile('Projects',
                  '${progress.completedProjectIds.length}/14', Icons.handyman),
              _buildMetricTile('Parts Found',
                  '${progress.discoveredComponentIds.length}/54', Icons.memory),
              _buildMetricTile(
                  'Challenges',
                  '${progress.solvedChallengeIds.length}/16',
                  Icons.military_tech),
            ],
          ),
        ],
      ),
    );
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
          statusColor = Colors.grey;
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
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
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
                        backgroundColor: Colors.grey.shade200,
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
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Colors.grey.shade300),
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
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.hourglass_empty, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'No activities recorded yet for this learner profile.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSafetyInterlocksCard() {
    return MonsterCard(
      child: Column(
        children: [
          SwitchListTile(
            key: const Key('laser_interlock_switch'),
            title: const Text('Laser Module Authorization (Project 11)'),
            subtitle: const Text(
                'Requires adult supervision. Protects eyes from KY-008 laser diode.'),
            value: _laserUnlocked,
            onChanged: (val) => setState(() => _laserUnlocked = val),
          ),
          const Divider(),
          SwitchListTile(
            key: const Key('gas_interlock_switch'),
            title: const Text('Gas/Flame Sensor Heating Authorization'),
            subtitle: const Text(
                'Ensures adult presence during MQ-9 internal heater burn-in.'),
            value: _gasSensorUnlocked,
            onChanged: (val) => setState(() => _gasSensorUnlocked = val),
          ),
        ],
      ),
    );
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
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
              final messenger = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx);
              await ref
                  .read(progressRepositoryProvider)
                  .resetProgress(profile.id);
              await ref.read(activeProgressProvider.notifier).loadProgress();
              nav.pop();
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                      'All progress for ${profile.nickname} has been reset.'),
                ),
              );
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
