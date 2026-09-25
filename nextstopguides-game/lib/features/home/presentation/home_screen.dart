import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../domain/entities/difficulty.dart';
import '../../../domain/entities/game_mode.dart';
import '../../../domain/entities/player_progress.dart';
import '../../game/presentation/game_screen.dart';
import '../../profile/state/progress_controller.dart';
import '../../settings/state/settings_controller.dart';
import 'widgets/mode_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Difficulty picked on this screen; null = use the default from settings.
  Difficulty? _difficulty;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final settings = context.watch<SettingsController>();
    final progressController = context.watch<ProgressController>();
    final progress = progressController.progress;
    final difficulty = _difficulty ?? settings.defaultDifficulty;
    final modes = GameMode.values.where((m) => m != GameMode.daily).toList();

    void play(GameMode mode) {
      Navigator.of(context).pushNamed(
        AppRoutes.game,
        arguments: GameArgs(mode: mode, difficulty: difficulty),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _TravelerHeader(progress: progress, strings: s),
              const SizedBox(height: 16),
              _DailyCard(
                strings: s,
                isDone: progressController.isDailyDoneToday,
                dailyStreak: progress.dailyStreak,
                onPlay: () => play(GameMode.daily),
              ),
              const SizedBox(height: 20),
              Text(
                s.t('difficulty_title'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<Difficulty>(
                showSelectedIcon: false,
                segments: [
                  for (final d in Difficulty.values)
                    ButtonSegment<Difficulty>(value: d, label: Text(s.difficulty(d))),
                ],
                selected: {difficulty},
                onSelectionChanged: (selection) =>
                    setState(() => _difficulty = selection.first),
              ),
              const SizedBox(height: 20),
              Text(
                s.t('home_chooseMode'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 12.0;
                  final columns = constraints.maxWidth >= 560 ? 3 : 2;
                  final width =
                      ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                          .floorToDouble();
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final mode in modes)
                        SizedBox(
                          width: width,
                          height: 176,
                          child: ModeCard(
                            emoji: mode.emoji,
                            title: s.modeTitle(mode),
                            description: s.modeDescription(mode),
                            footer: progress.highScoreFor(mode) > 0
                                ? s.t('bestScore', {'score': progress.highScoreFor(mode)})
                                : null,
                            onTap: () => play(mode),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelerHeader extends StatelessWidget {
  const _TravelerHeader({required this.progress, required this.strings});

  final PlayerProgress progress;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              const Text('🌍', style: TextStyle(fontSize: 34)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.appTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      strings.t('home_greeting'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              _HeaderChip(icon: Icons.lightbulb, label: '${progress.hints}'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                strings.t('level', {'level': progress.level}),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '· ${strings.rank(progress.rank)}',
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                strings.t('xp', {'xp': progress.xp}),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.levelProgress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              color: BrandColors.sunset,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: BrandColors.gold, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard({
    required this.strings,
    required this.isDone,
    required this.dailyStreak,
    required this.onPlay,
  });

  final AppStrings strings;
  final bool isDone;
  final int dailyStreak;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(gradient: BrandColors.sunsetGradient),
        child: InkWell(
          onTap: onPlay,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Text(GameMode.daily.emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.modeTitle(GameMode.daily),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDone
                            ? strings.t('home_dailyDone')
                            : strings.t('home_dailyAvailable'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (dailyStreak > 0)
                        Text(
                          '🔥 ${strings.t('home_dailyStreak', {'count': dailyStreak})}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill, color: Colors.white, size: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
