class Company {
  final int id;
  final String name;
  final String description;
  final String color;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      color: json['color'] ?? '#28a745',
    );
  }
}
