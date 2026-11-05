import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_riverpod_state.dart';

// 1. Provider UseCase (Diinjeksi dari main)
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  throw UnimplementedError('Di-override di main.dart');
});

// 2. Provider Katalog Produk (autoDispose melepaskan alokasi memori saat tidak dipakai)
final productRiverpodProvider =
    StateNotifierProvider.autoDispose<ProductNotifier, ProductRiverpodState>((
      ref,
    ) {
      final useCase = ref.watch(getProductsUseCaseProvider);
      return ProductNotifier(useCase);
    });

// 3. Provider Keranjang Belanja (Global State)
final cartRiverpodProvider =
    StateNotifierProvider<CartNotifier, List<CartItemEntity>>((ref) {
      return CartNotifier();
    });

// --- LOGIKA PRODUCT NOTIFIER ---
class ProductNotifier extends StateNotifier<ProductRiverpodState> {
  final GetProductsUseCase getProductsUseCase;

  ProductNotifier(this.getProductsUseCase)
    : super(const ProductRiverpodState(isLoading: true)) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final products = await getProductsUseCase.execute();
      state = state.copyWith(
        isLoading: false,
        allProducts: products,
        filteredProducts: products,
        selectedCategory: 'Semua',
        searchQuery: '',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void filterCategory(String category) {
    final filtered = _filterProducts(
      products: state.allProducts,
      category: category,
      query: state.searchQuery,
    );
    state = state.copyWith(
      selectedCategory: category,
      filteredProducts: filtered,
    );
  }

  void search(String query) {
    final filtered = _filterProducts(
      products: state.allProducts,
      category: state.selectedCategory,
      query: query,
    );
    state = state.copyWith(searchQuery: query, filteredProducts: filtered);
  }

  List<ProductEntity> _filterProducts({
    required List<ProductEntity> products,
    required String category,
    required String query,
  }) {
    return products.where((product) {
      final matchesCategory =
          (category == 'Semua') ||
          (product.category.toLowerCase() == category.toLowerCase());
      final cleanQuery = query.trim().toLowerCase();
      final matchesQuery =
          cleanQuery.isEmpty ||
          product.title.toLowerCase().contains(cleanQuery) ||
          product.description.toLowerCase().contains(cleanQuery);
      return matchesCategory && matchesQuery;
    }).toList();
  }
}

// --- LOGIKA CART NOTIFIER ---
class CartNotifier extends StateNotifier<List<CartItemEntity>> {
  CartNotifier() : super([]);

  void addToCart(ProductEntity product) {
    final List<CartItemEntity> updated = List.from(state);
    final index = updated.indexWhere((i) => i.product.id == product.id);

    if (index >= 0) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
    } else {
      updated.add(CartItemEntity(product: product, quantity: 1));
    }
    state = updated;
  }

  void removeOrDecrement(ProductEntity product) {
    final List<CartItemEntity> updated = List.from(state);
    final index = updated.indexWhere((i) => i.product.id == product.id);

    if (index >= 0) {
      if (updated[index].quantity > 1) {
        updated[index] = updated[index].copyWith(
          quantity: updated[index].quantity - 1,
        );
      } else {
        updated.removeAt(index);
      }
    }
    state = updated;
  }
}
