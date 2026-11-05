import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductEntity product;
  const AddToCartEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class RemoveOrDecrementCartEvent extends CartEvent {
  final ProductEntity product;
  const RemoveOrDecrementCartEvent(this.product);
  @override
  List<Object?> get props => [product];
}

// State
class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get subtotalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object?> get props => [items];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>((event, emit) {
      final List<CartItemEntity> updatedItems = List.from(state.items);
      final index = updatedItems.indexWhere((i) => i.product.id == event.product.id);

      if (index >= 0) {
        updatedItems[index] = updatedItems[index].copyWith(
          quantity: updatedItems[index].quantity + 1,
        );
      } else {
        updatedItems.add(CartItemEntity(product: event.product, quantity: 1));
      }

      emit(CartState(items: updatedItems));
    });

    on<RemoveOrDecrementCartEvent>((event, emit) {
      final List<CartItemEntity> updatedItems = List.from(state.items);
      final index = updatedItems.indexWhere((i) => i.product.id == event.product.id);

      if (index >= 0) {
        if (updatedItems[index].quantity > 1) {
          updatedItems[index] = updatedItems[index].copyWith(
            quantity: updatedItems[index].quantity - 1,
          );
        } else {
          updatedItems.removeAt(index);
        }
      }

      emit(CartState(items: updatedItems));
    });
  }
}