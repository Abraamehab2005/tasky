import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/features/navigation/main_screen.dart';
import 'package:tasky/core/features/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager().init();

  await ThemeController.init();

  String? username = PreferencesManager().getString(StorageKey.username);
  runApp(Tasky(
    username: username,
  ));
}

class Tasky extends StatelessWidget {
  const Tasky({super.key, required this.username});
  final String? username;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode value, Widget? child) {
        return MaterialApp(
          title: "Tasky",
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: value,
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
}
