class Category {
  final int id;
  final String name;
  final String description;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      color: json['color'] ?? '#007bff',
    );
  }
}
