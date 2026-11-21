import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class SyntaxToken {
  final String token;
  final String label;
  final String description;
  final String rules;
  final String commonMistake;
  final Color color;

  const SyntaxToken({
    required this.token,
    required this.label,
    required this.description,
    required this.rules,
    required this.commonMistake,
    required this.color,
  });
}

class IncludeSyntaxDeconstructionWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const IncludeSyntaxDeconstructionWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<IncludeSyntaxDeconstructionWidget> createState() =>
      _IncludeSyntaxDeconstructionWidgetState();
}

class _IncludeSyntaxDeconstructionWidgetState
    extends State<IncludeSyntaxDeconstructionWidget> {
  static const List<SyntaxToken> _tokens = [
    SyntaxToken(
      token: '#',
      label: 'Preprocessor Flag',
      description:
          'Signals that this line is a preprocessor command, evaluated before code compilation begins.',
      rules:
          'Must be the very first non-whitespace character on the line. Preprocessor lines do NOT terminate with a semicolon (;).',
      commonMistake:
          'Adding a semicolon at the end (#include <...>;) causes a compiler syntax error.',
      color: AppColors.syntaxKeyword,
    ),
    SyntaxToken(
      token: 'include',
      label: 'Include Directive',
      description:
          'Instructs the preprocessor to literally paste the full contents of the header file into your sketch.',
      rules:
          'Must be written in all-lowercase. Arduino C++ does not recognize Python "import" or capitalized "Include".',
      commonMistake:
          'Writing "import LiquidCrystal_I2C;" like Python or Java fails to compile.',
      color: AppColors.accentCyan,
    ),
    SyntaxToken(
      token: '< >',
      label: 'Angle Bracket Delimiters',
      description:
          'Tells the compiler to search the system and installed libraries folder (e.g. ~/Arduino/libraries/).',
      rules:
          'Use < > for installed libraries. Use double quotes " " only for local files saved inside your sketch folder.',
      commonMistake:
          'Using parenthesis (#include (file.h)) or omitting brackets causes fatal parse errors.',
      color: AppColors.energyGold,
    ),
    SyntaxToken(
      token: '.h',
      label: 'Header File Extension',
      description:
          'Stands for C++ "Header". Contains class definitions, method prototypes, and hardware register constants.',
      rules:
          'Must include the .h extension so the preprocessor finds the specific interface file on disk.',
      commonMistake:
          'Forgetting .h (e.g., #include <LiquidCrystal_I2C>) results in "No such file or directory".',
      color: Color(0xFF55EFC4),
    ),
  ];

  int _selectedTokenIndex = 0;
  final Set<int> _inspectedIndices = {0};

  void _selectToken(int index) {
    setState(() {
      _selectedTokenIndex = index;
      _inspectedIndices.add(index);

      if (_inspectedIndices.length == _tokens.length) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Deconstructing Syntax: #include <LiquidCrystal_I2C.h>';
    final allInspected = _inspectedIndices.length == _tokens.length;
    final activeToken = _tokens[_selectedTokenIndex];

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: allInspected
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.primaryViolet.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: allInspected
                        ? AppColors.success
                        : AppColors.primaryViolet,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      allInspected ? Icons.check_circle : Icons.code,
                      color: allInspected
                          ? AppColors.success
                          : AppColors.primaryViolet,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      allInspected
                          ? 'DECONSTRUCTED'
                          : '${_inspectedIndices.length}/4 EXPLORED',
                      style: TextStyle(
                        color: allInspected
                            ? AppColors.success
                            : AppColors.primaryViolet,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap each syntax token below to inspect its role in commanding the C++ compiler:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Big Interactive Code Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155), width: 1.5),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 8,
              children: [
                _buildCodeChip(0, '#', AppColors.syntaxKeyword),
                _buildCodeChip(1, 'include', AppColors.accentCyan),
                _buildCodeChip(2, '<', AppColors.energyGold),
                const Text(
                  'LiquidCrystal_I2C',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildCodeChip(3, '.h', const Color(0xFF55EFC4)),
                _buildCodeChip(2, '>', AppColors.energyGold),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Token Selection Chips Bar
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_tokens.length, (index) {
              final tok = _tokens[index];
              final isSelected = index == _selectedTokenIndex;
              final isInspected = _inspectedIndices.contains(index);

              return FilterChip(
                key: Key('syntax_chip_${tok.token}'),
                avatar: Icon(
                  isInspected ? Icons.check : Icons.circle,
                  size: 14,
                  color: tok.color,
                ),
                label: Text(
                  '${tok.token}  (${tok.label})',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (val) => _selectToken(index),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Detailed Token Breakdown Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: activeToken.color.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: activeToken.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: activeToken.color),
                      ),
                      child: Text(
                        activeToken.token,
                        style: TextStyle(
                          color: activeToken.color,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        activeToken.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  activeToken.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Syntax Rules Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SYNTAX RULES:',
                        style: TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeToken.rules,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Common Mistake Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COMMON PITFALL:',
                        style: TextStyle(
                          color: AppColors.energyAmber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeToken.commonMistake,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
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

  Widget _buildCodeChip(int tokenIndex, String text, Color color) {
    final isSelected = _selectedTokenIndex == tokenIndex;

    return InkWell(
      onTap: () => _selectToken(tokenIndex),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
