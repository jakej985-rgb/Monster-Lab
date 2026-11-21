import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class SyntaxBug {
  final String id;
  final int line;
  final String bugToken;
  final String fixToken;
  final String compilerError;
  final String explanation;

  const SyntaxBug({
    required this.id,
    required this.line,
    required this.bugToken,
    required this.fixToken,
    required this.compilerError,
    required this.explanation,
  });
}

class SyntaxErrorDebuggerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SyntaxErrorDebuggerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SyntaxErrorDebuggerWidget> createState() =>
      _SyntaxErrorDebuggerWidgetState();
}

class _SyntaxErrorDebuggerWidgetState extends State<SyntaxErrorDebuggerWidget> {
  static const List<SyntaxBug> _bugs = [
    SyntaxBug(
      id: 'semicolon',
      line: 3,
      bugToken: 'pinMode(13, OUTPUT)',
      fixToken: 'pinMode(13, OUTPUT);',
      compilerError: "error: expected ';' before '}' token",
      explanation:
          'Every statement in C++ must end with a semicolon (;). Without it, the compiler cannot tell where the instruction concludes.',
    ),
    SyntaxBug(
      id: 'casing',
      line: 6,
      bugToken: 'digitalwrite(13, HIGH);',
      fixToken: 'digitalWrite(13, HIGH);',
      compilerError:
          "error: 'digitalwrite' was not declared in this scope; did you mean 'digitalWrite'?",
      explanation:
          'C++ is case-sensitive! Arduino built-in functions follow camelCase conventions (capital W in digitalWrite).',
    ),
    SyntaxBug(
      id: 'brace',
      line: 8,
      bugToken: '// Missing closing brace',
      fixToken: '}',
      compilerError: "error: expected '}' at end of input",
      explanation:
          'Every opening curly brace { must have a matching closing curly brace } to seal the function scope block.',
    ),
  ];

  final Set<String> _fixedBugIds = {};
  String? _selectedBugId;

  void _fixBug(String bugId) {
    setState(() {
      _fixedBugIds.add(bugId);
      _selectedBugId = null;

      if (_fixedBugIds.length == _bugs.length) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Spot-the-Bug: Syntax Error Debugger';
    final allFixed = _fixedBugIds.length == _bugs.length;
    final selectedBug = _bugs.cast<SyntaxBug?>().firstWhere(
          (b) => b?.id == _selectedBugId,
          orElse: () => null,
        );

    final isSemiFixed = _fixedBugIds.contains('semicolon');
    final isCaseFixed = _fixedBugIds.contains('casing');
    final isBraceFixed = _fixedBugIds.contains('brace');

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
                  color: allFixed
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.danger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: allFixed ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      allFixed ? Icons.check_circle : Icons.bug_report,
                      color: allFixed ? AppColors.success : AppColors.danger,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      allFixed
                          ? 'CLEAN BUILD'
                          : '${_fixedBugIds.length}/3 BUGS FIXED',
                      style: TextStyle(
                        color: allFixed ? AppColors.success : AppColors.danger,
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
            'The sketch below fails compilation. Tap the bug badges on the code editor lines to diagnose and fix the syntax errors.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Code Editor Simulation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: allFixed ? AppColors.success : const Color(0xFF334155),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCodeLine(1, 'void setup() {'),
                _buildCodeLine(2, '  Serial.begin(9600);'),
                _buildInteractiveBugLine(
                  lineNumber: 3,
                  bugId: 'semicolon',
                  isFixed: isSemiFixed,
                  codeText: isSemiFixed
                      ? '  pinMode(13, OUTPUT);'
                      : '  pinMode(13, OUTPUT)',
                  bugNote: isSemiFixed ? 'Fixed' : 'Missing Semicolon',
                ),
                _buildCodeLine(4, '}'),
                _buildCodeLine(5, 'void loop() {'),
                _buildInteractiveBugLine(
                  lineNumber: 6,
                  bugId: 'casing',
                  isFixed: isCaseFixed,
                  codeText: isCaseFixed
                      ? '  digitalWrite(13, HIGH);'
                      : '  digitalwrite(13, HIGH);',
                  bugNote: isCaseFixed ? 'Fixed' : 'Lowercase Casing',
                ),
                _buildCodeLine(7, '  delay(1000);'),
                _buildInteractiveBugLine(
                  lineNumber: 8,
                  bugId: 'brace',
                  isFixed: isBraceFixed,
                  codeText: isBraceFixed ? '}' : '  // Missing closing brace',
                  bugNote: isBraceFixed ? 'Fixed' : 'Unclosed Brace',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Selected Bug Diagnostic Card
          if (selectedBug != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.energyAmber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.energyAmber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Line ${selectedBug.line}: ${selectedBug.compilerError}',
                          style: const TextStyle(
                            color: AppColors.energyAmber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedBug.explanation,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    key: Key('apply_fix_${selectedBug.id}'),
                    onPressed: () => _fixBug(selectedBug.id),
                    icon: const Icon(Icons.auto_fix_high, size: 16),
                    label: Text('APPLY FIX: ${selectedBug.fixToken}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (allFixed) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All syntax errors resolved! Semicolons, camelCase functions, and braces are 100% verified.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCodeLine(int line, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$line',
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveBugLine({
    required int lineNumber,
    required String bugId,
    required bool isFixed,
    required String codeText,
    required String bugNote,
  }) {
    final isSelected = _selectedBugId == bugId;

    return InkWell(
      key: Key('bug_line_$bugId'),
      onTap: isFixed
          ? null
          : () {
              setState(() {
                _selectedBugId = isSelected ? null : bugId;
              });
            },
      child: Container(
        color: isFixed
            ? AppColors.success.withValues(alpha: 0.08)
            : (isSelected
                ? AppColors.energyAmber.withValues(alpha: 0.2)
                : AppColors.danger.withValues(alpha: 0.12)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$lineNumber',
                style: TextStyle(
                  color: isFixed
                      ? AppColors.success
                      : (isSelected ? AppColors.energyAmber : AppColors.danger),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                codeText,
                style: TextStyle(
                  color: isFixed ? const Color(0xFF55EFC4) : Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isFixed
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.danger.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFixed ? AppColors.success : AppColors.danger,
                ),
              ),
              child: Text(
                bugNote,
                style: TextStyle(
                  color: isFixed ? AppColors.success : AppColors.danger,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
