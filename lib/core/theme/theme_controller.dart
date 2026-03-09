import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);
 static init() {
    bool result = PreferencesManager().getBool('theme') ?? true;
    themeNotifier.value = result ? ThemeMode.dark : ThemeMode.light;
  }

  static toggelTheme() async {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
      await PreferencesManager().setBool('theme', false);
    } else {
      themeNotifier.value = ThemeMode.dark;
      await PreferencesManager().setBool('theme', true);
    }
  }

  static bool isDark() => ThemeController.themeNotifier.value == ThemeMode.dark;
}
