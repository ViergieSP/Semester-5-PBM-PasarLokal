import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

class ProductRiverpodState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const ProductRiverpodState({
    this.isLoading = false,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
    this.errorMessage,
  });

  ProductRiverpodState copyWith({
    bool? isLoading,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ProductRiverpodState(
      isLoading: isLoading ?? this.isLoading,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    allProducts,
    filteredProducts,
    selectedCategory,
    searchQuery,
    errorMessage,
  ];
}
