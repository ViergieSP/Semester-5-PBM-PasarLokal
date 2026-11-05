import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../../../core/error/failures.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProductsFromApi();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> fetchProductsFromApi() async {
    try {
      final response = await client
          .get(Uri.parse('https://dummyjson.com/products?limit=50'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List rawList = jsonMap['products'] ?? [];
        return rawList.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw const ServerFailure('Gagal mengambil data dari server');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}