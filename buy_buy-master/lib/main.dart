import 'package:buy_buy/bloc/bloc.dart';
import 'package:buy_buy/features/features.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:buy_buy/router/router.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BuyBuyApp());
}

class BuyBuyApp extends StatefulWidget {
  const BuyBuyApp({super.key});

  @override
  State<BuyBuyApp> createState() => _BuyBuyAppState();
}

class _BuyBuyAppState extends State<BuyBuyApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepositoryInterface>(create: (context) => UserRepository()),
        RepositoryProvider<CategoryRepositoryInterface>(create: (context) => CategoryRepository()),
        RepositoryProvider<ProductRepositoryInterface>(create: (context) => ProductRepository()),
        RepositoryProvider<FavoriteRepositoryInterface>(create: (context) => FavoriteRepository()),
        RepositoryProvider<CartRepositoryInterface>(create: (context) => CartRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(userRepository: context.read<UserRepositoryInterface>())),
          BlocProvider(
            create: (context) => CategoryBloc(categoryRepository: context.read<CategoryRepositoryInterface>()),
          ),
          BlocProvider(
            create:
                (context) => ProductBloc(
                  productRepository: context.read<ProductRepositoryInterface>(),
                  favoriteRepository: context.read<FavoriteRepositoryInterface>(),
                ),
          ),
          BlocProvider(
            create: (context) => ProductDetailBloc(productRepository: context.read<ProductRepositoryInterface>()),
          ),
          BlocProvider(create: (context) => BrandBloc(productRepository: context.read<ProductRepositoryInterface>())),
          BlocProvider(
            create:
                (context) => FavoritesBloc(
                  favoriteRepository: context.read<FavoriteRepositoryInterface>(),
                  productRepository: context.read<ProductRepositoryInterface>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => CartBloc(
                  cartRepository: context.read<CartRepositoryInterface>(),
                  productRepository: context.read<ProductRepositoryInterface>(),
                ),
          ),
        ],
        child: MaterialApp.router(
          theme: themeData,
          debugShowCheckedModeBanner: false,
          title: 'Buy-Buy',
          routerConfig: _router.config(),
        ),
      ),
    );
  }
}
