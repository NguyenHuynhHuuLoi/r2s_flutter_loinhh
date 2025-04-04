class Item{
  final int? id;
  final String? title;
  final String? description;
  final String? createdAt;

  Item({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}