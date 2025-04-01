class Phobia {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> therapySteps;
  bool isFavorite;

  Phobia({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.therapySteps,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'therapySteps': therapySteps,
      'isFavorite': isFavorite,
    };
  }

  factory Phobia.fromJson(Map<String, dynamic> json) {
    return Phobia(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      therapySteps: List<String>.from(json['therapySteps']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
} 