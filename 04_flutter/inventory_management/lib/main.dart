import 'package:flutter/material.dart';
import 'package:inventory_management/data/datasources/product_database.dart';
import 'package:inventory_management/features/dashboard/controller/dashboard_controller.dart';
import 'package:inventory_management/features/dashboard/repository/dashboard_repository.dart';
import 'package:inventory_management/features/dashboard/view/dashboard_screen.dart';
import 'package:inventory_management/features/settings/controller/settings_controller.dart';
import 'package:inventory_management/features/settings/repository/settings_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsRepository = SettingsRepository();
  final isDarkMode = await settingsRepository.getDarkMode();

  runApp(MyApp(
    initialDarkMode: isDarkMode,
    settingsRepository: settingsRepository,
  ));
}

class MyApp extends StatelessWidget {
  final bool initialDarkMode;
  final SettingsRepository settingsRepository;
  final DashboardRepository _dashboardRepository;

  MyApp({
    required this.initialDarkMode,
    required this.settingsRepository,
  }) : _dashboardRepository = DashboardRepository(ProductDatabase());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardController(_dashboardRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsController(settingsRepository)..initialize(initialDarkMode),
        ),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settingsController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Inventory Management',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              cardColor: Colors.grey[800],
            ),
            themeMode: settingsController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: DashboardScreen(),
          );
        },
      ),
    );
  }
}