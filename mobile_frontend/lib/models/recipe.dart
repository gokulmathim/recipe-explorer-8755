/// Recipe model representing a recipe item from the backend.
// PUBLIC_INTERFACE
class Recipe {
  /// Unique identifier of the recipe.
  final String id;

  /// Human-readable recipe title.
  final String title;

  /// URL for the recipe's main image.
  final String imageUrl;

  /// Short description or subtitle.
  final String description;

  /// List of ingredients text.
  final List<String> ingredients;

  /// Cooking steps/instructions.
  final List<String> steps;

  /// Optional duration in minutes.
  final int? duration;

  /// Optional difficulty label.
  final String? difficulty;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.duration,
    this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      description: json['description'] ?? '',
      ingredients: (json['ingredients'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      steps: (json['steps'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      duration: json['duration'] is int ? json['duration'] as int : int.tryParse('${json['duration'] ?? ''}'),
      difficulty: json['difficulty']?.toString(),
    );
  }
}
