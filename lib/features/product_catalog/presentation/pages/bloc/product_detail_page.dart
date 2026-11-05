import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/product_entity.dart';
import '../../state_bloc/cart_bloc.dart';
import '../../../../../core/constants/app_colors.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'UMKM Terverifikasi',
                style: TextStyle(
                  color: Color(0xFF065F46),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              currency.format(product.price),
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            const Text(
              'Deskripsi Produk',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            context.read<CartBloc>().add(AddToCartEvent(product));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berhasil masuk keranjang!'),
                duration: Duration(milliseconds: 700),
              ),
            );
          },
          child: const Text(
            '+ Tambah ke Keranjang',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
