import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Clean Architecture Shared Layers
import 'features/product_catalog/data/datasources/product_remote_datasource.dart';
import 'features/product_catalog/data/datasources/product_local_datasource.dart';
import 'features/product_catalog/data/repositories/product_repository_impl.dart';
import 'features/product_catalog/domain/usecases/get_products_usecase.dart';

// Engine A: BLoC
import 'features/product_catalog/presentation/state_bloc/product_bloc.dart';
import 'features/product_catalog/presentation/state_bloc/product_event.dart';
import 'features/product_catalog/presentation/state_bloc/cart_bloc.dart';
import 'features/product_catalog/presentation/pages/bloc/home_page.dart'
    as bloc_ui;

// Engine B: Riverpod
import 'features/product_catalog/presentation/state_riverpod/product_riverpod_notifier.dart';
import 'features/product_catalog/presentation/pages/riverpod/home_page.dart'
    as riverpod_ui;

// ============================================================================
// SAKELAR PENGUJIAN (BENCHMARKING EXPERIMENT)
// - Ubah jadi 'false' : Menjalankan Engine BLoC (Katalog Hijau)
// - Ubah jadi 'true'  : Menjalankan Engine Riverpod (Katalog Biru)
// ============================================================================
const bool useRiverpod = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Storage Lokal (Offline-First)
  final sharedPreferences = await SharedPreferences.getInstance();

  // 2. Inisialisasi Data Sources (Remote & Local)
  final httpClient = http.Client();
  final remoteDataSource = ProductRemoteDataSourceImpl(httpClient);
  final localDataSource = ProductLocalDataSourceImpl(sharedPreferences);

  // 3. Inisialisasi Repository dengan Dukungan Cache Lokal
  final repository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // 4. Inisialisasi UseCase Tunggal
  final getProductsUseCase = GetProductsUseCase(repository);

  // Jalankan Aplikasi dengan Engine Sesuai Sakelar
  runApp(
    PasarLokalCleanApp(
      getProductsUseCase: getProductsUseCase,
      isRiverpod: useRiverpod,
    ),
  );
}

class PasarLokalCleanApp extends StatelessWidget {
  final GetProductsUseCase getProductsUseCase;
  final bool isRiverpod;

  const PasarLokalCleanApp({
    super.key,
    required this.getProductsUseCase,
    required this.isRiverpod,
  });

  @override
  Widget build(BuildContext context) {
    // KONDISI 1: JIKA MENGGUNAKAN ENGINE RIVERPOD
    if (isRiverpod) {
      return ProviderScope(
        overrides: [
          getProductsUseCaseProvider.overrideWithValue(getProductsUseCase),
        ],
        child: MaterialApp(
          title: 'PasarLokal UMKM (Riverpod Engine)',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2563EB),
            ),
          ),
          home: const riverpod_ui.HomePage(),
        ),
      );
    }

    // KONDISI 2: JIKA MENGGUNAKAN ENGINE BLOC
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) =>
              ProductBloc(getProductsUseCase)..add(FetchProductsEvent()),
        ),
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'PasarLokal UMKM (BLoC Engine)',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059669)),
        ),
        home: const bloc_ui.HomePage(),
      ),
    );
  }
}
