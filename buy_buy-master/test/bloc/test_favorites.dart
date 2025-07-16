import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:buy_buy/bloc/bloc.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoritesBloc', () {
    late FakeFavoriteRepository favoriteRepo;
    late FakeProductRepository productRepo;
    late FavoritesBloc favoritesBloc;

    final productA = Product(
      id: 'A',
      name: 'Alpha',
      description: '',
      price: 10.0,
      imageUrls: [],
      categoryId: 'c1',
      brandId: 'b1',
      isBrandNew: false,
    );
    final productB = Product(
      id: 'B',
      name: 'Beta',
      description: '',
      price: 20.0,
      imageUrls: [],
      categoryId: 'c1',
      brandId: 'b1',
      isBrandNew: false,
    );
    final productC = Product(
      id: 'C',
      name: 'Gamma',
      description: '',
      price: 30.0,
      imageUrls: [],
      categoryId: 'c2',
      brandId: 'b2',
      isBrandNew: true,
    );

    setUp(() {
      favoriteRepo = FakeFavoriteRepository();
      productRepo = FakeProductRepository(products: [productA, productB, productC]);
      favoritesBloc = FavoritesBloc(favoriteRepository: favoriteRepo, productRepository: productRepo);
    });

    tearDown(() {
      favoritesBloc.close();
    });

    blocTest<FavoritesBloc, FavoritesState>(
      'FavoritesLoadEvent emits [FavoritesLoading, FavoritesLoaded] with no favorites when repo is empty',
      build: () => favoritesBloc,
      act: (bloc) => bloc.add(FavoritesLoadEvent()),
      expect: () => <FavoritesState>[FavoritesLoading(), FavoritesLoaded(favorites: [])],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavorite via ToggleFavoriteEvent adds a product to favorites and reloads',
      build: () => favoritesBloc,
      act: (bloc) async {
        final completer = Completer<void>();
        bloc.add(ToggleFavoriteEvent(product: productA, completer: completer));
        await completer.future;
        await Future.delayed(const Duration(milliseconds: 10));
      },
      expect: () => <FavoritesState>[
        FavoritesLoading(),
        FavoritesLoaded(favorites: [productA]),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'toggling twice removes the product from favorites',
      build: () => favoritesBloc,
      act: (bloc) async {
        final c1 = Completer<void>();
        bloc.add(ToggleFavoriteEvent(product: productB, completer: c1));
        await c1.future;
        await Future.delayed(const Duration(milliseconds: 10));

        final c2 = Completer<void>();
        bloc.add(ToggleFavoriteEvent(product: productB, completer: c2));
        await c2.future;
        await Future.delayed(const Duration(milliseconds: 10));
      },
      expect: () => <FavoritesState>[
        FavoritesLoading(),
        FavoritesLoaded(favorites: [productB]),
        FavoritesLoading(),
        FavoritesLoaded(favorites: []),
      ],
    );
  });
}
