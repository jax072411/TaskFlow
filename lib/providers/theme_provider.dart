import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storage = StorageService();

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeIndex = await _storage.getSetting('themeMode', defaultValue: 0);
    state = ThemeMode.values[themeIndex];
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _storage.setSetting('themeMode', mode.index);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }
}

// Custom color scheme provider
final colorSchemeProvider = StateNotifierProvider<ColorSchemeNotifier, ColorScheme>((ref) {
  return ColorSchemeNotifier();
});

class ColorSchemeNotifier extends StateNotifier<ColorScheme> {
  final StorageService _storage = StorageService();

  ColorSchemeNotifier() : super(ColorScheme.fromSeed(seedColor: Colors.blue)) {
    _loadColorScheme();
  }

  Future<void> _loadColorScheme() async {
    final primaryColorHex = await _storage.getSetting('primaryColor', defaultValue: 0xFF2196F3);
    state = ColorScheme.fromSeed(seedColor: Color(primaryColorHex));
  }

  Future<void> setPrimaryColor(Color color) async {
    state = ColorScheme.fromSeed(seedColor: color);
    await _storage.setSetting('primaryColor', color.value);
  }
}
