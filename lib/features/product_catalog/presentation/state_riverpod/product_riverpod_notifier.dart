import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

// State AsyncValue otomatis mengurus Loading, Data, dan Error
final productRiverpodProvider =
    StateNotifierProvider.autoDispose<ProductNotifier, AsyncValue<List<ProductEntity>>>((ref) {
  throw UnimplementedError("Di-inject dari main.dart");
});

class ProductNotifier extends StateNotifier<AsyncValue<List<ProductEntity>>> {
  final GetProductsUseCase getProductsUseCase;

  ProductNotifier(this.getProductsUseCase) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await getProductsUseCase.execute();
      state = AsyncValue.data(products);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}