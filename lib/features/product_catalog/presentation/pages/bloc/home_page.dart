import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state_bloc/product_bloc.dart';
import '../../state_bloc/product_event.dart';
import '../../state_bloc/product_state.dart';
import '../../state_bloc/cart_bloc.dart';
import '../../widgets/product_card_widget.dart';
import '../../widgets/category_chip_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Semua';
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text('🌱 ', style: TextStyle(fontSize: 20)),
            Text(
              'PasarLokal (BLoC)',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return Stack(
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
                  if (cartState.totalItemCount > 0)
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
                          '${cartState.totalItemCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProductLoaded) {
            final List<String> dynamicCategories = [
              'Semua',
              ...state.allProducts.map((p) => p.category).toSet(),
            ];

            final displayList = state.filteredProducts;

            return Column(
              children: [
                // 1. Kolom Input Pencarian
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
                        context.read<ProductBloc>().add(
                          SearchProductEvent(query),
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: 'Cari produk...',
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

                // 2. Filter Kategori Dinamis dari API
                SizedBox(
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
                        label: cat.toUpperCase(), // Tampilan rapi huruf besar
                        isSelected: cat == selectedCategory,
                        onTap: () {
                          setState(() {
                            selectedCategory = cat;
                          });
                          context.read<ProductBloc>().add(
                            FilterCategoryEvent(cat),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 3. Grid Produk
                Expanded(
                  child: displayList.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada produk untuk kategori ini',
                            style: TextStyle(color: Colors.grey),
                          ),
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
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            return ProductCardWidget(
                              product: displayList[index],
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is ProductErrorState) {
            return Center(child: Text('Terjadi kesalahan: ${state.message}'));
          }
          return const SizedBox();
        },
      ),

      // 4. Navigasi Bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
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
