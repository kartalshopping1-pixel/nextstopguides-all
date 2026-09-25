import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../domain/engine/rewards.dart';
import '../../../domain/entities/continent.dart';
import '../../../domain/entities/game_mode.dart';
import '../../../domain/entities/passport_stamp.dart';
import '../../../domain/entities/player_progress.dart';
import '../../settings/state/settings_controller.dart';
import '../state/progress_controller.dart';

/// "My Passport": level, statistics, high scores and continent stamps.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final progress = context.watch<ProgressController>().progress;
    final theme = Theme.of(context);
    final sectionStyle =
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800);

    return Scaffold(
      appBar: AppBar(title: Text(s.t('profile_title'))),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _LevelCard(progress: progress, strings: s),
            const SizedBox(height: 20),
            Text(s.t('profile_stats'), style: sectionStyle),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 10.0;
                final columns = constraints.maxWidth >= 560 ? 3 : 2;
                final width =
                    ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                        .floorToDouble();
                final stats = [
                  ('🎮', s.t('profile_gamesPlayed'), '${progress.gamesPlayed}'),
                  ('✅', s.t('profile_correctAnswers'), '${progress.totalCorrect}'),
                  ('🎯', s.t('profile_accuracy'), '${(progress.accuracy * 100).round()}%'),
                  ('🔥', s.t('profile_bestStreak'), '${progress.bestStreak}'),
                  ('📅', s.t('profile_dailyStreak'), '${progress.dailyStreak}'),
                  ('💡', s.t('profile_hints'), '${progress.hints}'),
                ];
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final stat in stats)
                      SizedBox(
                        width: width,
                        child: _StatTile(emoji: stat.$1, label: stat.$2, value: stat.$3),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(s.t('profile_stamps'), style: sectionStyle),
            const SizedBox(height: 4),
            Text(
              s.t('profile_stampsCollected', {
                'count': progress.stampsCollected,
                'total': Continent.values.length,
              }),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 10.0;
                final columns = constraints.maxWidth >= 560 ? 3 : 2;
                final width =
                    ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                        .floorToDouble();
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final continent in Continent.values)
                      SizedBox(
                        width: width,
                        child: _StampCard(
                          continent: continent,
                          correct: progress.correctIn(continent),
                          strings: s,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(s.t('profile_highScores'), style: sectionStyle),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  for (final mode in GameMode.values)
                    ListTile(
                      leading: Text(mode.emoji, style: const TextStyle(fontSize: 24)),
                      title: Text(s.modeTitle(mode)),
                      trailing: Text(
                        '${progress.highScoreFor(mode)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.progress, required this.strings});

  final PlayerProgress progress;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: BrandColors.oceanGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Text(
                  '${progress.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.rank(progress.rank),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      strings.t('xp', {'xp': progress.xp}),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.levelProgress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              color: BrandColors.sunset,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            strings.t('profile_xpToNext', {
              'xp': progress.xpToNextLevel,
              'level': progress.level + 1,
            }),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.emoji, required this.label, required this.value});

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StampCard extends StatelessWidget {
  const _StampCard({
    required this.continent,
    required this.correct,
    required this.strings,
  });

  final Continent continent;
  final int correct;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tier = PassportStamps.tierFor(correct);
    final next = PassportStamps.nextThreshold(correct);
    final color = switch (tier) {
      StampTier.gold => BrandColors.gold,
      StampTier.silver => BrandColors.silver,
      StampTier.bronze => BrandColors.bronze,
      StampTier.none => scheme.outline,
    };
    final locked = tier == StampTier.none;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(locked ? 18 : 40),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: locked ? 1 : 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Opacity(
                opacity: locked ? 0.4 : 1,
                child: Text(continent.emoji, style: const TextStyle(fontSize: 28)),
              ),
              const Spacer(),
              Text(
                strings.stampTier(tier),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: locked ? scheme.onSurfaceVariant : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            strings.continent(continent),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            next == null
                ? strings.t('profile_stampMax')
                : strings.t('profile_stampProgress', {'count': correct, 'next': next}),
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
