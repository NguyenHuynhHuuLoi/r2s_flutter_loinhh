import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_management/features/dashboard/controller/dashboard_controller.dart';

import '../../../routes/navigation_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardController>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DashboardController>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        automaticallyImplyLeading: false, // xóa nút back mặc định
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: isDarkMode ? Colors.white : Colors.black),
            onSelected: (value) {
              if (value == 'products') {
                NavigationHelper.navigateToProductList(context);  // Sử dụng NavigationHelper
              } else if (value == 'settings') {
                NavigationHelper.navigateToSettings(context);  // Sử dụng NavigationHelper
              } else if (value == 'exit') {
                NavigationHelper.exitApp(context);  // Thoát ứng dụng
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(value: 'products', child: Text('Product List')),
              PopupMenuItem<String>(value: 'settings', child: Text('Settings')),
              PopupMenuItem<String>(value: 'exit', child: Text('Exit App')),
            ],
          ),
        ],
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Inventory by Category',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 65,
                        sections: showingSections(controller),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        controller.categoryCounts.length,
                            (index) {
                          final entry = controller.categoryCounts.entries.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: _getColorForCategory(entry.key),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildSection('Total Products', controller.totalProducts.toString(), isDarkMode),
            SizedBox(height: 20),
            _buildSection('Stock in', controller.totalProducts.toString(), isDarkMode),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(DashboardController controller) {
    return List.generate(controller.categoryCounts.length, (i) {
      final entry = controller.categoryCounts.entries.elementAt(i);
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value.toDouble(),
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Electronics':
        return Color(0xFF6C4EFF);
      case 'Clothing':
        return Color(0xFF347FBB);
      case 'Books':
        return Color(0xFF90B7E0);
      default:
        return Colors.grey;
    }
  }

  Widget _buildSection(String title, String value, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
