class CategorieVoiture {
  final int id;
  final String title;
  final String description;
  final String image;
  final String mink;

CategorieVoiture({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.mink,
  });

  factory CategorieVoiture.fromJson(Map<String, dynamic> json) {
    return CategorieVoiture(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      mink: json['mink'] as String,
    );
  }
}
