

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management/features/products/view/product_list_screen.dart';
import 'package:inventory_management/features/settings/view/settings_screen.dart';
import 'package:inventory_management/features/dashboard/view/dashboard_screen.dart';

class NavigationHelper {
  static Future<void> navigateToProductList(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductListScreen()),
    );
  }

  static Future<void> navigateToSettings(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    );
  }

  static Future<void> navigateToDashboard(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen()),
    );
  }

  static void exitApp(BuildContext context) {
    SystemNavigator.pop();
  }
}
