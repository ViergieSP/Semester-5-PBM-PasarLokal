import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final String selectedCategory;
  final String searchQuery; // <-- Simpan query pencarian aktif

  const ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    selectedCategory,
    searchQuery,
  ];
}

class ProductErrorState extends ProductState {
  final String message;
  const ProductErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
