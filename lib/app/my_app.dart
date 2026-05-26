import 'package:Qdrive/app/provider/app_settings_provider.dart';
import 'package:Qdrive/app/configurations/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Qdrive/app/theme/provider/app_theme_provider.dart';
import '../core/engine/screen/screen_builder.dart';
import 'theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final appSettings = ref.watch(appSettingsProvider);

    return MaterialApp(
      title: 'QDrive',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      locale: appSettings.locale,

      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('fr', 'FR'),
        Locale('es', 'ES'),
        Locale('ar'),
        Locale('ur', 'PK'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder: (context, child) {
        return Directionality(
          textDirection: appSettings.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: ScreenBuilder(json: 
      AppRuntimeConfig.homeApiResponse
      
    
      
      
      ),
    );
  }
}
