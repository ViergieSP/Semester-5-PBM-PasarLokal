import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc(this.getProductsUseCase) : super(ProductInitial()) {
    // 1. Ambil Data Produk Pertama Kali
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getProductsUseCase.execute();
        emit(
          ProductLoaded(
            allProducts: products,
            filteredProducts: products,
            selectedCategory: 'Semua',
            searchQuery: '',
          ),
        );
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });

    // 2. Event Ganti Kategori (Tetap Mempertahankan Kata Kunci Search)
    on<FilterCategoryEvent>((event, emit) {
      if (state is ProductLoaded) {
        final current = state as ProductLoaded;
        final newCategory = event.category;

        final result = _filterProducts(
          products: current.allProducts,
          category: newCategory,
          query: current.searchQuery,
        );

        emit(
          ProductLoaded(
            allProducts: current.allProducts,
            filteredProducts: result,
            selectedCategory: newCategory,
            searchQuery: current.searchQuery,
          ),
        );
      }
    });

    // 3. Event Ketik Pencarian (Tetap Mempertahankan Kategori Aktif)
    on<SearchProductEvent>((event, emit) {
      if (state is ProductLoaded) {
        final current = state as ProductLoaded;
        final newQuery = event.query;

        final result = _filterProducts(
          products: current.allProducts,
          category: current.selectedCategory,
          query: newQuery,
        );

        emit(
          ProductLoaded(
            allProducts: current.allProducts,
            filteredProducts: result,
            selectedCategory: current.selectedCategory,
            searchQuery: newQuery,
          ),
        );
      }
    });
  }

  // FUNGSI PEMBANTU: Logika Gabungan Kategori + Pencarian
  List<ProductEntity> _filterProducts({
    required List<ProductEntity> products,
    required String category,
    required String query,
  }) {
    return products.where((product) {
      // Cek kecocokan Kategori
      final matchesCategory =
          (category == 'Semua') ||
          (product.category.toLowerCase() == category.toLowerCase());

      // Cek kecocokan Kata Kunci (Title atau Deskripsi)
      final cleanQuery = query.trim().toLowerCase();
      final matchesQuery =
          cleanQuery.isEmpty ||
          product.title.toLowerCase().contains(cleanQuery) ||
          product.description.toLowerCase().contains(cleanQuery);

      // Keduanya harus terpenuhi (AND)
      return matchesCategory && matchesQuery;
    }).toList();
  }
}
