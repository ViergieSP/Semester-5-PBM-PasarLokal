import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../state_riverpod/product_riverpod_notifier.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartRiverpodProvider);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang (Riverpod)'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: const Center(child: Text('Keranjang belanja masih kosong')),
      );
    }

    final subtotal = cartItems.fold(0, (sum, item) => sum + item.totalPrice);
    const biayaLayanan = 2000;
    final totalBayar = subtotal + biayaLayanan;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Keranjang Belanja (Riverpod)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                currency.format(item.product.price),
                                style: const TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 20,
                              ),
                              onPressed: () {
                                ref
                                    .read(cartRiverpodProvider.notifier)
                                    .removeOrDecrement(item.product);
                              },
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 20,
                              ),
                              onPressed: () {
                                ref
                                    .read(cartRiverpodProvider.notifier)
                                    .addToCart(item.product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Rincian Pembayaran
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal Produk',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      currency.format(subtotal),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Biaya Layanan UMKM',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      currency.format(biayaLayanan),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Tagihan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      currency.format(totalBayar),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Pesanan Berhasil Diproses (Riverpod Engine)!',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Checkout (${currency.format(totalBayar)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
