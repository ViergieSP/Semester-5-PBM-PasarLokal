import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../state_bloc/cart_bloc.dart';
import '../pages/bloc/product_detail_page.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductEntity product;
  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk & Badge UMKM
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: const Color(0xFFF1F5F9),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'UMKM',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Judul Produk
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF1E293B),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),

            // Harga Produk
            Text(
              currency.format(product.price),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const Spacer(),

            // Tombol Tambah ke Keranjang
            SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  context.read<CartBloc>().add(AddToCartEvent(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} masuk keranjang!'),
                      duration: const Duration(milliseconds: 600),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  '+ Keranjang',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
