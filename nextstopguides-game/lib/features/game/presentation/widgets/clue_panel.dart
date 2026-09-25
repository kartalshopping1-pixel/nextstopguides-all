import 'package:flutter/material.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../domain/entities/question.dart';

/// Shows the revealed clues of a "Guess the Country" question and a button
/// to reveal the next one.
class CluePanel extends StatelessWidget {
  const CluePanel({
    super.key,
    required this.question,
    required this.revealed,
    required this.strings,
    this.onRevealNext,
    this.showAll = false,
  });

  final Question question;
  final int revealed;
  final AppStrings strings;
  final VoidCallback? onRevealNext;

  /// After answering, all clues are shown.
  final bool showAll;

  static const Map<ClueType, IconData> _icons = {
    ClueType.continent: Icons.public,
    ClueType.population: Icons.groups,
    ClueType.language: Icons.translate,
    ClueType.currency: Icons.payments_outlined,
    ClueType.landmark: Icons.account_balance,
    ClueType.capital: Icons.location_city,
    ClueType.flag: Icons.flag_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = question.clues.length;
    final visible = showAll ? total : revealed.clamp(0, total);

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.t('game_clueCount', {'current': visible, 'total': total}),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < visible; i++) _ClueRow(
              icon: _icons[question.clues[i].type] ?? Icons.lightbulb_outline,
              label: strings.clueLabel(question.clues[i].type),
              value: strings.clueValue(question.clues[i]),
              isFlag: question.clues[i].type == ClueType.flag,
            ),
            if (!showAll && visible < total) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onRevealNext,
                icon: const Icon(Icons.visibility_outlined),
                label: Text(strings.t('game_revealClue')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClueRow extends StatelessWidget {
  const _ClueRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isFlag,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isFlag;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: scheme.secondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: isFlag ? 32 : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
