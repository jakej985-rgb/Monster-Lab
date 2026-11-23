import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/learner_profile_model.dart';
import '../../../domain/models/avatar_model.dart';
import '../../shared/providers.dart';
import '../parent/parent_gate_dialog.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';

class ProfileSelectScreen extends ConsumerStatefulWidget {
  const ProfileSelectScreen({super.key});

  @override
  ConsumerState<ProfileSelectScreen> createState() =>
      _ProfileSelectScreenState();
}

class _ProfileSelectScreenState extends ConsumerState<ProfileSelectScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  AgeBracket _selectedBracket = AgeBracket.ages10_12;
  String _selectedAvatarId = MonsterAvatar.all.first.id;
  String? _errorMessage;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, LearnerProfileModel profile) async {
    final verified = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ParentGateDialog(
            embedded: true,
            onVerified: () => Navigator.of(dialogCtx).pop(true),
            onCancel: () => Navigator.of(dialogCtx).pop(false),
          ),
        ),
      ),
    );
    if (verified != true || !context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Delete ${profile.nickname}?'),
        content: const Text(
          'This will permanently delete this learner profile and all associated XP and badge records on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await ref
                  .read(activeProfileProvider.notifier)
                  .deleteProfile(profile.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeProfile = ref.watch(activeProfileProvider);
    final allProfilesAsync = ref.watch(allProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Learner Profiles')),
      body: allProfilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading profiles: $err')),
        data: (profiles) {
          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              const Text(
                'Who is learning today?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (profiles.isNotEmpty) ...[
                ...profiles.map((p) {
                  final avatar = MonsterAvatar.findById(p.avatarId);
                  final isCurrentActive = activeProfile?.id == p.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: MonsterCard(
                      color: isCurrentActive
                          ? avatar.backgroundColor.withValues(alpha: 0.8)
                          : null,
                      onTap: () async {
                        await ref
                            .read(activeProfileProvider.notifier)
                            .selectProfile(p.id);
                        if (context.mounted) {
                          context.go(RoutePaths.home);
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: avatar.accentColor,
                            child: Icon(avatar.icon,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      p.nickname,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    if (isCurrentActive) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryViolet,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'ACTIVE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${avatar.name} • ${p.ageBracket.name}',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: colorScheme.onSurfaceVariant, size: 20),
                            tooltip: 'Delete Profile',
                            onPressed: () =>
                                _showDeleteConfirmation(context, p),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  );
                }),
                const Divider(height: 36),
              ],
              const Text(
                'Create New Learner Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Monster Nickname',
                  hintText: 'e.g. SparkyBot, RoboKid',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Your Robot Companion:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),
              // Robot Companion Avatars (Responsive Wrap - No side scrolling)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final avatar in MonsterAvatar.all) ...[
                    Builder(builder: (context) {
                      final isSelected = avatar.id == _selectedAvatarId;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedAvatarId = avatar.id),
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? avatar.backgroundColor
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? avatar.accentColor
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: avatar.accentColor,
                                child: Icon(avatar.icon,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                avatar.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? avatar.accentColor
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AgeBracket>(
                initialValue: _selectedBracket,
                decoration: const InputDecoration(
                  labelText: 'Age Bracket',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: AgeBracket.ages7_9,
                      child: Text('Ages 7–9 (Rookie)')),
                  DropdownMenuItem(
                      value: AgeBracket.ages10_12,
                      child: Text('Ages 10–12 (Builder)')),
                  DropdownMenuItem(
                      value: AgeBracket.ages13Plus,
                      child: Text('Ages 13+ (Engineer)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBracket = val);
                },
              ),
              const SizedBox(height: 24),
              MonsterButton(
                label: 'Create & Launch',
                icon: Icons.rocket_launch,
                onPressed: () async {
                  final name = _nicknameController.text.trim();
                  if (name.length < 2) {
                    setState(() => _errorMessage =
                        'Nickname must be at least 2 characters');
                    return;
                  }
                  setState(() => _errorMessage = null);

                  final newProfile = LearnerProfileModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nickname: name,
                    avatarId: _selectedAvatarId,
                    ageBracket: _selectedBracket,
                    createdAt: DateTime.now(),
                    lastActiveAt: DateTime.now(),
                  );
                  await ref
                      .read(activeProfileProvider.notifier)
                      .saveProfile(newProfile);
                  if (context.mounted) {
                    context.go(RoutePaths.home);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
