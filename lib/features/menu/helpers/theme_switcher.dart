import 'package:flutter/material.dart';
import 'package:prayer_beads/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

final themeModeSignal = signal<ThemeMode>(ThemeMode.system);

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
