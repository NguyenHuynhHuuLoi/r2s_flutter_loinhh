import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/category.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ProductDatabase {
  static final ProductDatabase _instance = ProductDatabase._internal();
  static Database? _database;

  ProductDatabase._internal();

  factory ProductDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Thêm kiểm tra nếu bảng đã tồn tại
    var tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    print('Existing tables: $tables');

    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      categoryId INTEGER,
      quantity INTEGER,
      date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
      FOREIGN KEY (categoryId) REFERENCES categories(id)
    )
  ''');

    // Insert default categories
    await db.insert('categories', {'name': 'Electronics'});
    await db.insert('categories', {'name': 'Clothing'});
    await db.insert('categories', {'name': 'Books'});
  }

  Future<int> insertProduct(Product product) async {
    try {
      final db = await database;

      // Kiểm tra null an toàn
      if (product.categoryId == null) {
        throw Exception('Category ID don\'t be null');
      }

      // Kiểm tra category tồn tại
      final categoryExists = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [product.categoryId],
        limit: 1,
      );

      if (categoryExists.isEmpty) {
        throw Exception('Category does not exist');
      }

      final map = product.toMap();
      // Loại bỏ ID nếu null hoặc 0
      map.removeWhere(
            (key, value) => (key == 'id' && (value == null || value == 0)),
      );

      final id = await db.insert('products', map);
      return id;
    } catch (e) {
      debugPrint('Error insert: $e');
      rethrow;
    }
  }


  Future<void> updateProduct(Product product) async {
    try {
      final db = await database;
      // Chỉ update nếu product có id > 0 (đã tồn tại trong DB)
      if (product.id! <= 0) throw Exception('Invalid product ID for update');

      final count = await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );

      if (count == 0) {
        throw Exception('Product not found with ID: ${product.id}');
      }
      print('Product updated successfully');
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<List<Product>> getProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT p.* 
    FROM products p
    JOIN categories c ON p.categoryId = c.id
    WHERE p.name LIKE ? OR p.description LIKE ? OR c.name LIKE ?
    ''',
      ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((json) => Product.fromMap(json)).toList();
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('categories');
    print('Categories in DB: $result');

    if (result.isEmpty) {
      // Nếu chưa có category, thêm các category mặc định
      await _insertDefaultCategories(db);
      return await getCategories(); // Gọi đệ quy để lấy lại danh sách
    }

    return result.map((json) => Category.fromMap(json)).toList();
  }

  // Phương thức reset database
  Future<void> resetDatabase() async {
    try {
      final db = await database;

      // Xóa tất cả dữ liệu trong các bảng
      await db.delete('products');
      await db.delete('categories');

      // Thêm lại các categories mặc định
      await _insertDefaultCategories(db);

      print("Database reset successfully");
    } catch (e) {
      print("Error reset database: $e");
      rethrow;
    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    await db.insert('categories', {'name': 'Electronics'});
    await db.insert('categories', {'name': 'Clothing'});
    await db.insert('categories', {'name': 'Books'});
  }

  Future<String?> exportProductsToCSV(BuildContext context) async {
    try {
      final products = await getProducts(''); // Lấy tất cả sản phẩm
      final categories = await getCategories(); // Lấy danh sách danh mục

      // Tạo dữ liệu CSV với encoding UTF-8
      List<List<dynamic>> rows = [
        ["ID", "Tên sản phẩm", "Mô tả", "Danh mục", "Số lượng", "Ngày"],  // Tiêu đề các cột
      ];

      for (var product in products) {
        final category = categories.firstWhere(
              (c) => c.id == product.categoryId,
          orElse: () => Category(id: 0, name: 'Unknown'),
        );

        rows.add([
          product.id,
          product.name,
          product.description ?? '',
          category.name,
          product.quantity,
          product.date ?? 'No date',  // Đảm bảo thêm trường date vào CSV
        ]);
      }

      // Tạo file CSV với BOM UTF-8 để đảm bảo hiển thị đúng tiếng Việt
      final csv = const ListToCsvConverter().convert(rows);
      final csvData = utf8.encode('\uFEFF$csv'); // Thêm BOM UTF-8

      // Lưu file
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getApplicationDocumentsDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/products_$dateStr.csv';

      // Ghi file với encoding UTF-8
      await File(filePath).writeAsBytes(csvData); // Sử dụng writeAsBytes thay vì writeAsString

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File exported successfully to $filePath'),
          duration: Duration(seconds: 3),
        ),
      );

      return filePath;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exported CSV: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

}
