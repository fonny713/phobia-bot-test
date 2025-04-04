class Phobia {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> therapySteps;

  Phobia({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.therapySteps,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'therapySteps': therapySteps,
    };
  }

  factory Phobia.fromJson(Map<String, dynamic> json) {
    return Phobia(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      therapySteps: List<String>.from(json['therapySteps']),
    );
  }
} 