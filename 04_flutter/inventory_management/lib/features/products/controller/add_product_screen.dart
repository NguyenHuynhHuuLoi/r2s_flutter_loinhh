import 'package:flutter/material.dart';
import 'package:inventory_management/data/datasources/product_database.dart';
import 'package:inventory_management/data/models/category.dart';
import 'package:inventory_management/data/models/product.dart';
import 'package:inventory_management/core/utils/app_colors.dart';
import 'package:inventory_management/core/utils/validators.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;

  int? _selectedCategoryId;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '');

    _loadCategories().then((_) {
      if (widget.product != null) {
        _selectedCategoryId = widget.product?.categoryId;
      } else if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
      }
    });
  }

  Future<void> _loadCategories() async {
    final categories = await ProductDatabase().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _saveProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (_selectedCategoryId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a category')),
          );
          return;
        }

        final product = Product(
          id: widget.product?.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategoryId!,
          quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
        );

        if (widget.product != null) {
          await ProductDatabase().updateProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
        } else {
          await ProductDatabase().insertProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insert product successfully')),
          );
        }

        if (!mounted) return;
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.grey[600], fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Category',
            style: TextStyle(fontSize: 19, color: isDarkMode ? Colors.white : Colors.black54),
          ),
          SizedBox(width: 130),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedCategoryId,
                isExpanded: true,
                hint: Text('Select category', style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey[600])),
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name, style: TextStyle(fontSize: 19, color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : AppColors.baseWhite,
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          widget.product?.name == null ? 'Add Product' : 'Edit Product',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(controller: _nameController, hint: 'Name', validator: (value) => Validators.validateRequired(value, field: 'Product Name')),
              const SizedBox(height: 16),
              _buildInputField(controller: _descriptionController, hint: 'Description', maxLines: 3, validator: (value) => Validators.validateRequired(value, field: 'Description')),
              const SizedBox(height: 16),
              _buildCategoryRow(),
              const SizedBox(height: 16),
              _buildInputField(controller: _quantityController, hint: 'Quantity', keyboardType: TextInputType.number, validator: (value) => Validators.validateRequired(value, field: 'Quantity')),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(
                  widget.product?.name == null ? 'Add Product' : 'Update Product',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
