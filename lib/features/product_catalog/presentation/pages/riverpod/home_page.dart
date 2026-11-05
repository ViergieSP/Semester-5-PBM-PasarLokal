import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../state_riverpod/product_riverpod_notifier.dart';
import '../../widgets/category_chip_widget.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productRiverpodProvider);
    final cartItems = ref.watch(cartRiverpodProvider);
    final totalCartCount = cartItems.fold(0, (sum, i) => sum + i.quantity);

    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text('⚡ ', style: TextStyle(fontSize: 20)),
            Text(
              'PasarLokal (Riverpod)',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Ikon Keranjang dengan Badge Counter
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF334155),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
              ),
              if (totalCartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalCartCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: productState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : productState.errorMessage != null
          ? Center(child: Text('Error: ${productState.errorMessage}'))
          : Column(
              children: [
                // 1. Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: TextField(
                      onChanged: (query) {
                        ref
                            .read(productRiverpodProvider.notifier)
                            .search(query);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Cari produk (Riverpod Engine)...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),

                // 2. Kategori Dinamis
                Builder(
                  builder: (context) {
                    final dynamicCategories = [
                      'Semua',
                      ...productState.allProducts
                          .map((p) => p.category)
                          .toSet(),
                    ];

                    return SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        itemCount: dynamicCategories.length,
                        itemBuilder: (context, index) {
                          final cat = dynamicCategories[index];
                          return CategoryChipWidget(
                            label: cat.toUpperCase(),
                            isSelected: cat == productState.selectedCategory,
                            activeColor: const Color(
                              0xFF2563EB,
                            ), // <-- BERIKAN WARNA BIRU RIVERPOD DI SINI
                            onTap: () {
                              ref
                                  .read(productRiverpodProvider.notifier)
                                  .filterCategory(cat);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                // 3. Grid Katalog Produk
                Expanded(
                  child: productState.filteredProducts.isEmpty
                      ? const Center(
                          child: Text('Tidak ada produk untuk kategori ini'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: productState.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                productState.filteredProducts[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                ),
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currency.format(product.price),
                                        style: const TextStyle(
                                          color: Color(0xFF2563EB),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF2563EB,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(
                                                  cartRiverpodProvider.notifier,
                                                )
                                                .addToCart(product);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${product.title} masuk keranjang!',
                                                ),
                                                duration: const Duration(
                                                  milliseconds: 600,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            '+ Keranjang',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

      // 4. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF64748B),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
