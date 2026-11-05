import 'package:equatable/equatable.dart';
import 'product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.product,
    required this.quantity,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  int get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}