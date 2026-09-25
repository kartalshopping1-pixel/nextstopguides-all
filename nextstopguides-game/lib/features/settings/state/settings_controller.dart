import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/strings.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../domain/entities/difficulty.dart';

/// Language, default difficulty and theme. Changing the language rebuilds
/// the whole app with the new strings.
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository)
      : _language = _repository.readLanguage(),
        _defaultDifficulty = _repository.readDefaultDifficulty(),
        _themeMode = _repository.readThemeMode();

  final SettingsRepository _repository;
  AppLanguage _language;
  Difficulty _defaultDifficulty;
  ThemeMode _themeMode;

  AppLanguage get language => _language;
  Difficulty get defaultDifficulty => _defaultDifficulty;
  ThemeMode get themeMode => _themeMode;
  AppStrings get strings => AppStrings.of(_language);

  Future<void> setLanguage(AppLanguage language) async {
    if (language == _language) {
      return;
    }
    _language = language;
    notifyListeners();
    await _repository.writeLanguage(language);
  }

  Future<void> setDefaultDifficulty(Difficulty difficulty) async {
    if (difficulty == _defaultDifficulty) {
      return;
    }
    _defaultDifficulty = difficulty;
    notifyListeners();
    await _repository.writeDefaultDifficulty(difficulty);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    await _repository.writeThemeMode(mode);
  }
}

extension AppStringsContext on BuildContext {
  /// Localized strings. Call inside build() - it listens for language changes.
  /// For callbacks, capture it in a local variable during build.
  AppStrings get strings => watch<SettingsController>().strings;
}
