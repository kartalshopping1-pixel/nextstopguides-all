import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../domain/entities/game_mode.dart';
import '../../../domain/entities/game_result.dart';
import '../../../domain/entities/passport_stamp.dart';
import '../../game/presentation/game_screen.dart';
import '../../settings/state/settings_controller.dart';

/// Arguments for the /results route.
class ResultsArgs {
  const ResultsArgs({required this.summary, required this.replay});

  final GameSummary summary;
  final GameArgs replay;
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.args});

  final ResultsArgs args;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final summary = args.summary;
    final theme = Theme.of(context);
    final accuracy = (summary.accuracy * 100).round();
    final trophy = summary.accuracy >= 0.9
        ? '🏆'
        : summary.accuracy >= 0.6
            ? '🎒'
            : '🧭';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(s.modeTitle(summary.mode)),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: BrandColors.oceanGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(trophy, style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text(
                      s.t('results_title'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.t('results_score'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '${summary.score}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      s.t('results_correct', {
                        'correct': summary.correct,
                        'total': summary.answered,
                      }),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      label: s.t('results_accuracy'),
                      value: '$accuracy%',
                      icon: Icons.track_changes,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      label: s.t('results_bestStreak'),
                      value: '${summary.bestStreak}',
                      icon: Icons.local_fire_department,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      label: 'XP',
                      value: s.t('results_xpGained', {'xp': summary.xpGained}),
                      icon: Icons.bolt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (summary.isDailyPractice)
                _RewardTile(emoji: 'ℹ️', text: s.t('results_dailyPractice')),
              if (summary.isNewHighScore)
                _RewardTile(emoji: '🏅', text: s.t('results_newHighScore')),
              if (summary.leveledUp)
                _RewardTile(
                  emoji: '⬆️',
                  text: s.t('results_levelUp', {'level': summary.newLevel}),
                ),
              if (summary.hintsEarned > 0)
                _RewardTile(
                  emoji: '💡',
                  text: s.t('results_hintsEarned', {'count': summary.hintsEarned}),
                ),
              if (summary.mode == GameMode.daily && !summary.isDailyPractice)
                _RewardTile(
                  emoji: '📅',
                  text: s.t('results_dailyStreak', {'count': summary.dailyStreak}),
                ),
              for (final stamp in summary.stampsUnlocked)
                _RewardTile(
                  emoji: stamp.continent.emoji,
                  color: _stampColor(stamp.tier),
                  text: s.t('results_stampUnlocked', {
                    'continent': s.continent(stamp.continent),
                    'tier': s.stampTier(stamp.tier),
                  }),
                ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                  AppRoutes.game,
                  arguments: args.replay,
                ),
                icon: const Icon(Icons.replay),
                label: Text(s.t('results_playAgain')),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.home_outlined),
                label: Text(s.t('results_home')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _stampColor(StampTier tier) => switch (tier) {
        StampTier.gold => BrandColors.gold,
        StampTier.silver => BrandColors.silver,
        StampTier.bronze => BrandColors.bronze,
        StampTier.none => BrandColors.ocean,
      };
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.emoji, required this.text, this.color});

  final String emoji;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? BrandColors.sunset;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withAlpha(36),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withAlpha(110)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
