import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management/data/models/category.dart';
import 'package:inventory_management/data/models/product.dart';
import 'package:inventory_management/features/settings/view/settings_screen.dart';
import 'package:inventory_management/features/products/controller/add_product_screen.dart';
import 'package:inventory_management/data/datasources/product_database.dart';

import '../../dashboard/view/dashboard_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> _products = [];
  late List<Category> _categories = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });
    _categories = await ProductDatabase().getCategories();
    _products = await ProductDatabase().getProducts(_searchQuery);
    setState(() {
      _isLoading = false;
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadData();
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen()),
    );

    if (result == true) {
      _loadData();
    }
  }

  void _showProductOptions(Product product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an option you want'),
          titleTextStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToEditProduct(product);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(product);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Product product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Do you want delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(product.id!);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await ProductDatabase().deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while deleting product: $e')),
      );
    }
  }

  String _getQuantityStatus(int quantity) {
    if (quantity < 100) return 'Near';
    if (quantity >= 100 && quantity < 200) return 'Sang';
    return 'Each';
  }

  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(product: product),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Color(0xFF000000),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Color(0xFFFFFFFF),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'dashboard') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
              } else if (value == 'exit') {
                SystemNavigator.pop();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'dashboard',
                child: Text(
                  'Dashboard',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Text(
                  'Settings',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              PopupMenuItem<String>(
                value: 'exit',
                child: Text(
                  'Exit',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: _navigateToAddProduct,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search products',
                prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
              ),
              onChanged: _searchProducts,
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: _products.isEmpty
                  ? Center(child: Text(
                'No product.',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ))
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final category = _categories.firstWhere(
                        (category) => category.id == product.categoryId,
                    orElse: () => Category(id: 0, name: 'Unknown'),
                  );

                  return GestureDetector(
                    onTap: () => _showProductOptions(product),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  product.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _getQuantityStatus(product.quantity),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
