import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastCachedProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedProductsKey = 'CACHED_PRODUCTS_KEY';

  ProductLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {
    final List<Map<String, dynamic>> jsonList = 
        productsToCache.map((product) => product.toJson()).toList();
    await sharedPreferences.setString(cachedProductsKey, json.encode(jsonList));
  }

  @override
  Future<List<ProductModel>> getLastCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}