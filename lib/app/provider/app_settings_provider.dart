import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettingsState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return AppSettingsController(prefs);
    });

class AppLanguage {
  final String label;
  final String code;
  final Locale locale;
  final TextDirection direction;

  const AppLanguage({
    required this.label,
    required this.code,
    required this.locale,
    required this.direction,
  });
}

class AppCurrency {
  final String label;
  final String code;
  final String symbol;
  final int decimalDigits;

  const AppCurrency({
    required this.label,
    required this.code,
    required this.symbol,
    required this.decimalDigits,
  });
}

const supportedLanguages = <AppLanguage>[
  AppLanguage(
    label: 'English',
    code: 'en',
    locale: Locale('en', 'GB'),
    direction: TextDirection.ltr,
  ),
  AppLanguage(
    label: 'French',
    code: 'fr',
    locale: Locale('fr', 'FR'),
    direction: TextDirection.ltr,
  ),
  AppLanguage(
    label: 'Spanish',
    code: 'es',
    locale: Locale('es', 'ES'),
    direction: TextDirection.ltr,
  ),
  AppLanguage(
    label: 'Arabic',
    code: 'ar',
    locale: Locale('ar'),
    direction: TextDirection.rtl,
  ),
  AppLanguage(
    label: 'Urdu',
    code: 'ur',
    locale: Locale('ur', 'PK'),
    direction: TextDirection.rtl,
  ),
];

const supportedCurrencies = <AppCurrency>[
  AppCurrency(label: 'GBP (£)', code: 'GBP', symbol: '£', decimalDigits: 2),
  AppCurrency(label: 'EUR (€)', code: 'EUR', symbol: '€', decimalDigits: 2),
  AppCurrency(label: 'USD (\$)', code: 'USD', symbol: '\$', decimalDigits: 2),
  AppCurrency(label: 'AED (د.إ)', code: 'AED', symbol: 'د.إ', decimalDigits: 2),
  AppCurrency(label: 'PKR (₨)', code: 'PKR', symbol: '₨', decimalDigits: 0),
];

class AppSettingsState {
  final AppLanguage language;
  final AppCurrency currency;

  const AppSettingsState({required this.language, required this.currency});

  Locale get locale => language.locale;

  TextDirection get textDirection => language.direction;

  String get currencyCode => currency.code;

  String get currencySymbol => currency.symbol;

  factory AppSettingsState.initial(SharedPreferences prefs) {
    final savedLanguage = prefs.getString('app_language') ?? 'English';
    final savedCurrencyCode = prefs.getString('app_currency_code') ?? 'GBP';

    return AppSettingsState(
      language: _languageFromValue(savedLanguage),
      currency: _currencyFromValue(savedCurrencyCode),
    );
  }

  AppSettingsState copyWith({AppLanguage? language, AppCurrency? currency}) {
    return AppSettingsState(
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }

  String formatCurrency(num value) {
    return intl.NumberFormat.currency(
      locale: locale.toLanguageTag(),
      name: currency.code,
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    ).format(value);
  }
}

class AppSettingsController extends StateNotifier<AppSettingsState> {
  final SharedPreferences prefs;

  AppSettingsController(this.prefs) : super(AppSettingsState.initial(prefs));

  Future<void> updateFromSavedForm(Map<dynamic, dynamic> formData) async {
    final rawLanguage = formData['language']?.toString();
    final rawCurrency = formData['currency']?.toString();

    final nextLanguage = _languageFromValue(
      rawLanguage ?? state.language.label,
    );
    final nextCurrency = _currencyFromValue(rawCurrency ?? state.currency.code);

    await prefs.setString('app_language', nextLanguage.label);
    await prefs.setString('app_language_code', nextLanguage.code);
    await prefs.setString('app_currency_code', nextCurrency.code);
    await prefs.setString('app_currency_symbol', nextCurrency.symbol);

    intl.Intl.defaultLocale = nextLanguage.locale.toLanguageTag();

    state = state.copyWith(language: nextLanguage, currency: nextCurrency);
  }
}

AppLanguage _languageFromValue(String value) {
  final normalised = value.trim().toLowerCase();

  return supportedLanguages.firstWhere(
    (item) =>
        item.label.toLowerCase() == normalised ||
        item.code.toLowerCase() == normalised,
    orElse: () => supportedLanguages.first,
  );
}

AppCurrency _currencyFromValue(String value) {
  final normalised = value.trim().toUpperCase();

  return supportedCurrencies.firstWhere(
    (item) =>
        item.code.toUpperCase() == normalised ||
        item.label.toUpperCase() == normalised ||
        normalised.contains(item.code.toUpperCase()),
    orElse: () => supportedCurrencies.first,
  );
}
