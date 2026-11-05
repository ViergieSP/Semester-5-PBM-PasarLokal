import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] != null) ? (json['price'] * 15000).toInt() : 25000,
      category: json['category'] ?? 'Pangan',
      imageUrl: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]
          : 'https://via.placeholder.com/150',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'images': [imageUrl],
    };
  }
}