import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/datasources/product_database.dart';

class SettingsRepository {
  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode') ?? false;
  }

  // Phương thức reset database
  Future<void> resetDatabase() async {
    try {
      // Gọi đến database để reset
      await ProductDatabase().resetDatabase();
    } catch (e) {
      throw Exception("Failed to reset the database: $e");
    }
  }
}