import 'package:inventory_management/data/datasources/product_database.dart';

class DashboardRepository {
  final ProductDatabase _database;

  DashboardRepository(this._database);

  Future<Map<String, int>> getCategoryCounts() async {
    final db = await _database.database;
    final result = await db.rawQuery('''
    SELECT c.name, 
           COALESCE(SUM(p.quantity), 0) as count
    FROM categories c
    LEFT JOIN products p ON c.id = p.categoryId
    GROUP BY c.id
  ''');

    final counts = <String, int>{};
    for (var row in result) {
      counts[row['name'] as String] = row['count'] as int;
    }
    return counts;
  }


  Future<int> getTotalProducts() async {
    final db = await _database.database;
    final result = await db.rawQuery('SELECT SUM(quantity) as count FROM products');
    return result.first['count'] as int? ?? 0;
  }

}