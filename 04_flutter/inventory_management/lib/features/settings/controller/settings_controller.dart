import 'package:flutter/material.dart';
import '../repository/settings_repository.dart';

class SettingsController with ChangeNotifier {
  final SettingsRepository _repository;
  bool _isDarkMode = false;

  SettingsController(this._repository);

  bool get isDarkMode => _isDarkMode;

  Future<void> initialize(bool initialDarkMode) async {
    _isDarkMode = initialDarkMode;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _repository.setDarkMode(value);
    notifyListeners();
  }

  // Thêm phương thức reset database
  Future<void> resetDatabase() async {
    try {
      await _repository.resetDatabase();
      notifyListeners();  // Cập nhật UI khi đã reset database
    } catch (e) {
      throw Exception("Failed to reset the database: $e");
    }
  }
}