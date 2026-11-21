import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/challenge_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class ChallengeDetailScreen extends ConsumerStatefulWidget {
  final String challengeId;

  const ChallengeDetailScreen({
    super.key,
    required this.challengeId,
  });

  @override
  ConsumerState<ChallengeDetailScreen> createState() =>
      _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends ConsumerState<ChallengeDetailScreen> {
  late Future<ChallengeModel> _challengeFuture;
  int? _selectedIndex;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  int _hintLevel = 0;
  int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
    _challengeFuture = ref
        .read(curriculumRepositoryProvider)
        .getChallengeById(widget.challengeId);
  }

  void _onSelectOption(int index) {
    if (_hasSubmitted && _isCorrect) return;
    setState(() {
      _selectedIndex = index;
      _hasSubmitted = false;
    });
  }

  void _checkAnswer(ChallengeModel challenge) {
    if (_selectedIndex == null) return;

    final correctIndex =
        challenge.solutionValidation?['correctIndex'] as int? ?? 0;
    final isAnswerCorrect = _selectedIndex == correctIndex;

    setState(() {
      _hasSubmitted = true;
      _isCorrect = isAnswerCorrect;
      _attemptCount++;
    });

    if (isAnswerCorrect) {
      ref.read(soundEffectsProvider).success();
      ref.read(activeProgressProvider.notifier).solveChallenge(
            challenge.id,
            challenge.xpAward,
          );
    } else {
      ref.read(soundEffectsProvider).error();
    }
  }

  void _retry() {
    setState(() {
      _selectedIndex = null;
      _hasSubmitted = false;
    });
  }

  void _revealNextHint(int totalHints) {
    if (_hintLevel < totalHints) {
      setState(() {
        _hintLevel++;
      });
    }
  }

  String _formatChallengeType(ChallengeType type) {
    switch (type) {
      case ChallengeType.identifyPart:
        return 'Identify Part';
      case ChallengeType.predictOutput:
        return 'Predict Output';
      case ChallengeType.fixWiring:
        return 'Fix Wiring';
      case ChallengeType.changeCode:
        return 'Code Modification';
      case ChallengeType.debugLogic:
        return 'Debug Logic';
      case ChallengeType.combineComponents:
        return 'Combine Components';
      case ChallengeType.buildFromGoal:
        return 'Build From Goal';
      case ChallengeType.explainWhatHappened:
        return 'Explain Phenomenon';
    }
  }

  Color _getDifficultyColor(DifficultyTier tier) {
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

  @override
  Widget build(BuildContext context) {
    final activeProgress = ref.watch(activeProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Arena',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<ChallengeModel>(
        future: _challengeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.danger),
                  const SizedBox(height: 12),
                  Text('Failed to load challenge: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final challenge = snapshot.data!;
          final colorScheme = Theme.of(context).colorScheme;
          final successColor = Theme.of(context).brightness == Brightness.dark
              ? AppColors.success
              : AppColors.textSuccessOnLight;
          final isAlreadySolved =
              activeProgress?.solvedChallengeIds.contains(challenge.id) ??
                  false;
          final options = (challenge.challengeData['options'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          final hintsList =
              challenge.hints.isNotEmpty ? challenge.hints : [challenge.hint];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Bar: Difficulty & Challenge Type & XP Award
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(challenge.difficulty)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getDifficultyColor(challenge.difficulty),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            challenge.difficulty.name.toUpperCase(),
                            style: TextStyle(
                              color: _getDifficultyColor(challenge.difficulty),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryViolet.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatChallengeType(challenge.type),
                            style: const TextStyle(
                              color: AppColors.primaryViolet,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (isAlreadySolved)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: AppColors.success, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Solved',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                AppColors.energyAmber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.energyAmber, width: 1.2),
                          ),
                          child: Text(
                            '+${challenge.xpAward} XP',
                            style: const TextStyle(
                              color: AppColors.energyAmber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Challenge Title
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Challenge Prompt
                MonsterCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology,
                          color: AppColors.primaryViolet, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          challenge.prompt,
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Circuit Snippet (if available)
                if (challenge.circuitSnippet != null) ...[
                  const Text(
                    'Circuit Topology',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2430),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              AppColors.primaryViolet.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.electrical_services,
                                size: 16, color: AppColors.energyAmber),
                            SizedBox(width: 6),
                            Text(
                              'WIRING DIAGRAM',
                              style: TextStyle(
                                color: AppColors.energyAmber,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          challenge.circuitSnippet!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: Color(0xFFE2E8F0),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Code Snippet (if available)
                if (challenge.codeSnippet != null) ...[
                  const Text(
                    'Code Inspector',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181A20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.code,
                                size: 16, color: AppColors.success),
                            SizedBox(width: 6),
                            Text(
                              'ARDUINO C++',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          challenge.codeSnippet!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: Color(0xFF38BDF8),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Answer Options Header
                const Text(
                  'Choose the correct solution:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Option Cards
                ...options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final text = entry.value;
                  final isSelected = _selectedIndex == index;
                  final optionLetter =
                      String.fromCharCode(65 + index); // A, B, C, D

                  Color borderColor = isSelected
                      ? AppColors.primaryViolet
                      : colorScheme.outlineVariant;
                  Color backgroundColor = isSelected
                      ? AppColors.primaryViolet.withValues(alpha: 0.08)
                      : Colors.transparent;

                  if (_hasSubmitted) {
                    final correctIndex =
                        challenge.solutionValidation?['correctIndex'] as int? ??
                            0;
                    if (index == correctIndex) {
                      borderColor = AppColors.success;
                      backgroundColor =
                          AppColors.success.withValues(alpha: 0.12);
                    } else if (isSelected) {
                      borderColor = AppColors.danger;
                      backgroundColor =
                          AppColors.danger.withValues(alpha: 0.12);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Semantics(
                      button: !_hasSubmitted,
                      selected: isSelected,
                      inMutuallyExclusiveGroup: true,
                      label: 'Option $optionLetter: $text',
                      child: InkWell(
                        onTap: () => _onSelectOption(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: borderColor,
                                width: isSelected ? 2.0 : 1.2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryViolet
                                      : colorScheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  optionLetter,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (_hasSubmitted) ...[
                                if (index ==
                                    (challenge.solutionValidation?[
                                            'correctIndex'] as int? ??
                                        0))
                                  const Icon(Icons.check_circle,
                                      color: AppColors.success)
                                else if (isSelected)
                                  const Icon(Icons.cancel,
                                      color: AppColors.danger),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Hints Section
                if (hintsList.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _hintLevel == 0
                            ? 'Need guidance?'
                            : 'Hints Unlocked ($_hintLevel/${hintsList.length})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      TextButton.icon(
                        key: const Key('reveal_hint_button'),
                        onPressed: _hintLevel < hintsList.length
                            ? () => _revealNextHint(hintsList.length)
                            : null,
                        icon: const Icon(Icons.lightbulb_outline, size: 18),
                        label: Text(_hintLevel == 0
                            ? 'Get Hint 1'
                            : (_hintLevel < hintsList.length
                                ? 'Get Hint ${_hintLevel + 1}'
                                : 'All Hints Unlocked')),
                      ),
                    ],
                  ),
                  for (int h = 0;
                      h < _hintLevel && h < hintsList.length;
                      h++) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.energyAmber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                AppColors.energyAmber.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            h == 0 ? Icons.lightbulb : Icons.search,
                            color: AppColors.energyAmber,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h == 0
                                      ? 'Hint 1 (Concept):'
                                      : 'Hint 2 (Clue):',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.energyAmber,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hintsList[h],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],

                // Action Buttons (Submit, Try Again, Back)
                if (!_hasSubmitted ||
                    (!_isCorrect && _selectedIndex != null)) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      key: const Key('submit_answer_button'),
                      onPressed: _selectedIndex != null
                          ? () => _checkAnswer(challenge)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryViolet,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Check Answer',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],

                // Result & Pedagogical Feedback
                if (_hasSubmitted) ...[
                  const SizedBox(height: 16),
                  if (_isCorrect) ...[
                    Semantics(
                      liveRegion: true,
                      label: 'Outstanding! Mastered (+${challenge.xpAward} XP)',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.success, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.stars,
                                    color: successColor, size: 28),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Outstanding! Mastered (+${challenge.xpAward} XP)',
                                    style: TextStyle(
                                      color: successColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (challenge.explanation != null) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Why this works:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                challenge.explanation!,
                                style:
                                    const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                key: const Key('return_to_challenges_button'),
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Return to Challenges'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryViolet,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Semantics(
                      liveRegion: true,
                      label:
                          'Not quite! Give it another shot. Attempt $_attemptCount',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.danger, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.refresh,
                                    color: AppColors.danger, size: 24),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Not quite! Give it another shot.',
                                    style: TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Attempt $_attemptCount',
                                  style: const TextStyle(
                                      color: AppColors.danger, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Examine the schematic or code above, or tap for a hint to get more clues!',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                key: const Key('try_again_button'),
                                onPressed: _retry,
                                icon: const Icon(Icons.replay),
                                label: const Text('Try Again'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.danger,
                                  side:
                                      const BorderSide(color: AppColors.danger),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
