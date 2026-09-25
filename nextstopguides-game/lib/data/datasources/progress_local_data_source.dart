import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

/// Reads/writes the progress JSON blob in shared_preferences
/// (localStorage on the web, NSUserDefaults on iOS, SharedPreferences on Android).
class ProgressLocalDataSource {
  ProgressLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Map<String, dynamic>? read() {
    final raw = _prefs.getString(AppConstants.progressStorageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> write(Map<String, dynamic> json) async {
    await _prefs.setString(AppConstants.progressStorageKey, jsonEncode(json));
  }

  Future<void> clear() async {
    await _prefs.remove(AppConstants.progressStorageKey);
  }
}
