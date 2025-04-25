import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'Music Pomodoro',
      'player': 'Player',
      'pomodoro': 'Pomodoro',
      'developed_by': 'Developed by Vitaliy Zaburdaev & GPT-4',
      'play': 'Play',
      'pause': 'Pause',
      'next': 'Next',
      'prev': 'Previous',
      'start': 'Start',
      'stop': 'Stop',
      'reset': 'Reset',
      'minutes': 'minutes',
      'seconds': 'seconds',
      'pomodoro_timer': 'Pomodoro Timer',
      'choose_mood': 'Choose Your Mood',

      // Category titles
      'category_lofi_title': 'Lo-fi',
      'category_ambient_title': 'Ambient',
      'category_nature_title': 'Nature',
      'category_radio_title': 'Coding Radio',
      'category_noise_title': 'White Noise',
      'category_meditation_title': 'Meditation',

      // Category descriptions
      'category_lofi_desc': 'Relaxing beats for coding',
      'category_ambient_desc': 'Atmospheric',
      'category_nature_desc': 'Peaceful nature',
      'category_radio_desc': 'Live coding stations',
      'category_noise_desc': 'Focus enhancing sounds',
      'category_meditation_desc': 'Music for meditation',
    },
    'uk': {
      'app_title': 'Музичний Pomodoro',
      'player': 'Плеєр',
      'pomodoro': 'Помодоро',
      'developed_by': 'Розроблено Віталієм Забурдаєвим та GPT-4',
      'play': 'Відтворити',
      'pause': 'Пауза',
      'next': 'Далі',
      'prev': 'Назад',
      'start': 'Старт',
      'stop': 'Стоп',
      'reset': 'Скинути',
      'minutes': 'хвилин',
      'seconds': 'секунд',
      'pomodoro_timer': 'Таймер Помодоро',
      'choose_mood': 'Обери настрій',

      // Category titles
      'category_lofi_title': 'Ло-фай',
      'category_ambient_title': 'Ембієнт',
      'category_nature_title': 'Природа',
      'category_radio_title': 'Кодінг-радіо',
      'category_noise_title': 'Білий шум',
      'category_meditation_title': 'Медитація',

      // Category descriptions
      'category_lofi_desc': 'Розслаблююча музика для кодування',
      'category_ambient_desc': 'Атмосферна музика',
      'category_nature_desc': 'Звуки природи',
      'category_radio_desc': 'Онлайн-станції для кодування',
      'category_noise_desc': 'Звуки для концентрації',
      'category_meditation_desc': 'Музика для медитації',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Получить название категории по id
  String categoryTitle(String id) {
    return get('category_${id}_title');
  }

  // Получить описание категории по id
  String categoryDescription(String id) {
    return get('category_${id}_desc');
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const localizationsDelegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'uk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}