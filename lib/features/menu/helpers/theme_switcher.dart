import 'package:flutter/material.dart';
import 'package:prayer_beads/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

/// The theme mode (ie light, dark, system)
final themeModeSignal = signal<ThemeMode>(ThemeMode.system);

/// The theme color of the bead and the app
final themeColor = signal<Color>(Colors.black);

Future<void> loadThemeMode() async {
  final prefs = SharedPreferencesAsync();
  final index = await prefs.getInt(kSpThemeMode) ?? ThemeMode.system.index;
  themeModeSignal.value = ThemeMode.values[index];
}

Future<void> setThemeMode(ThemeMode mode) async {
  themeModeSignal.value = mode;
  final prefs = SharedPreferencesAsync();
  await prefs.setInt(kSpThemeMode, mode.index);
}

Future<void> loadThemeColor() async {
  final prefs = SharedPreferencesAsync();
  final colorValue =
      await prefs.getInt(kSpThemeColor) ?? Colors.black.toARGB32();
  themeColor.value = Color(colorValue);
}

Future<void> setThemeColor(Color color) async {
  themeColor.value = color;
  final prefs = SharedPreferencesAsync();
  await prefs.setInt(kSpThemeColor, color.toARGB32());
  print('Saved theme color');
}
