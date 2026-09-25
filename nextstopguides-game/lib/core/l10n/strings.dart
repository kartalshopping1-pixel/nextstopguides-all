// All user-facing UI text lives here, in English and Turkish.
//
// How to add a language:
//   1. Add a value to AppLanguage (e.g. de('de', 'Deutsch', '🇩🇪')).
//   2. Add a `_de` map with the same keys as `_en`.
//   3. Return it from AppStrings._table.
// test/l10n/strings_test.dart checks that every language has every key.
//
// Note: travel data (country names, landmarks, fun facts) comes from the JSON
// files and is currently English only.

import '../../domain/engine/level_system.dart';
import '../../domain/entities/continent.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_mode.dart';
import '../../domain/entities/passport_stamp.dart';
import '../../domain/entities/question.dart';

enum AppLanguage {
  en('en', 'English', '🇬🇧'),
  tr('tr', 'Türkçe', '🇹🇷');

  const AppLanguage(this.code, this.nativeName, this.flag);

  final String code;
  final String nativeName;
  final String flag;

  static AppLanguage fromCode(String? code) {
    for (final language in AppLanguage.values) {
      if (language.code == code) {
        return language;
      }
    }
    return AppLanguage.en;
  }
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  static const AppStrings english = AppStrings(AppLanguage.en);
  static const AppStrings turkish = AppStrings(AppLanguage.tr);

  static AppStrings of(AppLanguage language) =>
      language == AppLanguage.tr ? turkish : english;

  /// Raw tables - exposed for tests.
  static Map<String, String> tableFor(AppLanguage language) =>
      _table(language);

  static Map<String, String> _table(AppLanguage language) =>
      switch (language) {
        AppLanguage.en => _en,
        AppLanguage.tr => _tr,
      };

  /// Translates [key] and replaces {placeholders} with [args].
  String t(String key, [Map<String, Object> args = const {}]) {
    var value = _table(language)[key] ?? _en[key] ?? key;
    for (final entry in args.entries) {
      value = value.replaceAll('{${entry.key}}', '${entry.value}');
    }
    return value;
  }

  // Convenience helpers ------------------------------------------------------

  String get appTitle => t('appTitle');

  String modeTitle(GameMode mode) => t('mode_${mode.name}_title');

  String modeDescription(GameMode mode) => t('mode_${mode.name}_desc');

  String difficulty(Difficulty difficulty) =>
      t('difficulty_${difficulty.name}');

  String continent(Continent continent) => t('continent_${continent.name}');

  String clueLabel(ClueType type) => t('clue_${type.name}');

  /// Clue value ready for display (continents are localized).
  String clueValue(Clue clue) {
    if (clue.type == ClueType.continent) {
      for (final c in Continent.values) {
        if (c.name == clue.value) {
          return continent(c);
        }
      }
    }
    return clue.value;
  }

  String prompt(Question question) =>
      t('q_${question.type.name}', {'subject': question.subject});

  String stampTier(StampTier tier) => t('stamp_${tier.name}');

  String rank(TravelerRank rank) => t('rank_${rank.name}');

  String productTitle(String productId, String fallback) {
    final key = 'product_${productId}_title';
    return _en.containsKey(key) ? t(key) : fallback;
  }

  String productDescription(String productId, String fallback) {
    final key = 'product_${productId}_desc';
    return _en.containsKey(key) ? t(key) : fallback;
  }

  // English ------------------------------------------------------------------

  static const Map<String, String> _en = {
    'appTitle': 'NextStop Trivia',
    'appTagline': 'Explore the world, one question at a time',
    'play': 'Play',
    'retry': 'Retry',
    'cancel': 'Cancel',
    'reset': 'Reset',
    'close': 'Close',

    // Navigation
    'nav_home': 'Explore',
    'nav_passport': 'Passport',
    'nav_shop': 'Shop',
    'nav_settings': 'Settings',

    // Home
    'home_greeting': 'Where to next, traveler?',
    'home_chooseMode': 'Choose a game mode',
    'home_dailyDone': 'Completed today ✓ Come back tomorrow!',
    'home_dailyAvailable': "Today's challenge is ready!",
    'home_dailyStreak': 'Daily streak: {count}',
    'level': 'Level {level}',
    'xp': '{xp} XP',
    'hintsCount': '{count} hints',
    'bestScore': 'Best: {score}',

    // Difficulty
    'difficulty_title': 'Difficulty',
    'difficulty_easy': 'Easy',
    'difficulty_medium': 'Medium',
    'difficulty_hard': 'Hard',

    // Modes
    'mode_guessCountry_title': 'Guess the Country',
    'mode_guessCountry_desc':
        'Unlock clues one by one. Fewer clues, more points!',
    'mode_capitalQuiz_title': 'Capital Quiz',
    'mode_capitalQuiz_desc': 'Match countries with their capitals.',
    'mode_flagQuiz_title': 'Flag Quiz',
    'mode_flagQuiz_desc': 'Can you recognize the flags of the world?',
    'mode_landmarkCity_title': 'Landmarks & Cities',
    'mode_landmarkCity_desc': 'Which city is home to this famous sight?',
    'mode_survival_title': 'Survival',
    'mode_survival_desc': 'Endless questions, 3 lives. How far can you go?',
    'mode_daily_title': 'Daily Challenge',
    'mode_daily_desc': 'The same 10 questions for everyone today.',

    // Question prompts ({subject} is replaced)
    'q_countryFromClues': 'Which country is this?',
    'q_capitalOfCountry': 'What is the capital of {subject}?',
    'q_countryOfCapital': '{subject} is the capital of which country?',
    'q_flagToCountry': 'Which country does this flag belong to?',
    'q_cityFromLandmark': 'Which city is home to {subject}?',
    'q_countryOfCity': 'In which country is {subject}?',

    // Clues
    'clue_continent': 'Continent',
    'clue_population': 'Population',
    'clue_language': 'Language(s)',
    'clue_currency': 'Currency',
    'clue_landmark': 'Landmark',
    'clue_capital': 'Capital',
    'clue_flag': 'Flag',

    // Game
    'game_loading': 'Packing your bags…',
    'game_loadError': 'Could not load the travel data.',
    'game_question': 'Question {current}/{total}',
    'game_questionEndless': 'Question {current}',
    'game_score': 'Score',
    'game_streak': 'Streak',
    'game_lives': 'Lives',
    'game_clueCount': 'Clue {current}/{total}',
    'game_revealClue': 'Next clue (fewer points)',
    'game_useHint': 'Use hint ({count})',
    'game_noHints': 'No hints left. Earn more by playing!',
    'game_correct': 'Correct! +{points} points',
    'game_wrong': 'Not quite! The answer was {answer}.',
    'game_funFact': 'Did you know?',
    'game_next': 'Next',
    'game_seeResults': 'See results',
    'game_quitTitle': 'Leave the game?',
    'game_quitBody': 'Your progress in this round will be lost.',
    'game_quit': 'Leave',
    'game_stay': 'Keep playing',
    'game_outOfLives': 'Out of lives!',
    'game_watchAdForLife': 'Watch an ad for an extra life',
    'game_adNotAvailable': 'No ad available right now.',

    // Results
    'results_title': 'Journey complete!',
    'results_score': 'Final score',
    'results_correct': '{correct} of {total} correct',
    'results_accuracy': 'Accuracy',
    'results_bestStreak': 'Best streak',
    'results_xpGained': '+{xp} XP',
    'results_levelUp': 'Level up! You reached level {level}.',
    'results_newHighScore': 'New high score!',
    'results_hintsEarned': 'You earned {count} hint(s)!',
    'results_stampUnlocked': 'New passport stamp: {continent} ({tier})',
    'results_dailyStreak': 'Daily streak: {count} day(s)',
    'results_dailyPractice':
        "Practice run: today's daily rewards were already claimed.",
    'results_playAgain': 'Play again',
    'results_home': 'Back to home',

    // Profile / passport
    'profile_title': 'My Passport',
    'profile_stats': 'Statistics',
    'profile_gamesPlayed': 'Games played',
    'profile_correctAnswers': 'Correct answers',
    'profile_accuracy': 'Accuracy',
    'profile_bestStreak': 'Best streak',
    'profile_dailyStreak': 'Daily streak',
    'profile_hints': 'Hints',
    'profile_highScores': 'High scores',
    'profile_stamps': 'Passport stamps',
    'profile_stampsCollected': '{count}/{total} continents stamped',
    'profile_stampProgress': '{count}/{next} correct answers',
    'profile_stampMax': 'Gold stamp collected!',
    'profile_xpToNext': '{xp} XP to level {level}',

    // Stamps
    'stamp_none': 'Locked',
    'stamp_bronze': 'Bronze',
    'stamp_silver': 'Silver',
    'stamp_gold': 'Gold',

    // Ranks
    'rank_tourist': 'Tourist',
    'rank_backpacker': 'Backpacker',
    'rank_explorer': 'Explorer',
    'rank_globetrotter': 'Globetrotter',
    'rank_ambassador': 'Travel Ambassador',

    // Continents
    'continent_africa': 'Africa',
    'continent_asia': 'Asia',
    'continent_europe': 'Europe',
    'continent_northAmerica': 'North America',
    'continent_southAmerica': 'South America',
    'continent_oceania': 'Oceania',

    // Shop
    'shop_title': 'Travel Shop',
    'shop_balance': 'Your hints: {count}',
    'shop_comingSoon': 'Coming soon',
    'shop_comingSoonBody':
        'The shop is being prepared. Keep playing to earn free hints!',
    'shop_buy': 'Buy',
    'shop_owned': 'Owned',
    'shop_restore': 'Restore purchases',
    'shop_earnFree': 'Earn free hints',
    'shop_earnRules':
        'Level up: +2 · First Daily Challenge of the day: +1 · Every 10 correct answers in a row: +1',
    'shop_purchaseFailed': 'The purchase could not be completed.',
    'shop_purchaseSuccess': 'Thank you for your purchase!',
    'product_remove_ads_title': 'Remove ads',
    'product_remove_ads_desc': 'Enjoy an ad-free journey forever.',
    'product_hints_pack_10_title': '10 hints',
    'product_hints_pack_10_desc': 'A small bag of hints for tricky questions.',
    'product_hints_pack_50_title': '50 hints',
    'product_hints_pack_50_desc': 'Best value for true explorers.',
    'product_premium_guides_title': 'Premium guide packs',
    'product_premium_guides_desc':
        'Themed question packs from NextStopGuides destinations.',

    // Settings
    'settings_title': 'Settings',
    'settings_language': 'Language',
    'settings_defaultDifficulty': 'Default difficulty',
    'settings_theme': 'Theme',
    'theme_system': 'System',
    'theme_light': 'Light',
    'theme_dark': 'Dark',
    'settings_resetProgress': 'Reset progress',
    'settings_resetProgressSubtitle':
        'Erase XP, high scores, stamps and hints',
    'settings_resetConfirmTitle': 'Reset all progress?',
    'settings_resetConfirmBody':
        'XP, high scores, passport stamps and hints will be erased. This cannot be undone.',
    'settings_resetDone': 'Progress reset.',
    'settings_about': 'About',
    'settings_aboutBody':
        'NextStop Trivia by NextStopGuides. Travel facts are for fun; always check official sources before your trip.',
    'settings_version': 'Version {version}',
  };

  // Turkish ------------------------------------------------------------------

  static const Map<String, String> _tr = {
    'appTitle': 'NextStop Trivia',
    'appTagline': 'Dünyayı keşfet, her soruda yeni bir durak',
    'play': 'Oyna',
    'retry': 'Tekrar dene',
    'cancel': 'İptal',
    'reset': 'Sıfırla',
    'close': 'Kapat',

    // Navigation
    'nav_home': 'Keşfet',
    'nav_passport': 'Pasaport',
    'nav_shop': 'Mağaza',
    'nav_settings': 'Ayarlar',

    // Home
    'home_greeting': 'Sıradaki durak neresi, gezgin?',
    'home_chooseMode': 'Bir oyun modu seç',
    'home_dailyDone': 'Bugün tamamlandı ✓ Yarın tekrar gel!',
    'home_dailyAvailable': 'Bugünün meydan okuması hazır!',
    'home_dailyStreak': 'Günlük seri: {count}',
    'level': 'Seviye {level}',
    'xp': '{xp} XP',
    'hintsCount': '{count} ipucu',
    'bestScore': 'Rekor: {score}',

    // Difficulty
    'difficulty_title': 'Zorluk',
    'difficulty_easy': 'Kolay',
    'difficulty_medium': 'Orta',
    'difficulty_hard': 'Zor',

    // Modes
    'mode_guessCountry_title': 'Ülkeyi Tahmin Et',
    'mode_guessCountry_desc':
        'İpuçlarını tek tek aç. Ne kadar az ipucu, o kadar çok puan!',
    'mode_capitalQuiz_title': 'Başkent Bilmecesi',
    'mode_capitalQuiz_desc': 'Ülkeleri başkentleriyle eşleştir.',
    'mode_flagQuiz_title': 'Bayrak Bilmecesi',
    'mode_flagQuiz_desc': 'Dünya bayraklarını tanıyabilir misin?',
    'mode_landmarkCity_title': 'Simgeler ve Şehirler',
    'mode_landmarkCity_desc': 'Bu ünlü yer hangi şehirde?',
    'mode_survival_title': 'Hayatta Kalma',
    'mode_survival_desc': 'Sonsuz soru, 3 can. Ne kadar ileri gidebilirsin?',
    'mode_daily_title': 'Günlük Meydan Okuma',
    'mode_daily_desc': 'Bugün herkes için aynı 10 soru.',

    // Question prompts
    'q_countryFromClues': 'Bu hangi ülke?',
    'q_capitalOfCountry': '{subject} ülkesinin başkenti neresidir?',
    'q_countryOfCapital': '{subject} hangi ülkenin başkentidir?',
    'q_flagToCountry': 'Bu bayrak hangi ülkeye ait?',
    'q_cityFromLandmark': '{subject} hangi şehirde bulunur?',
    'q_countryOfCity': '{subject} hangi ülkededir?',

    // Clues
    'clue_continent': 'Kıta',
    'clue_population': 'Nüfus',
    'clue_language': 'Dil(ler)',
    'clue_currency': 'Para birimi',
    'clue_landmark': 'Ünlü yer',
    'clue_capital': 'Başkent',
    'clue_flag': 'Bayrak',

    // Game
    'game_loading': 'Bavullar hazırlanıyor…',
    'game_loadError': 'Seyahat verileri yüklenemedi.',
    'game_question': 'Soru {current}/{total}',
    'game_questionEndless': 'Soru {current}',
    'game_score': 'Puan',
    'game_streak': 'Seri',
    'game_lives': 'Can',
    'game_clueCount': 'İpucu {current}/{total}',
    'game_revealClue': 'Sonraki ipucu (daha az puan)',
    'game_useHint': 'İpucu kullan ({count})',
    'game_noHints': 'İpucun kalmadı. Oynayarak yenilerini kazan!',
    'game_correct': 'Doğru! +{points} puan',
    'game_wrong': 'Olmadı! Doğru cevap: {answer}.',
    'game_funFact': 'Biliyor muydun?',
    'game_next': 'Sonraki',
    'game_seeResults': 'Sonuçları gör',
    'game_quitTitle': 'Oyundan çıkılsın mı?',
    'game_quitBody': 'Bu turdaki ilerlemen kaybolacak.',
    'game_quit': 'Çık',
    'game_stay': 'Devam et',
    'game_outOfLives': 'Canın kalmadı!',
    'game_watchAdForLife': 'Ekstra can için reklam izle',
    'game_adNotAvailable': 'Şu anda reklam yok.',

    // Results
    'results_title': 'Yolculuk tamamlandı!',
    'results_score': 'Toplam puan',
    'results_correct': '{total} sorudan {correct} doğru',
    'results_accuracy': 'İsabet',
    'results_bestStreak': 'En iyi seri',
    'results_xpGained': '+{xp} XP',
    'results_levelUp': 'Seviye atladın! Artık seviye {level}.',
    'results_newHighScore': 'Yeni rekor!',
    'results_hintsEarned': '{count} ipucu kazandın!',
    'results_stampUnlocked': 'Yeni pasaport damgası: {continent} ({tier})',
    'results_dailyStreak': 'Günlük seri: {count} gün',
    'results_dailyPractice':
        'Antrenman turu: bugünün günlük ödülleri zaten alındı.',
    'results_playAgain': 'Tekrar oyna',
    'results_home': 'Ana sayfaya dön',

    // Profile / passport
    'profile_title': 'Pasaportum',
    'profile_stats': 'İstatistikler',
    'profile_gamesPlayed': 'Oynanan oyun',
    'profile_correctAnswers': 'Doğru cevap',
    'profile_accuracy': 'İsabet',
    'profile_bestStreak': 'En iyi seri',
    'profile_dailyStreak': 'Günlük seri',
    'profile_hints': 'İpucu',
    'profile_highScores': 'Rekorlar',
    'profile_stamps': 'Pasaport damgaları',
    'profile_stampsCollected': '{count}/{total} kıta damgalandı',
    'profile_stampProgress': '{count}/{next} doğru cevap',
    'profile_stampMax': 'Altın damga alındı!',
    'profile_xpToNext': 'Seviye {level} için {xp} XP',

    // Stamps
    'stamp_none': 'Kilitli',
    'stamp_bronze': 'Bronz',
    'stamp_silver': 'Gümüş',
    'stamp_gold': 'Altın',

    // Ranks
    'rank_tourist': 'Turist',
    'rank_backpacker': 'Sırt Çantalı Gezgin',
    'rank_explorer': 'Kaşif',
    'rank_globetrotter': 'Dünya Gezgini',
    'rank_ambassador': 'Seyahat Elçisi',

    // Continents
    'continent_africa': 'Afrika',
    'continent_asia': 'Asya',
    'continent_europe': 'Avrupa',
    'continent_northAmerica': 'Kuzey Amerika',
    'continent_southAmerica': 'Güney Amerika',
    'continent_oceania': 'Okyanusya',

    // Shop
    'shop_title': 'Seyahat Mağazası',
    'shop_balance': 'İpucu bakiyen: {count}',
    'shop_comingSoon': 'Çok yakında',
    'shop_comingSoonBody':
        'Mağaza hazırlanıyor. Ücretsiz ipucu kazanmak için oynamaya devam et!',
    'shop_buy': 'Satın al',
    'shop_owned': 'Sahipsin',
    'shop_restore': 'Satın alımları geri yükle',
    'shop_earnFree': 'Ücretsiz ipucu kazan',
    'shop_earnRules':
        'Seviye atla: +2 · Günün ilk Günlük Meydan Okuması: +1 · Art arda her 10 doğru: +1',
    'shop_purchaseFailed': 'Satın alma tamamlanamadı.',
    'shop_purchaseSuccess': 'Satın aldığın için teşekkürler!',
    'product_remove_ads_title': 'Reklamları kaldır',
    'product_remove_ads_desc': 'Sonsuza dek reklamsız yolculuk.',
    'product_hints_pack_10_title': '10 ipucu',
    'product_hints_pack_10_desc': 'Zor sorular için küçük bir ipucu çantası.',
    'product_hints_pack_50_title': '50 ipucu',
    'product_hints_pack_50_desc': 'Gerçek kaşifler için en avantajlı paket.',
    'product_premium_guides_title': 'Premium rehber paketleri',
    'product_premium_guides_desc':
        'NextStopGuides rotalarından temalı soru paketleri.',

    // Settings
    'settings_title': 'Ayarlar',
    'settings_language': 'Dil',
    'settings_defaultDifficulty': 'Varsayılan zorluk',
    'settings_theme': 'Tema',
    'theme_system': 'Sistem',
    'theme_light': 'Açık',
    'theme_dark': 'Koyu',
    'settings_resetProgress': 'İlerlemeyi sıfırla',
    'settings_resetProgressSubtitle':
        'XP, rekorlar, damgalar ve ipuçları silinir',
    'settings_resetConfirmTitle': 'Tüm ilerleme sıfırlansın mı?',
    'settings_resetConfirmBody':
        'XP, rekorlar, pasaport damgaları ve ipuçları silinecek. Bu işlem geri alınamaz.',
    'settings_resetDone': 'İlerleme sıfırlandı.',
    'settings_about': 'Hakkında',
    'settings_aboutBody':
        'NextStopGuides tarafından NextStop Trivia. Seyahat bilgileri eğlence amaçlıdır; yolculuğundan önce resmi kaynakları kontrol et.',
    'settings_version': 'Sürüm {version}',
  };
}
