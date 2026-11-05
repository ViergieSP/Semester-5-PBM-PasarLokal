import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.fetchProductsFromApi();
      await localDataSource.cacheProducts(remoteProducts);
      return remoteProducts;
    } catch (e) {
      final localProducts = await localDataSource.getLastCachedProducts();
      
      if (localProducts.isNotEmpty) {
        return localProducts;
      } else {
        throw Exception('Koneksi internet terputus dan belum ada data cache.');
      }
    }
  }
}