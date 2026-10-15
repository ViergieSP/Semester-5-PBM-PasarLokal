import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final int price;
  final String category;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, price, category, imageUrl];
}