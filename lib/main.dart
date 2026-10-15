import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Clean Architecture Wiring
import 'features/product_catalog/data/datasources/product_remote_datasource.dart';
import 'features/product_catalog/data/repositories/product_repository_impl.dart';
import 'features/product_catalog/domain/usecases/get_products_usecase.dart';
import 'features/product_catalog/presentation/state_bloc/product_bloc.dart';
import 'features/product_catalog/presentation/state_bloc/product_event.dart';
import 'features/product_catalog/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Data Source
  final httpClient = http.Client();
  final remoteDataSource = ProductRemoteDataSourceImpl(httpClient);

  // 2. Inisialisasi Repository
  final repository = ProductRepositoryImpl(remoteDataSource);

  // 3. Inisialisasi UseCase
  final getProductsUseCase = GetProductsUseCase(repository);

  runApp(PasarLokalCleanApp(getProductsUseCase: getProductsUseCase));
}

class PasarLokalCleanApp extends StatelessWidget {
  final GetProductsUseCase getProductsUseCase;

  const PasarLokalCleanApp({super.key, required this.getProductsUseCase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(getProductsUseCase)..add(FetchProductsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'PasarLokal UMKM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059669)),
        ),
        home: const HomePage(),
      ),
    );
  }
}