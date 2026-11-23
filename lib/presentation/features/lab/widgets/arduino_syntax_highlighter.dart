import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class ArduinoSyntaxHighlighter {
  static const Set<String> _keywords = {
    'void',
    'int',
    'float',
    'double',
    'char',
    'bool',
    'boolean',
    'long',
    'short',
    'const',
    'static',
    'volatile',
    'if',
    'else',
    'for',
    'while',
    'do',
    'return',
    'break',
    'continue',
    'switch',
    'case',
  };

  static const Set<String> _functions = {
    'setup',
    'loop',
    'pinMode',
    'digitalWrite',
    'digitalRead',
    'analogWrite',
    'analogRead',
    'delay',
    'delayMicroseconds',
    'millis',
    'micros',
    'Serial',
    'begin',
    'print',
    'println',
    'available',
    'read',
    'write',
    'map',
    'constrain',
  };

  static const Set<String> _constants = {
    'HIGH',
    'LOW',
    'INPUT',
    'OUTPUT',
    'INPUT_PULLUP',
    'LED_BUILTIN',
    'true',
    'false',
  };

  static List<TextSpan> highlight(String code) {
    final List<TextSpan> spans = [];
    final lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      spans.addAll(_highlightLine(line));
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }

  static List<TextSpan> _highlightLine(String line) {
    final List<TextSpan> spans = [];

    // Preprocessor (#include, #define)
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('#')) {
      spans.add(
        TextSpan(
          text: line,
          style: const TextStyle(
            color: AppColors.syntaxPreproc,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return spans;
    }

    // Check for comment
    final commentIdx = line.indexOf('//');
    String codePart = line;
    String? commentPart;

    if (commentIdx != -1) {
      codePart = line.substring(0, commentIdx);
      commentPart = line.substring(commentIdx);
    }

    // Tokenize codePart using regex matching words, numbers, strings, and symbols
    final tokenRegex = RegExp(r'("[^"]*"|\b[a-zA-Z_]\w*\b|\b\d+\b|[^\s\w])');
    int lastEnd = 0;

    for (final match in tokenRegex.allMatches(codePart)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: codePart.substring(lastEnd, match.start)));
      }

      final token = match.group(0)!;

      if (token.startsWith('"') && token.endsWith('"')) {
        spans.add(
          TextSpan(
            text: token,
            style: const TextStyle(color: AppColors.syntaxString),
          ),
        );
      } else if (_keywords.contains(token)) {
        spans.add(
          TextSpan(
            text: token,
            style: const TextStyle(
              color: AppColors.syntaxKeyword,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (_functions.contains(token)) {
        spans.add(
          TextSpan(
            text: token,
            style: const TextStyle(
              color: AppColors.syntaxFunction,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (_constants.contains(token)) {
        spans.add(
          TextSpan(
            text: token,
            style: const TextStyle(
              color: AppColors.syntaxConstant,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (int.tryParse(token) != null) {
        spans.add(
          TextSpan(
            text: token,
            style: const TextStyle(color: AppColors.syntaxConstant),
          ),
        );
      } else {
        spans.add(TextSpan(text: token));
      }

      lastEnd = match.end;
    }

    if (lastEnd < codePart.length) {
      spans.add(TextSpan(text: codePart.substring(lastEnd)));
    }

    if (commentPart != null) {
      spans.add(
        TextSpan(
          text: commentPart,
          style: const TextStyle(
            color: AppColors.syntaxComment,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return spans;
  }
}
