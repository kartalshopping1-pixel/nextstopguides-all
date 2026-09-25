import 'package:flutter/material.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/engine/game_session.dart';

/// Top bar with progress, score, streak and lives.
class GameHud extends StatelessWidget {
  const GameHud({super.key, required this.session, required this.strings});

  final GameSession session;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = session.totalQuestions;
    final questionLabel = total != null
        ? strings.t('game_question', {'current': session.questionNumber, 'total': total})
        : strings.t('game_questionEndless', {'current': session.questionNumber});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                questionLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            _Pill(
              icon: Icons.star_rounded,
              color: BrandColors.gold,
              label: '${session.score}',
              tooltip: strings.t('game_score'),
            ),
            const SizedBox(width: 8),
            _Pill(
              icon: Icons.local_fire_department_rounded,
              color: BrandColors.sunset,
              label: '${session.streak}',
              tooltip: strings.t('game_streak'),
            ),
            if (session.mode.hasLives) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: strings.t('game_lives'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < session.mode.startingLives; i++)
                      Icon(
                        i < session.lives ? Icons.favorite : Icons.favorite_border,
                        color: BrandColors.coral,
                        size: 22,
                      ),
                    if (session.lives > session.mode.startingLives)
                      Text(
                        ' +${session.lives - session.mode.startingLives}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (total != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: session.answeredCount / total,
              minHeight: 8,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.color,
    required this.label,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
