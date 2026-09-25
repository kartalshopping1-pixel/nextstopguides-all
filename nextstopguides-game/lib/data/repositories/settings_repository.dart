import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/strings.dart';
import '../../domain/entities/difficulty.dart';

/// App settings stored in shared_preferences. Reads are synchronous because
/// SharedPreferences is loaded once at startup.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Saved language, or the device language (Turkish devices start in Turkish).
  AppLanguage readLanguage() {
    final saved = _prefs.getString(AppConstants.languageKey);
    return AppLanguage.fromCode(
      saved ?? PlatformDispatcher.instance.locale.languageCode,
    );
  }

  Future<void> writeLanguage(AppLanguage language) async {
    await _prefs.setString(AppConstants.languageKey, language.code);
  }

  Difficulty readDefaultDifficulty() {
    final saved = _prefs.getString(AppConstants.difficultyKey);
    for (final d in Difficulty.values) {
      if (d.name == saved) {
        return d;
      }
    }
    return Difficulty.easy;
  }

  Future<void> writeDefaultDifficulty(Difficulty difficulty) async {
    await _prefs.setString(AppConstants.difficultyKey, difficulty.name);
  }

  ThemeMode readThemeMode() {
    final saved = _prefs.getString(AppConstants.themeModeKey);
    for (final mode in ThemeMode.values) {
      if (mode.name == saved) {
        return mode;
      }
    }
    return ThemeMode.system;
  }

  Future<void> writeThemeMode(ThemeMode mode) async {
    await _prefs.setString(AppConstants.themeModeKey, mode.name);
  }
}
