import 'package:material_ui/material_ui.dart';
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
      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
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

    final bodyStyle = TextStyle(
      fontSize: 15,
      height: 1.55,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
    final markdownStyleSheet = MarkdownStyleSheet(
      p: bodyStyle,
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
          left: BorderSide(color: AppColors.accentCyan, width: 4),
        ),
      ),
      listBullet: const TextStyle(
        color: AppColors.accentCyan,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      a: const TextStyle(color: Colors.blue),
      pPadding: EdgeInsets.zero,
      h1Padding: EdgeInsets.zero,
      h2Padding: EdgeInsets.zero,
      h3Padding: EdgeInsets.zero,
      h4: bodyStyle,
      h4Padding: EdgeInsets.zero,
      h5: bodyStyle,
      h5Padding: EdgeInsets.zero,
      h6: bodyStyle,
      h6Padding: EdgeInsets.zero,
      del: const TextStyle(decoration: TextDecoration.lineThrough),
      blockquote: bodyStyle,
      img: bodyStyle,
      checkbox: bodyStyle.copyWith(color: theme.colorScheme.primary),
      blockSpacing: 8,
      listIndent: 24,
      listBulletPadding: const EdgeInsets.only(right: 4),
      tableHead: const TextStyle(fontWeight: FontWeight.w600),
      tableBody: bodyStyle,
      tableHeadAlign: TextAlign.center,
      tablePadding: const EdgeInsets.only(bottom: 4),
      tableBorder: TableBorder.all(color: theme.dividerColor),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableCellsDecoration: const BoxDecoration(),
      tableHeadCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      tableHeadCellsDecoration: const BoxDecoration(),
      blockquotePadding: const EdgeInsets.all(8),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
    );

    return MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: markdownStyleSheet,
      syntaxHighlighter: ArduinoSyntaxHighlighterBridge(),
      builders: {'code': _CodeBlockBuilder()},
    );
  }
}
