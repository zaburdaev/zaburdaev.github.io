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
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
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