import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../../shared/widgets/monster_card.dart';

/// A phone-friendly matching activity that only places four pairs on screen.
class VocabularyMatchWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const VocabularyMatchWidget({super.key, this.config, this.onComplete});

  @override
  State<VocabularyMatchWidget> createState() => _VocabularyMatchWidgetState();
}

class _VocabularyMatchWidgetState extends State<VocabularyMatchWidget> {
  static const _pageSize = 4;
  late final List<_VocabularyPair> _pairs;
  int _round = 0;
  String? _selectedTerm;
  String? _message;
  final Set<String> _matchedTerms = {};
  final Map<String, String> _matches = {};
  bool _complete = false;
  bool _notified = false;

  int get _roundCount => (_pairs.length / _pageSize).ceil();
  List<_VocabularyPair> get _currentPairs {
    final start = _round * _pageSize;
    return _pairs.skip(start).take(_pageSize).toList();
  }

  List<_VocabularyPair> get _shuffledCurrentPairs {
    final result = _currentPairs.toList();
    result.shuffle(Random(_round + 27));
    return result;
  }

  @override
  void initState() {
    super.initState();
    final raw = widget.config?['items'];
    _pairs = (raw is List ? raw : const [])
        .whereType<Map>()
        .map((item) => _VocabularyPair(
              term: '${item['term'] ?? ''}'.trim(),
              meaning: '${item['meaning'] ?? ''}'.trim(),
            ))
        .where((pair) => pair.term.isNotEmpty && pair.meaning.isNotEmpty)
        .toList();
  }

  void _chooseMeaning(String meaning) {
    final term = _selectedTerm;
    if (term == null) {
      setState(() => _message = 'Pick a word first, then choose its meaning.');
      return;
    }
    _match(term, meaning);
  }

  void _match(String term, String meaning) {
    _VocabularyPair? pair;
    for (final item in _currentPairs) {
      if (item.term == term) {
        pair = item;
        break;
      }
    }
    if (pair == null || _matches.containsKey(meaning)) return;
    if (pair.meaning != meaning) {
      setState(() {
        _selectedTerm = null;
        _message = 'Almost! Try another meaning.';
      });
      return;
    }
    setState(() {
      _matches[meaning] = term;
      _matchedTerms.add(term);
      _selectedTerm = null;
      _message = _matchedTerms.length == _currentPairs.length
          ? (_round == _roundCount - 1
              ? 'Fantastic! You matched every Course 1 word!'
              : 'Great matching! Ready for the next four?')
          : 'That’s a match! Keep going.';
      if (_matchedTerms.length == _currentPairs.length &&
          _round == _roundCount - 1) {
        _complete = true;
        if (!_notified) {
          _notified = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onComplete?.call();
          });
        }
      }
    });
  }

  void _nextRound() {
    setState(() {
      _round++;
      _matchedTerms.clear();
      _matches.clear();
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pairs.isEmpty) return const SizedBox.shrink();
    final finishedRound = _matchedTerms.length == _currentPairs.length;
    return MonsterCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${widget.config?['title'] ?? 'Vocabulary Match'}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(_complete
                ? 'All ${_pairs.length} words matched'
                : 'Round ${_round + 1} of $_roundCount · ${_currentPairs.length} words'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _complete
                  ? 1
                  : (_round * _pageSize + _matchedTerms.length) / _pairs.length,
              color: AppColors.energyAmber,
              backgroundColor: AppColors.surfaceContainerLight,
            ),
            const SizedBox(height: 8),
            const Text(
                'Drag a word to its meaning, or tap a word and then its match.'),
            const SizedBox(height: 12),
            for (final pair in _currentPairs) _buildWord(pair),
            const SizedBox(height: 8),
            for (final pair in _shuffledCurrentPairs) _buildMeaning(pair),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
            if (finishedRound && !_complete) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _nextRound,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next four words'),
              ),
            ],
            if (_complete) ...[
              const SizedBox(height: 12),
              const Text('Course 1 vocabulary complete! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWord(_VocabularyPair pair) {
    final matched = _matchedTerms.contains(pair.term);
    final selected = _selectedTerm == pair.term;
    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: matched
            ? Colors.green.withValues(alpha: .12)
            : selected
                ? AppColors.energyAmber.withValues(alpha: .18)
                : Theme.of(context).colorScheme.surface,
        border: Border.all(
            color: selected ? AppColors.energyAmber : Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(matched ? Icons.check_circle : Icons.drag_indicator, size: 20),
        const SizedBox(width: 8),
        Expanded(
            child: Text(pair.term,
                style: const TextStyle(fontWeight: FontWeight.bold))),
      ]),
    );
    if (matched) return card;
    return LongPressDraggable<String>(
      data: pair.term,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 240, child: card),
      ),
      childWhenDragging: Opacity(opacity: .35, child: card),
      child: InkWell(
        onTap: () => setState(() {
          _selectedTerm = selected ? null : pair.term;
          _message = selected ? null : 'Now tap the matching meaning.';
        }),
        borderRadius: BorderRadius.circular(12),
        child: card,
      ),
    );
  }

  Widget _buildMeaning(_VocabularyPair pair) {
    final matched = _matches.containsKey(pair.meaning);
    return DragTarget<String>(
      onAcceptWithDetails: (details) => _match(details.data, pair.meaning),
      builder: (context, candidates, rejects) => InkWell(
        onTap: matched ? null : () => _chooseMeaning(pair.meaning),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: matched
                ? Colors.green.withValues(alpha: .12)
                : candidates.isNotEmpty
                    ? AppColors.energyAmber.withValues(alpha: .2)
                    : Theme.of(context).colorScheme.surface,
            border: Border.all(
                color: candidates.isNotEmpty
                    ? AppColors.energyAmber
                    : Colors.black26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Icon(matched ? Icons.check_circle : Icons.link, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Text(matched
                    ? '${_matches[pair.meaning]} — ${pair.meaning}'
                    : pair.meaning)),
          ]),
        ),
      ),
    );
  }
}

class _VocabularyPair {
  final String term;
  final String meaning;
  const _VocabularyPair({required this.term, required this.meaning});
}
