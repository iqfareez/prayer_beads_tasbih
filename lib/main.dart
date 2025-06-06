import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'features/menu/helpers/theme_switcher.dart';
import 'features/tasbih/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadThemeMode();
  await loadThemeColor();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => MaterialApp(
        title: 'Tasbeeh',
        themeMode: themeModeSignal.value,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor.value),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeColor.value,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
        ),
        home: Home(),
      ),
    );
  }
}
