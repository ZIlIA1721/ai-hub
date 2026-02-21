import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  final Box _settingsBox = Hive.box('settings');
  
  ThemeNotifier() : super(true) {
    _loadTheme();
  }
  
  void _loadTheme() {
    final isDark = _settingsBox.get('isDarkMode', defaultValue: true);
    state = isDark;
  }
  
  void toggleTheme() {
    state = !state;
    _settingsBox.put('isDarkMode', state);
  }
  
  void setDarkMode(bool isDark) {
    state = isDark;
    _settingsBox.put('isDarkMode', isDark);
  }
}
