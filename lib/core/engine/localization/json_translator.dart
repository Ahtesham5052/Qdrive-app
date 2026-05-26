import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Qdrive/app/provider/app_settings_provider.dart';

class JsonTranslator {
  static String translate({
    required BuildContext context,
    required Map<dynamic, dynamic> rootJson,
    required String key,
  }) {
    final container = ProviderScope.containerOf(context, listen: false);

    final settings = container.read(appSettingsProvider);

    final languageCode = settings.language.code;

    final translations =
        Map<dynamic, dynamic>.from(rootJson['translations'] ?? {});

    final currentLanguage =
        Map<dynamic, dynamic>.from(
          translations[languageCode] ?? {},
        );

    final english =
        Map<dynamic, dynamic>.from(
          translations['en'] ?? {},
        );

    return currentLanguage[key]?.toString() ??
        english[key]?.toString() ??
        key;
  }
}