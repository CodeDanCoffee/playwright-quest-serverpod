import 'package:flutter/material.dart';

import '../theme.dart';

/// A terminal-style code block with light syntax highlighting.
///
/// `____` is rendered as a highlighted blank. When [filledBlank] is given, the
/// blank shows that text instead (after the player answers).
class CodeBlock extends StatelessWidget {
  const CodeBlock({
    super.key,
    required this.code,
    this.filledBlank,
    this.blankColor = Stage.gold,
    this.fontSize = 13,
  });

  final String code;
  final String? filledBlank;
  final Color blankColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _bg.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                for (final c in const [Stage.coral, Stage.gold, Stage.green])
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: SelectableText.rich(
              TextSpan(children: _highlight(code)),
              style: Stage.code(fontSize, color: _plain),
            ),
          ),
        ],
      ),
    );
  }

  static const _bg = Color(0xFF2A2350);
  static const _plain = Color(0xFFF4F1FF);
  static const _comment = Color(0xFFA59ECF);

  static const _keywords = {
    'await', 'async', 'const', 'let', 'var', 'import', 'from', 'export', //
    'default', 'class', 'constructor', 'private', 'readonly', 'return', //
    'new', 'function', 'if', 'else', 'true', 'false', 'null', 'undefined',
  };
  static const _playwright = {
    'test', 'expect', 'page', 'request', 'context', 'browser', 'route', //
    'setup', 'use', 'devices', 'defineConfig', 'npx', 'npm', 'playwright',
  };

  static final _token = RegExp(
    r'(____)|(//[^\n]*|#[^\n]*)|'
    r"""('(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*"|`[^`]*`)|"""
    r'(/(?![/*\s])(?:[^/\\\n]|\\.)+/[a-z]*)|'
    r'([A-Za-z_$][\w$]*)|(\d+)',
  );

  List<InlineSpan> _highlight(String source) {
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in _token.allMatches(source)) {
      if (m.start > last) {
        spans.add(TextSpan(text: source.substring(last, m.start)));
      }
      final text = m[0]!;
      if (m[1] != null) {
        spans.add(_blank());
      } else if (m[2] != null) {
        spans.add(_styled(text, _comment, italic: true));
      } else if (m[3] != null) {
        spans.add(_styled(text, const Color(0xFFB5E08D)));
      } else if (m[4] != null) {
        spans.add(_styled(text, const Color(0xFFF7A278)));
      } else if (m[5] != null) {
        final isCall =
            m.end < source.length && source.codeUnitAt(m.end) == 0x28; // (
        if (_keywords.contains(text)) {
          spans.add(_styled(text, const Color(0xFFD7A8FF)));
        } else if (_playwright.contains(text)) {
          spans.add(_styled(text, const Color(0xFF5BE08F), bold: true));
        } else if (isCall) {
          spans.add(_styled(text, const Color(0xFF7FD0FF)));
        } else {
          spans.add(TextSpan(text: text));
        }
      } else {
        spans.add(_styled(text, const Color(0xFFFFD166)));
      }
      last = m.end;
    }
    if (last < source.length) spans.add(TextSpan(text: source.substring(last)));
    return spans;
  }

  TextSpan _styled(
    String text,
    Color color, {
    bool bold = false,
    bool italic = false,
  }) => TextSpan(
    text: text,
    style: TextStyle(
      color: color,
      fontWeight: bold ? FontWeight.w700 : null,
      fontStyle: italic ? FontStyle.italic : null,
    ),
  );

  InlineSpan _blank() {
    final filled = filledBlank;
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: blankColor.withValues(alpha: filled == null ? 0.12 : 0.22),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: blankColor, width: 1.2),
        ),
        child: Text(
          filled ?? '  ?  ',
          style: Stage.code(
            fontSize,
            color: blankColor,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
