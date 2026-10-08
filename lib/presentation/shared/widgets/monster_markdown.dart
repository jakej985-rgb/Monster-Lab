import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../features/lab/widgets/arduino_syntax_highlighter.dart';

// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'responsive_code_block.dart';

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    // We can only reliably wrap code blocks with ResponsiveCodeBlock
    // if we want to support that. But based on instructions:
    return ResponsiveCodeBlock(code: code);
  }
}

/// Bridges the Monster Lab ArduinoSyntaxHighlighter to flutter_markdown's SyntaxHighlighter
class ArduinoSyntaxHighlighterBridge extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    return TextSpan(
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      children: ArduinoSyntaxHighlighter.highlight(source),
    );
  }
}

/// Themed Markdown renderer for Monster Lab lessons and stories
class MonsterMarkdown extends StatelessWidget {
  final String data;
  final bool selectable;
  final EdgeInsets? padding;

  const MonsterMarkdown({
    super.key,
    required this.data,
    this.selectable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: TextStyle(
        fontSize: 15,
        height: 1.55,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      h1: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.accentCyan,
        height: 1.3,
      ),
      h2: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryViolet,
        height: 1.3,
      ),
      h3: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.energyAmber,
        height: 1.3,
      ),
      strong: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: const Color(0xFF00E676),
        backgroundColor:
            isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
      ),
      codeblockDecoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      blockquoteDecoration: BoxDecoration(
        color: isDark ? const Color(0x1A00CEC9) : const Color(0x1A0984E3),
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          left: BorderSide(
            color: AppColors.accentCyan,
            width: 4,
          ),
        ),
      ),
      listBullet: const TextStyle(
        color: AppColors.accentCyan,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );

    return MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: markdownStyleSheet,
      syntaxHighlighter: ArduinoSyntaxHighlighterBridge(),
      builders: {
        'code': _CodeBlockBuilder(),
      },
    );
  }
}
