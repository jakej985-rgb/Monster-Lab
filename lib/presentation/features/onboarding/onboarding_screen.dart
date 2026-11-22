import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../domain/models/avatar_model.dart';
import '../../../domain/models/learner_profile_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  AgeBracket _selectedBracket = AgeBracket.ages10_12;
  String _selectedAvatarId = MonsterAvatar.all.first.id;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final name = _nicknameController.text.trim();
    if (name.length < 2) {
      setState(() {
        _errorMessage = 'Nickname must be at least 2 characters';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    try {
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
          .saveProfile(newProfile, setActive: true);

      if (mounted) {
        context.go(RoutePaths.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to save profile: $e';
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedAvatar = MonsterAvatar.findById(_selectedAvatarId);
    final String? corruptionMsg =
        ref.watch(storageCorruptionStreamProvider).value ??
            ref.watch(localStorageDataSourceProvider).lastCorruptionMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Monster Lab!'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (corruptionMsg != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          corruptionMsg,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Hero Welcome Card
              MonsterCard(
                color: selectedAvatar.backgroundColor.withValues(alpha: 0.9),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: selectedAvatar.accentColor,
                      child: Icon(
                        selectedAvatar.icon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome, Young Inventor!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Build interactive robots, master electronic circuits, and bring your Monster Kit to life!',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nickname Input
              const Text(
                'What should we call you?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('onboarding_nickname_input'),
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Your Inventor Nickname',
                  hintText: 'e.g. SparkyBot, CircuitPro',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.badge_outlined),
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 24),

              // Companion Avatar Selection
              const Text(
                'Choose Your Robot Companion:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Robot Companion Avatars (Responsive Wrap - No side scrolling)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final avatar in MonsterAvatar.all) ...[
                    Builder(builder: (context) {
                      final isSelected = avatar.id == _selectedAvatarId;
                      return GestureDetector(
                        key: Key('onboarding_avatar_${avatar.id}'),
                        onTap: () =>
                            setState(() => _selectedAvatarId = avatar.id),
                        child: Container(
                          width: 76,
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
                                child: Icon(
                                  avatar.icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Age Bracket Dropdown
              const Text(
                'Select Your Experience Level:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AgeBracket>(
                key: const Key('onboarding_age_dropdown'),
                initialValue: _selectedBracket,
                decoration: const InputDecoration(
                  labelText: 'Age Bracket',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: AgeBracket.ages7_9,
                    child: Text('Ages 7–9 (Rookie Builder)'),
                  ),
                  DropdownMenuItem(
                    value: AgeBracket.ages10_12,
                    child: Text('Ages 10–12 (Maker Scout)'),
                  ),
                  DropdownMenuItem(
                    value: AgeBracket.ages13Plus,
                    child: Text('Ages 13+ (Master Engineer)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedBracket = val);
                  }
                },
              ),
              const SizedBox(height: 32),

              // Action Button
              MonsterButton(
                key: const Key('onboarding_start_button'),
                label: 'Start Your Adventure!',
                icon: Icons.rocket_launch,
                onPressed: _isSubmitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
