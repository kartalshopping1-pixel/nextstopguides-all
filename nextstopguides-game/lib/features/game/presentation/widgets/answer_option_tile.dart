import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

enum AnswerOptionState { idle, eliminated, correct, wrong, dimmed }

/// One multiple-choice answer button.
class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.label,
    required this.index,
    required this.state,
    this.onTap,
  });

  final String label;
  final int index;
  final AnswerOptionState state;
  final VoidCallback? onTap;

  static const List<String> _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color background = scheme.surfaceContainerHighest;
    Color foreground = scheme.onSurface;
    Color border = scheme.outlineVariant;
    IconData? trailing;

    switch (state) {
      case AnswerOptionState.idle:
        break;
      case AnswerOptionState.eliminated:
        background = scheme.surfaceContainerLow;
        foreground = scheme.onSurface.withAlpha(90);
        border = scheme.outlineVariant.withAlpha(90);
      case AnswerOptionState.correct:
        background = BrandColors.palm.withAlpha(46);
        foreground = scheme.onSurface;
        border = BrandColors.palm;
        trailing = Icons.check_circle;
      case AnswerOptionState.wrong:
        background = BrandColors.coral.withAlpha(46);
        foreground = scheme.onSurface;
        border = BrandColors.coral;
        trailing = Icons.cancel;
      case AnswerOptionState.dimmed:
        foreground = scheme.onSurface.withAlpha(150);
    }

    final letter = index < _letters.length ? _letters[index] : '${index + 1}';

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: state == AnswerOptionState.idle ? 1 : 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: scheme.primary.withAlpha(
                    state == AnswerOptionState.eliminated ? 40 : 255,
                  ),
                  foregroundColor: scheme.onPrimary,
                  child: Text(
                    letter,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                      decoration: state == AnswerOptionState.eliminated
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (trailing != null)
                  Icon(
                    trailing,
                    color: state == AnswerOptionState.correct
                        ? BrandColors.palm
                        : BrandColors.coral,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
