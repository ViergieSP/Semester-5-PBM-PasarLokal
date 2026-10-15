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
          .get(Uri.parse('https://dummyjson.com/products/category/groceries'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List rawList = jsonMap['products'] ?? [];
        return rawList.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw const ServerFailure();
      }
    } catch (_) {
      return const [
        ProductModel(
          id: 101,
          title: 'Beras Organik Pandan Wangi 5kg',
          description: 'Beras organik lokal Karawang pulen tanpa kimia.',
          price: 75000,
          category: 'Beras & Pangan',
          imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
        ),
        ProductModel(
          id: 102,
          title: 'Kopi Robusta Sanggabuana 250g',
          description: 'Kopi lereng Sanggabuana khas aroma kuat alami.',
          price: 35000,
          category: 'Kopi Lokal',
          imageUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400',
        ),
      ];
    }
  }
}