import 'package:buoi01/basic/layouts/demo/product.dart';
import 'package:buoi01/basic/layouts/demo/product_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProductList());
}


class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _ProductList());
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final products = _getAllProducts();

    return Scaffold(
      appBar: AppBar(title: Text('ProductList')),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index){
            final product = products[index];
            return  ListTile(
              leading: Image.asset(product.imagePath, width: 100, height: 100),
              title: Text(product.title),
              subtitle: Text('${product.description} \n${product.price}'),
            );
          },
      ),
    );

  }

  // Widget _buildHomePage(){
  //   final products = _getAllProducts();
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Product List',
  //       )),
  //
  //     body: const Column(
  //       children: [
  //         ProductWidget(
  //             imagePath: 'images/products/phone1.png',
  //             name: 'iPhone',
  //             description: 'iPhone2024',
  //             price: 2000),
  //
  //         ProductWidget(
  //             imagePath: 'images/products/samsung.jpg',
  //             name: 'SamSung',
  //             description: 'SamSung2024',
  //             price: 8900),
  //
  //         ProductWidget(
  //             imagePath: 'images/products/ipad.jpg',
  //             name: 'iPad',
  //             description: 'iPad2025',
  //             price: 4500),
  //       ],
  //     ),
  //   );
  // }
  //
  // Row _buildRow(String imagePath, String title, String description, num price) {
  //   return Row(
  //     children: [
  //       Image.asset(imagePath, width: 100, height: 100),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [Text(title), Text(description), Text('$price')],
  //       ),
  //     ],
  //   );
  // }

  List<Product> _getAllProducts(){
    return [
      Product(
        'images/products/phone1.png',
        'iPhone',
        'iPhone2024',
          8900,
      ),
      Product(
        'images/products/samsung.jpg',
        'SamSung',
        'SamSung2024',
        9700,
      ),
      Product(
        'images/products/ipad.jpg',
        'iPad',
        'iPad2025',
        4900,
      ),
    ];
  }
}