import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_config.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../domain/engine/game_session.dart';
import '../../../domain/entities/difficulty.dart';
import '../../../domain/entities/game_mode.dart';
import '../../../domain/repositories/travel_repository.dart';
import '../../../services/ads/ads_service.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../profile/state/progress_controller.dart';
import '../../results/presentation/results_screen.dart';
import '../../settings/state/settings_controller.dart';
import '../state/game_controller.dart';
import 'widgets/answer_option_tile.dart';
import 'widgets/clue_panel.dart';
import 'widgets/game_hud.dart';
import 'widgets/question_card.dart';

/// Arguments for the /game route.
class GameArgs {
  const GameArgs({required this.mode, required this.difficulty});

  final GameMode mode;
  final Difficulty difficulty;
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.args});

  final GameArgs args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>(
      create: (context) => GameController(
        mode: args.mode,
        difficulty: args.difficulty,
        travelRepository: context.read<TravelRepository>(),
        progress: context.read<ProgressController>(),
        ads: context.read<AdsService>(),
        analytics: context.read<AnalyticsService>(),
        config: context.read<AppConfig>(),
      )..start(),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final s = context.strings;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: s.t('game_quit'),
          onPressed: () => _confirmQuit(context, controller, s),
        ),
        title: Text('${controller.mode.emoji}  ${s.modeTitle(controller.mode)}'),
      ),
      body: SafeArea(
        child: switch (controller.status) {
          GameStatus.loading => _LoadingView(message: s.t('game_loading')),
          GameStatus.error => _ErrorView(
              message: s.t('game_loadError'),
              retryLabel: s.t('retry'),
              onRetry: controller.start,
            ),
          GameStatus.ready => const _PlayingView(),
        },
      ),
    );
  }

  Future<void> _confirmQuit(
    BuildContext context,
    GameController controller,
    AppStrings s,
  ) async {
    final session = controller.session;
    final hasProgress = session != null && session.answeredCount > 0 && !session.isOver;
    if (!hasProgress) {
      Navigator.of(context).pop();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.t('game_quitTitle')),
        content: Text(s.t('game_quitBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.t('game_stay')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(s.t('game_quit')),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _PlayingView extends StatelessWidget {
  const _PlayingView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final session = controller.session!;
    final question = session.current;
    final s = context.strings;

    return ResponsiveCenter(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          GameHud(session: session, strings: s),
          const SizedBox(height: 16),
          QuestionCard(question: question, prompt: s.prompt(question)),
          if (question.isClueBased) ...[
            const SizedBox(height: 12),
            CluePanel(
              question: question,
              revealed: session.cluesRevealed,
              strings: s,
              showAll: session.isAnswered,
              onRevealNext: session.canRevealClue ? controller.revealClue : null,
            ),
          ],
          const SizedBox(height: 16),
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AnswerOptionTile(
                label: question.options[i],
                index: i,
                state: _optionState(session, i),
                onTap: session.isAnswered || session.eliminated.contains(i)
                    ? null
                    : () => controller.answer(i),
              ),
            ),
          const SizedBox(height: 6),
          if (!session.isAnswered)
            _HintButton(controller: controller, strings: s)
          else
            _FeedbackPanel(controller: controller, strings: s),
        ],
      ),
    );
  }

  static AnswerOptionState _optionState(GameSession session, int index) {
    final result = session.lastResult;
    if (result == null) {
      return session.eliminated.contains(index)
          ? AnswerOptionState.eliminated
          : AnswerOptionState.idle;
    }
    if (index == result.correctIndex) {
      return AnswerOptionState.correct;
    }
    if (index == result.selectedIndex) {
      return AnswerOptionState.wrong;
    }
    return AnswerOptionState.dimmed;
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({required this.controller, required this.strings});

  final GameController controller;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final hints = context.select<ProgressController, int>((p) => p.progress.hints);
    final session = controller.session!;
    return Align(
      alignment: Alignment.center,
      child: TextButton.icon(
        onPressed: session.canUseHint
            ? () async {
                final messenger = ScaffoldMessenger.of(context);
                final used = await controller.useHint();
                if (!used) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.t('game_noHints'))),
                  );
                }
              }
            : null,
        icon: const Icon(Icons.lightbulb_outline),
        label: Text(strings.t('game_useHint', {'count': hints})),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({required this.controller, required this.strings});

  final GameController controller;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final session = controller.session!;
    final result = session.lastResult!;
    final question = session.current;
    final color = result.isCorrect ? BrandColors.palm : BrandColors.coral;
    final outOfLives = session.mode.hasLives && session.lives <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(120)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.isCorrect
                    ? strings.t('game_correct', {'points': result.points})
                    : strings.t('game_wrong', {'answer': question.correctAnswer}),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              if (question.funFact.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  '💡 ${strings.t('game_funFact')}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(question.funFact),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (outOfLives) ...[
          Text(
            strings.t('game_outOfLives'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (controller.canOfferExtraLife) ...[
            OutlinedButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final ok = await controller.watchAdForExtraLife();
                if (!ok) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.t('game_adNotAvailable'))),
                  );
                }
              },
              icon: const Icon(Icons.ondemand_video),
              label: Text(strings.t('game_watchAdForLife')),
            ),
            const SizedBox(height: 8),
          ],
        ],
        if (session.isOver)
          FilledButton.icon(
            onPressed: controller.isFinishing ? null : () => _goToResults(context),
            icon: const Icon(Icons.emoji_events_outlined),
            label: Text(strings.t('game_seeResults')),
          )
        else
          FilledButton.icon(
            onPressed: controller.next,
            icon: const Icon(Icons.arrow_forward),
            label: Text(strings.t('game_next')),
          ),
      ],
    );
  }

  Future<void> _goToResults(BuildContext context) async {
    final navigator = Navigator.of(context);
    final summary = await controller.finish();
    navigator.pushReplacementNamed(
      AppRoutes.results,
      arguments: ResultsArgs(
        summary: summary,
        replay: GameArgs(mode: controller.mode, difficulty: controller.difficulty),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✈️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧭', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
