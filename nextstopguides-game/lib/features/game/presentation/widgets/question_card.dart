import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/question.dart';

/// The question itself: a big emoji (flag / icon) and the prompt.
class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question, required this.prompt});

  final Question question;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    final isFlag = question.type == QuestionType.flagToCountry;
    final emoji = question.displayEmoji;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: BrandColors.oceanGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          if (emoji != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                emoji,
                style: TextStyle(fontSize: isFlag ? 96 : 44),
                semanticsLabel: isFlag ? 'flag' : null,
              ),
            ),
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }
}
