import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../domain/entities/difficulty.dart';
import '../../profile/state/progress_controller.dart';
import '../state/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final settings = context.watch<SettingsController>();
    final theme = Theme.of(context);
    final sectionStyle =
        theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800);

    return Scaffold(
      appBar: AppBar(title: Text(s.t('settings_title'))),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(s.t('settings_language'), style: sectionStyle),
            const SizedBox(height: 8),
            SegmentedButton<AppLanguage>(
              showSelectedIcon: false,
              segments: [
                for (final language in AppLanguage.values)
                  ButtonSegment<AppLanguage>(
                    value: language,
                    label: Text('${language.flag}  ${language.nativeName}'),
                  ),
              ],
              selected: {settings.language},
              onSelectionChanged: (selection) =>
                  settings.setLanguage(selection.first),
            ),
            const SizedBox(height: 24),
            Text(s.t('settings_defaultDifficulty'), style: sectionStyle),
            const SizedBox(height: 8),
            SegmentedButton<Difficulty>(
              showSelectedIcon: false,
              segments: [
                for (final d in Difficulty.values)
                  ButtonSegment<Difficulty>(value: d, label: Text(s.difficulty(d))),
              ],
              selected: {settings.defaultDifficulty},
              onSelectionChanged: (selection) =>
                  settings.setDefaultDifficulty(selection.first),
            ),
            const SizedBox(height: 24),
            Text(s.t('settings_theme'), style: sectionStyle),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto),
                  label: Text(s.t('theme_system')),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode),
                  label: Text(s.t('theme_light')),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode),
                  label: Text(s.t('theme_dark')),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (selection) =>
                  settings.setThemeMode(selection.first),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.restart_alt, color: theme.colorScheme.error),
                    title: Text(s.t('settings_resetProgress')),
                    subtitle: Text(s.t('settings_resetProgressSubtitle')),
                    onTap: () => _confirmReset(context, s),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(s.t('settings_about')),
                    subtitle: Text(
                      '${s.t('settings_aboutBody')}\n'
                      '${s.t('settings_version', {'version': AppConstants.appVersion})}',
                    ),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppStrings s) async {
    final progress = context.read<ProgressController>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.t('settings_resetConfirmTitle')),
        content: Text(s.t('settings_resetConfirmBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(s.t('reset')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await progress.reset();
      messenger.showSnackBar(SnackBar(content: Text(s.t('settings_resetDone'))));
    }
  }
}
