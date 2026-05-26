class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final bool isNew;
  final bool isSale;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.description,
    this.sizes = const [],
    this.colors = const [],
    this.isNew = false,
    this.isSale = false,
  });

  factory Product.fromMap(Map<String, dynamic> data, [String? docId]) {
    return Product(
      id: docId ?? data['id'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] as num).toDouble(),
      originalPrice: data['originalPrice'] != null
          ? (data['originalPrice'] as num).toDouble()
          : null,
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      reviews: (data['reviews'] as num).toInt(),
      description: data['description'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      isNew: data['isNew'] ?? false,
      isSale: data['isSale'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'sizes': sizes,
      'colors': colors,
      'isNew': isNew,
      'isSale': isSale,
    };
  }
}