import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final appThemeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});