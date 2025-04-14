import 'package:flutter/material.dart';
import 'package:inventory_management/features/dashboard/repository/dashboard_repository.dart';

class DashboardController with ChangeNotifier {
  final DashboardRepository _repository;

  DashboardController(this._repository);

  Map<String, int> _categoryCounts = {};
  int _totalProducts = 0;
  bool _isLoading = true;

  Map<String, int> get categoryCounts => _categoryCounts;
  int get totalProducts => _totalProducts;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categoryCounts = await _repository.getCategoryCounts();
      _totalProducts = await _repository.getTotalProducts();
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}