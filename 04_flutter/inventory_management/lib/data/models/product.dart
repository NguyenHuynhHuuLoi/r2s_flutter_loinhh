class Product {
  final int? id;
  final String name;
  final String description;
  final int? categoryId; // Cho phép nullable
  final int quantity;
  final String? date;  // Cột date (nullable)

  Product({
    this.id,
    required this.name,
    required this.description,
    this.categoryId,
    required this.quantity,
    this.date,  // Thêm tham số date
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null && id! > 0) 'id': id,
      'name': name,
      'description': description,
      if (categoryId != null) 'categoryId': categoryId,
      'quantity': quantity,
      if (date != null) 'date': date,  // Thêm cột date nếu có
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      categoryId: map['categoryId'],
      quantity: map['quantity'],
      date: map['date'],  // Lấy cột date từ database
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    int? categoryId,
    int? quantity,
    String? date,  // Thêm tham số date nếu cần
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    categoryId: categoryId ?? this.categoryId,
    quantity: quantity ?? this.quantity,
    date: date ?? this.date,  // Thêm tham số date nếu cần
  );
}
