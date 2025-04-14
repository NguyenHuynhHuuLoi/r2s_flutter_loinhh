import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import '../../../data/datasources/product_database.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isResetting = false;  // Trạng thái reset

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Kiểm tra chế độ tối

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card chế độ Dark Mode
            Container(
              width: double.infinity,
              height: 100,
              child: Card(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.wb_sunny, color: isDarkMode ? Colors.white : Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Dark Mode',
                            style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                      Consumer<SettingsController>(
                        builder: (context, controller, child) {
                          return Switch(
                            value: controller.isDarkMode,
                            onChanged: (value) {
                              controller.toggleDarkMode(value);
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Card chức năng Export Data
            Container(
              width: double.infinity,
              height: 100,
              child: Card(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: isDarkMode ? Colors.white : Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Export Data',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                      InkWell(
                        splashColor: Colors.blue.withOpacity(0.1),
                        highlightColor: Colors.blue.withOpacity(0.05),
                        onTap: () => _exportCSV(context),
                        child: Row(
                          children: [
                            Text(
                              'CSV',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Card chức năng Reset Database
            InkWell(
              onTap: _isResetting ? null : _resetDatabase,
              child: Container(
                width: double.infinity,
                height: 100,
                child: Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.restore, color: isDarkMode ? Colors.white : Colors.black),
                        SizedBox(width: 10),
                        Text(
                          _isResetting ? 'Resetting Database...' : 'Reset Database',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isResetting ? Colors.grey : (isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetDatabase() async {
    setState(() {
      _isResetting = true;
    });

    try {
      await Provider.of<SettingsController>(context, listen: false).resetDatabase();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database reset successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isResetting = false;
      });
    }
  }

  Future<void> _exportCSV(BuildContext context) async {
    try {
      final filePath = await ProductDatabase().exportProductsToCSV(context);
      if (filePath != null) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The file has been saved at: $filePath'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
