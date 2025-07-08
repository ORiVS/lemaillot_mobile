class Category {
  final int id;
  final String categoryName;
  final String slug;

  Category({required this.id, required this.categoryName, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      slug: json['slug'],
    );
  }
}